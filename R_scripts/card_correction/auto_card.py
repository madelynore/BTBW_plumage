"""Find the three QPcard patches in a photo and make rectangle ROIs inside them.

Layout (all photos seen so far): the card lies below the specimen, with a cream/white patch,
a mid-grey patch (the 18% standard) and a dark-grey patch side by side, separated by thin white
strips, and a ruler printed along the top edge. Detection, on the camera's embedded JPEG preview
(same pixel grid as the .mspec's visible photo):
  1. downsample 12x, grey = mean of RGB
  2. "uniform" pixels: low local variation (5x5 SD)
  3. connected blobs of uniform pixels within a narrow brightness range; keep large,
     rectangle-filling blobs
  4. the two darkest large rectangular blobs below the specimen = mid grey and dark grey
     (darker one = dark grey); the white patch = the uniform bright blob on the far side of the
     mid grey from the dark grey or, if it has merged with the background paper, the box one
     patch-step beyond the mid grey (checked to be bright and uniform)
  5. ROI = square in the middle of each patch, side 40% of the patch's shorter side, kept out of
     the top 30% of the patch (ruler ticks)
Writes nothing itself; used by detect_cards.py and build_card_folders.py.
"""
from collections import deque
import numpy as np
from PIL import Image

SCALE = 12

def uniform_mask(g, sd_max=2.5):
    # local SD in 5x5 windows via cumulative sums
    k = 5; pad = k // 2
    gp = np.pad(g, pad, mode="edge")
    c1 = np.cumsum(np.cumsum(gp, 0), 1); c2 = np.cumsum(np.cumsum(gp ** 2, 0), 1)
    def box(c):
        c = np.pad(c, ((1, 0), (1, 0)))
        return c[k:, k:] - c[:-k, k:] - c[k:, :-k] + c[:-k, :-k]
    n = k * k
    mean = box(c1) / n; var = box(c2) / n - mean ** 2
    return np.sqrt(np.clip(var, 0, None)) < sd_max

def blobs(mask, g, tol=6):
    """Connected blobs of masked pixels whose brightness stays within tol of the seed."""
    h, w = mask.shape; label = -np.ones((h, w), int); out = []
    for y0 in range(h):
        for x0 in range(w):
            if not mask[y0, x0] or label[y0, x0] >= 0: continue
            seed = g[y0, x0]; q = deque([(y0, x0)]); label[y0, x0] = len(out); pts = []
            while q:
                y, x = q.popleft(); pts.append((y, x))
                for yy, xx in ((y + 1, x), (y - 1, x), (y, x + 1), (y, x - 1)):
                    if 0 <= yy < h and 0 <= xx < w and mask[yy, xx] and label[yy, xx] < 0 and abs(g[yy, xx] - seed) < tol:
                        label[yy, xx] = len(out); q.append((yy, xx))
            ys, xs = np.array(pts).T
            out.append(dict(n=len(pts), x0=xs.min(), x1=xs.max(), y0=ys.min(), y1=ys.max(),
                            gray=float(g[ys, xs].mean()), cx=xs.mean(), cy=ys.mean()))
    for b in out:
        b["fill"] = b["n"] / ((b["x1"] - b["x0"] + 1) * (b["y1"] - b["y0"] + 1))
    return out

def detect(img):
    """Try the strict settings first; if the card isn't found (e.g. card cut off at the frame
    edge with a slight light fall-off), retry with looser uniformity/brightness tolerances."""
    try:
        return _detect(img, sd_max=2.5, tol=6, relative=False)
    except (ValueError, TypeError):
        out = _detect(img, sd_max=4.0, tol=12, relative=True)
        out["retry"] = True
        return out

def _best_spot(g, p, side, top_frac=0.35):
    """Most uniform side x side box inside patch p (small-image coordinates), below the ruler
    zone; used when the default spot is covered (feather, tag, speck)."""
    s = max(2, int(round(side)))
    best = None
    for y in range(int(p["y0"] + top_frac * (p["y1"] - p["y0"])), int(p["y1"] - s), 2):
        for x in range(int(p["x0"] + 2), int(p["x1"] - s - 2), 2):
            sd = g[y:y + s, x:x + s].std()
            if best is None or sd < best[0]: best = (sd, x, y)
    return best

