"""Shared helpers for the automatic QPcard outlines (ImageJ ROI files, SRW previews)."""
import io, struct, zipfile
import numpy as np
from PIL import Image

def preview(srw_path):
    """The camera's embedded full-size JPEG (5472 x 3648) from a Samsung .SRW."""
    b = open(srw_path, "rb").read()
    best, i = None, b.find(b"\xff\xd8\xff")
    while i != -1:
        e = b.find(b"\xff\xd9", i)
        try:
            im = Image.open(io.BytesIO(b[i:e + 2])); im.load()
            if best is None or im.size[0] > best.size[0]: best = im
        except Exception:
            pass
        i = b.find(b"\xff\xd8\xff", i + 3)
    return best.convert("RGB")

def read_rois(zip_path):
    """{name: (type, left, top, right, bottom)} from an ImageJ ROI zip."""
    out = {}
    with zipfile.ZipFile(zip_path) as z:
        for n in z.namelist():
            b = z.read(n)
            top, left, bottom, right = struct.unpack(">hhhh", b[8:16])
            out[n[:-4] if n.endswith(".roi") else n] = (b[6], left, top, right, bottom)
    return out

def rect_roi_bytes(left, top, right, bottom):
    """A minimal ImageJ rectangle ROI (64-byte header, version 227, no header2)."""
    h = bytearray(64)
    h[0:4] = b"Iout"
    h[4:6] = struct.pack(">h", 227)
    h[6] = 1                                   # rectangle
    h[8:16] = struct.pack(">hhhh", top, left, bottom, right)
    return bytes(h)

def visible_srw(mspec_path):
    """First photo named in the .mspec (the visible one; the second is UV)."""
    with open(mspec_path) as f:
        lines = f.read().splitlines()
    return lines[1].split("\t")[0].strip()
