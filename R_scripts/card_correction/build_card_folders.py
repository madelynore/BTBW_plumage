"""Step 2 (README.md): build a working folder on the drive for one micaToolbox batch run with card outlines.

For every bird (redo version of the photo view where one exists, otherwise the population
folder; archive_versions skipped), copies the .mspec and its two .SRW photos from
/Volumes/Madelyn Ore/BTBW_measured_photos/ and writes a new ROI .zip = the bird's original
outlines + w1 (white), w2 (18% grey), w3 (dark grey) from the automatic card detection.
For the 10 grey-patch test birds, the hand-drawn t2 (throat avoiding bare patches) is
carried over and the earlier hand-drawn w1-w3 are replaced.
The source files on the drive and in Box/Dropbox are not changed.

Usage (from the project root):  python3 R_scripts/card_correction/build_card_folders.py <view> [bird IDs]
Writes /Volumes/Madelyn Ore/BTBW_card_check/<view>/ and a log in results/card_correction/detection/<view>/build_log.tsv
"""
import glob, json, os, re, shutil, sys, zipfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from card_lib import preview, rect_roi_bytes, visible_srw
from auto_card import detect

VIEW = sys.argv[1] if len(sys.argv) > 1 else "ventral"
# card outline names: w1-w3 in ventral/dorsal (as already built); q1-q3 in side/crown, where w1 is
# the wing spot (2026-10-02)
CARD = ("w1", "w2", "w3") if VIEW in ("ventral", "dorsal") else ("q1", "q2", "q3")
ONLY = set(sys.argv[2:])          # optional: rebuild only these bird IDs
# hand-placed card boxes for photos the detector can't do (checked by eye), full-resolution pixels
MANUAL_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "manual_boxes", f"{VIEW}.json")
MANUAL = json.load(open(MANUAL_FILE)) if os.path.exists(MANUAL_FILE) else {}
SRC = "/Volumes/Madelyn Ore/BTBW_measured_photos"
DEST = f"/Volumes/Madelyn Ore/BTBW_card_check/{VIEW}"
TEST = "temp/grey_patch_check"                 # outline files of the 10 grey-patch test birds (ventral; incl. the t2 throat
                                               # outline, which data_cleaning.R leaves out); if absent, originals are used
os.makedirs(DEST, exist_ok=True)
log_file = f"results/card_correction/detection/{VIEW}/build_log.tsv"; os.makedirs(os.path.dirname(log_file), exist_ok=True)
if ONLY and os.path.exists(log_file):      # keep the other birds' lines
    kept = [l for l in open(log_file) if l.split("\t")[0] not in ONLY]
    log = open(log_file, "w"); log.writelines(kept)
else:
    log = open(log_file, "w"); log.write("ID\tsource_mspec\tstatus\tnote\n")

pick = {}
for m in sorted(glob.glob(f"{SRC}/*/*_{VIEW}.mspec")):
    if "/archive_versions/" in m: continue
    bird = os.path.basename(m).split("_")[0]          # 6-digit ID (a few files have a 7-digit typo)
    # skip a .mspec whose visible photo isn't there under its own name or this bird's ID
    # (e.g. redo/608406_side.mspec names dorsal photos that don't exist) (2026-10-02)
    try: vis = open(m).read().split("\n")[1].split("\t")[0].strip()
    except IndexError: continue        # unreadable .mspec (e.g. Bedford 608618_crown.mspec is a Box error message)
    if not any(os.path.exists(os.path.join(os.path.dirname(m), f)) for f in
               (vis, re.sub(r"^\d{6}", bird, vis), re.sub(r"^\d{6,7}_[a-z]+", f"{bird}_{VIEW}", vis))): continue
    if not os.path.exists(m[:-6] + ".zip") and bird in pick: continue   # e.g. redo/606662_side.mspec has no outline file
    if bird not in pick or ("/redo/" in m and os.path.exists(m[:-6] + ".zip")): pick[bird] = m

n_ok = 0
for bird, m in sorted(pick.items()):
    if ONLY and bird not in ONLY: continue
    folder = os.path.dirname(m); note = []
    lines = open(m).read().split("\n")
    photos = [p.strip() for p in lines[1].split("\t") if p.strip()]
    # photos named in the .mspec but missing: look for the same photo number under this bird's ID
    fixed = []
    for p in photos:
        if not os.path.exists(os.path.join(folder, p)):
            alt = re.sub(r"^\d{6}", bird, p)
            if not os.path.exists(os.path.join(folder, alt)):      # e.g. redo/608406_side.mspec says "dorsal"
                alt = re.sub(r"^\d{6,7}_[a-z]+", f"{bird}_{VIEW}", p)
            if os.path.exists(os.path.join(folder, alt)):
                note.append(f"mspec names {p}, file is {alt}; name corrected in the copy"); p = alt
            else:
                log.write(f"{bird}\t{m}\tskipped\tphoto {p} not found\n"); fixed = None; break
        fixed.append(p)
    if fixed is None: continue
    try:
        r = MANUAL[bird] if bird in MANUAL else detect(preview(os.path.join(folder, fixed[0])))
        if bird in MANUAL: note.append("card boxes placed by hand (" + MANUAL_FILE + ")")
    except Exception as e:
        log.write(f"{bird}\t{m}\tskipped\tcard not detected: {e}\n"); continue
    # copy photos and .mspec (with corrected photo names if needed)
    for p in fixed:
        if not os.path.exists(os.path.join(DEST, p)): shutil.copy2(os.path.join(folder, p), os.path.join(DEST, p))
    lines[1] = "\t".join(fixed)
    open(os.path.join(DEST, f"{bird}_{VIEW}.mspec"), "w").write("\n".join(lines))
    # outlines: originals (or the test-bird version) + automatic w1-w3
    src_zip = os.path.join(folder, f"{bird}_{VIEW}.zip")
    test_zip = os.path.join(TEST, f"{bird}_{VIEW}.zip")
    use_zip = test_zip if os.path.exists(test_zip) else src_zip
    if not os.path.exists(use_zip):
        log.write(f"{bird}\t{m}\tskipped\tno outline file ({os.path.basename(src_zip)})\n"); continue
    if use_zip == test_zip: note.append("outlines from the grey-patch test (incl. t2 if drawn)")
    with zipfile.ZipFile(use_zip) as zin, zipfile.ZipFile(os.path.join(DEST, f"{bird}_{VIEW}.zip"), "w") as zout:
        for n in zin.namelist():
            if n in tuple(c + ".roi" for c in CARD): continue
            zout.writestr(n, zin.read(n))
        for name, key in zip(CARD, ("white", "grey18", "dark_grey")):
            zout.writestr(f"{name}.roi", rect_roi_bytes(*r[key]))
    if r.get("retry"): note.append("card found on the looser retry")
    log.write(f"{bird}\t{m}\tok\t{'; '.join(note)}\n"); n_ok += 1
log.close()
print(f"{VIEW}: {n_ok} birds written to {DEST}")