def _detect(img, sd_max, tol, relative):
    """img: PIL RGB preview. Returns {'white'|'grey18'|'dark_grey': (left, top, right, bottom)} in
    full-resolution pixels, plus diagnostics; raises ValueError if the card isn't found."""
    small = img.resize((img.size[0] // SCALE, img.size[1] // SCALE), Image.BILINEAR)
    g = np.asarray(small, float).mean(axis=2)
    B = blobs(uniform_mask(g, sd_max), g, tol)
    min_area = 0.004 * g.size                      # a patch is ~1.5-3% of the frame
    rect = [b for b in B if b["n"] > min_area and b["fill"] > 0.6]
    # grey patches: darker than a fixed level (strict pass) or, on the retry, clearly darker
    # than the brightest large uniform area (bright exposures)
    grey_max = 170 if not relative else max(b["gray"] for b in rect) - 25
    greys = sorted([b for b in rect if b["gray"] < grey_max], key=lambda b: -b["n"])[:4]
    if len(greys) < 2: raise ValueError("fewer than 2 grey patches found")
    # the two grey patches: similar size and height, side by side
    best = None
    for i in range(len(greys)):
        for j in range(i + 1, len(greys)):
            a, b = greys[i], greys[j]
            score = abs(a["cy"] - b["cy"]) + abs((a["y1"] - a["y0"]) - (b["y1"] - b["y0"])) - 0.01 * (a["n"] + b["n"])
            if abs(a["gray"] - b["gray"]) > 3 and (best is None or score < best[0]): best = (score, a, b)
    if best is None: raise ValueError("no pair of grey patches with different brightness")
    _, a, b = best
    dark, mid = (a, b) if a["gray"] < b["gray"] else (b, a)
    # white patch: by default the mid-grey patch's box moved one patch-step further from the dark
    # grey (the three patches are equal and evenly spaced; the cream patch often merges with the
    # background paper, which makes its blob the wrong shape). Checked to be bright and uniform;
    # if not, fall back to a separate bright rectangular blob in that direction.
    dx = mid["cx"] - dark["cx"]
    white = dict(x0=mid["x0"] + dx, x1=mid["x1"] + dx, y0=mid["y0"], y1=mid["y1"], cx=mid["cx"] + dx, cy=mid["cy"])
    x0 = int(max(0, white["x0"] + 0.2 * (white["x1"] - white["x0"]))); x1 = int(min(g.shape[1], white["x1"] - 0.2 * (white["x1"] - white["x0"])))
    y0 = int(white["y0"] + 0.4 * (white["y1"] - white["y0"])); y1 = int(white["y1"] - 0.1 * (white["y1"] - white["y0"]))
    region = g[y0:y1, x0:x1]
    white_margin = 40 if not relative else 25
    if region.size > 0 and region.mean() > mid["gray"] + white_margin and region.std() < (6 if not relative else 15) and white["x0"] >= 0 and white["x1"] < g.shape[1]:
        white["gray"] = float(region.mean())
    else:
        whites = [w for w in rect if w["gray"] > mid["gray"] + white_margin and abs(w["cy"] - mid["cy"]) < 0.5 * (mid["y1"] - mid["y0"])
                  and np.sign(w["cx"] - mid["cx"]) == np.sign(dx) and abs(w["cx"] - mid["cx"]) < 2.2 * abs(dx)]
        if not whites: raise ValueError("white patch not found")
        white = min(whites, key=lambda w: abs(abs(w["cx"] - mid["cx"]) - abs(dx)))
    out = {}
    for name, p in (("white", white), ("grey18", mid), ("dark_grey", dark)):
        w_, h_ = p["x1"] - p["x0"], p["y1"] - p["y0"]
        side = 0.4 * min(w_, h_)
        cx = (p["x0"] + p["x1"]) / 2; cy = p["y0"] + 0.65 * h_          # below the ruler ticks
        cy = min(cy, p["y1"] - side / 2 - 1)
        l, t = cx - side / 2, cy - side / 2
        s_ = max(2, int(round(side)))
        box = g[int(t):int(t) + s_, int(l):int(l) + s_]
        if box.size == 0 or box.std() > 4:                     # covered: move to the cleanest spot
            spot = _best_spot(g, p, side)
            if spot is not None: _, l, t = spot
        out[name] = tuple(int(round(v * SCALE)) for v in (l, t, l + side, t + side))
        out[name + "_gray"] = p["gray"]
    return out
