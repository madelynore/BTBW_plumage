Card-corrected micaToolbox measurements (made 2026-10-03)

<view>_card_corrected_Image Analysis Results.csv (ventral, dorsal, side, crown)
  Same columns and Label format (ID_view_outline) as the micaToolbox output in data_raw/photos/by_pop_batch_mspec/,
  so R_scripts/01_data_cleaning.R reads either folder (switch use_card_corrected).
  One row per bird and outline. Values = micaToolbox measurements of the original plumage outlines,
  corrected per photo with the QPcard 101 in the frame:
    measured = g * (r18 + k * (true - r18))  ->  corrected = r18 + (measured / g - r18) / k ; SD / (g * k)
    g = photo's 18% patch / reference (exposure); k = contrast from the white and dark patches;
    reference r = mean of each card patch over all photos of the same view.
  Exceptions:
    - UV and crown: g only (k = 1);
    - 608348 side: k from the white patch only;
    - UV set to NA for 606654 dorsal, 612882 dorsal, 612884 side (visible photo used as the UV photo).
  Includes re-measured photos (correct photo where the original .mspec pointed to another one) and
  the 2026 redo birds.

card_k_by_photo.csv
  Card values, g and k for every photo and channel.

Made by R_scripts/00_card_correction/card_correction.R (see R_scripts/00_card_correction/README.md).
Method and checks: R_scripts/00_card_correction/README.md.
Uncorrected measurements: data_raw/photos/by_pop_batch_mspec/ (unchanged).
