"""Step 1 (README.md): run the card detector on every .mspec of one view (redo version where a bird has
one, otherwise its population folder; archive_versions skipped), for checking by eye before the
batch folders are built. No ROI files are written here.

Usage (from the project root):  python3 R_scripts/card_correction/detect_cards.py <ventral|dorsal|side|crown>
Writes results/card_correction/detection/<view>/detections.tsv (boxes, mean grey and SD of each patch;
check = LOOK if the patches aren't white > grey > dark or aren't uniform) and contact sheets sheet_XX.png
(20 photos each, white/18%/dark boxes in red/blue/green). Photos the detector gets wrong get hand-placed
boxes in manual_boxes/<view>.json (used by build_card_folders.py)."""
import glob, os, re, sys, time
import numpy as np
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from card_lib import preview, visible_srw
from auto_card import detect
VIEW = sys.argv[1] if len(sys.argv) > 1 else "ventral"
# Paths
R = "/Volumes/Madelyn Ore/BTBW_measured_photos"          # .mspec, .SRW and outline .zip files, by population folder
out = f"results/card_correction/detection/{VIEW}"; os.makedirs(out, exist_ok=True)
pick = {}
for m in sorted(glob.glob(f"{R}/*/*_{VIEW}.mspec")):
    if "/archive_versions/" in m: continue
    bird = os.path.basename(m)[:6]
    # skip a .mspec whose visible photo isn't there under its own name or this bird's ID
    # (e.g. redo/608406_side.mspec names dorsal photos that don't exist) (2026-10-02)
    try: vis = open(m).read().split("\n")[1].split("\t")[0].strip()
    except IndexError: continue        # unreadable .mspec (e.g. Bedford 608618_crown.mspec is a Box error message)
    if not any(os.path.exists(os.path.join(os.path.dirname(m), f)) for f in (vis, re.sub(r"^\d{6}", bird, vis))): continue
    if bird not in pick or "/redo/" in m: pick[bird] = m
rows, thumbs = [], []
for bird, m in sorted(pick.items()):
    srw = os.path.join(os.path.dirname(m), visible_srw(m))
    try:
        im = preview(srw); a = np.asarray(im, float).mean(axis=2); r = detect(im); status = "ok"
    except Exception as e:
        rows.append(dict(ID=bird, mspec=m, status=f"FAILED: {e}")); print(bird, "FAILED", e, flush=True); continue
    row = dict(ID=bird, mspec=m, status=status)
    dr = ImageDraw.Draw(im)
    for k, col in (("white", (255, 0, 0)), ("grey18", (0, 140, 255)), ("dark_grey", (0, 190, 0))):
        l, t, rr, b = r[k]; p = a[t:b, l:rr]
        row.update({f"{k}_box": f"{l},{t},{rr},{b}", f"{k}_gray": round(p.mean(), 1), f"{k}_sd": round(p.std(), 2)})
        dr.rectangle([l, t, rr, b], outline=col, width=18)
    ok_order = row["white_gray"] > row["grey18_gray"] > row["dark_grey_gray"]
    row["retry"] = r.get("retry", False)
    row["check"] = "ok" if ok_order and max(row["white_sd"], row["grey18_sd"], row["dark_grey_sd"]) < 5 else "LOOK"
    rows.append(row)
    im.thumbnail((560, 374)); ImageDraw.Draw(im).text((8, 8), f"{bird} {row['check']}", fill=(255, 0, 0)); thumbs.append(im)
cols = sorted({k for r in rows for k in r}, key=lambda k: (k not in ("ID", "status", "check"), k))
with open(f"{out}/detections.tsv", "w") as f:
    f.write("\t".join(cols) + "\n")
    for r in rows: f.write("\t".join(str(r.get(c, "")) for c in cols) + "\n")
for s in range(0, len(thumbs), 20):
    sheet = Image.new("RGB", (560 * 4, 374 * 5), "white")
    for i, t in enumerate(thumbs[s:s + 20]): sheet.paste(t, ((i % 4) * 560, (i // 4) * 374))
    sheet.save(f"{out}/sheet_{s // 20 + 1:02d}.png")
n_ok = sum(1 for r in rows if r.get("check") == "ok")
print(f"{VIEW}: {len(rows)} photos | ok {n_ok} | LOOK {sum(1 for r in rows if r.get('check') == 'LOOK')} | failed {sum(1 for r in rows if r['status'] != 'ok')}")
