# Card correction of the plumage measurements

Every specimen photo includes a QPcard 101 (white, 18% grey and dark grey patches). micaToolbox normalises each image to the 18% patch, which corrects exposure but not contrast. Contrast differed between photo sessions: the dark patch read lighter and the white patch darker in some sessions. These scripts measure the card in every photo and correct each photo's plumage values for both exposure and contrast.

The output is `data_raw/card_corrected_mspec/`, which `R_scripts/data_cleaning.R` reads when `use_card_corrected <- TRUE`. The uncorrected measurements stay in `data_raw/by_pop_batch_mspec/`.

## Requirements
- **Python 3 with numpy and Pillow:** steps 1–2.
- **ImageJ with micaToolbox:** step 3.
- **R with tidyverse:** step 4.
- **The photo drive:** paths are set at the top of each script, `/Volumes/Madelyn Ore/...`.

## Steps (run from the project root)

1. **Find the card in every photo:** `python3 R_scripts/card_correction/detect_cards.py <view>`, for ventral, dorsal, side and crown.
   - **How it works:** it reads the full-size JPEG embedded in each raw .SRW photo, which has the same pixel grid as the .mspec image. It finds the two grey patches as large uniform rectangles below the specimen, places the white patch one patch-step beyond the mid grey, and puts a square box (40% of the patch's shorter side, clear of the ruler) in each patch.
   - **Output:** `results/card_correction/detection/<view>/`, with a table and contact sheets to check by eye.
   - **When it gets a photo wrong:** add hand-placed boxes (full-resolution pixels) to `manual_boxes/<view>.json`. Eight crown photos needed this: the white patch was cut off in two, and automatic placement failed in six.
2. **Build the batch folders:** `python3 R_scripts/card_correction/build_card_folders.py <view> [bird IDs]`.
   - **What it builds:** for each bird, a copy of its .mspec, both photos, and its outline .zip with the card boxes added. They are named w1–w3 in ventral/dorsal, and q1–q3 in side/crown, where w1 is the wing spot (1 = white, 2 = 18%, 3 = dark).
   - **Where:** `/Volumes/Madelyn Ore/BTBW_card_check/<view>/`. The original files aren't changed.
3. **Measure:** in ImageJ, run micaToolbox *Batch Multispectral Image Analysis* on each folder.
   - **Settings:** the same as the original measurements: cone-catch model "Samsung NX1000 Nikkor EL 80mm D65 to Bluetit D65", scale 36.5 px/mm.
   - **Re-measured photos:** the six crowns with hand-placed boxes were re-measured in `crown_fix/`.
4. **Correct:** `Rscript R_scripts/card_correction/card_correction.R`.
   - **For each photo and channel:**
     - exposure g = the 18% patch / its mean over all photos of that view;
     - contrast k = the mean of the estimates from the dark and white patches;
     - corrected = r18 + (measured/g − r18)/k.
   - **Exceptions:**
     - UV and crown: g only;
     - 608348 side: k from the white patch;
     - photos failing the card plausibility check (white > 3 × 18%, dark 0.4–0.8 × 18%) are left uncorrected and listed. None fail in the final data.
   - **Output:** `data_raw/card_corrected_mspec/` and checks in `results/card_correction/`.

## Checks (2026-10-03)
- **The script reproduces `data_raw/card_corrected_mspec/` byte for byte.** The detector reproduces the recorded card boxes.
- **The two contrast estimates agree:** dark-patch and white-patch estimates of k correlate at r = 0.94 across photos (ventral, dorsal and side), so the contrast differences between photos are real.
- **Size of the corrections:**
  - exposure g: median 1.00, SD 0.01–0.03 by view;
  - contrast k: median 0.96, range 0.80–1.18.
- **Session effect:** photo day explained 57% of the within-site variance in throat luminance before correction and 13% after.

The full method and the remaining checks are in the manuscript methods.
