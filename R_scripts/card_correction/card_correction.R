# Card correction of the micaToolbox measurements (step 4 of README.md in this folder) -------------------
# Written 2026-10-02/03 
# Reads the batch results of the card-check folders (original plumage outlines + card outlines, made by
# build_card_folders.py and measured with micaToolbox "Batch Multispectral Image Analysis").
# Card outlines: w1-w3 in ventral/dorsal, q1-q3 in side/crown (w1 is the wing spot there);
# 1 = white, 2 = 18% grey, 3 = dark grey.
#
# Correction, per photo and channel. Model: measured = g * (ref18 + k * (true - ref18)), where
#   g = exposure (gain) error = grey18 / ref18   (photo's 18% patch vs the reference)
#   k = contrast around the 18% standard, from the dark and white patches after removing g:
#       k = mean of (dark/g - ref18) / (ref_dark - ref18) and (white/g - ref18) / (ref_white - ref18)
#   ref_* = mean of that patch over all photos of the same view, per channel
# so  corrected = ref18 + (measured / g - ref18) / k        (SDs: SD / (g * k))
# Exceptions: UV and crown: g only (k = 1); 608348 side: k from the white patch only; photos whose card
# outlines fail a plausibility check are left uncorrected and listed (none in the final data).
#
# Run from the project root:  Rscript R_scripts/card_correction/card_correction.R
# Writes
#   data_raw/card_corrected_mspec/<view>_card_corrected_Image Analysis Results.csv  (read by data_cleaning.R)
#   data_raw/card_corrected_mspec/card_k_by_photo.csv     card values, g and k per photo x channel
#   results/card_correction/corrected_wide.csv, remeasured_wide.csv   one row per bird (checks)
#   results/card_correction/project_vs_remeasured_by_photo.csv        original vs re-measured (uncorrected)
#   results/card_correction/card_boxes_to_check.csv                   photos failing the plausibility check

# Paths ------------------------------------------------------------------------------------------------
base      <- "/Volumes/Madelyn Ore/BTBW_card_check"        # card-check folders: <view>/, crown_fix/
redo_dirs <- path.expand(c("~/Documents/Work/PhD/BTBW_redo/done", "~/Documents/Work/PhD/BTBW_redo/RUN_THIS_BATCH"))
out_data  <- "data_raw/card_corrected_mspec"
out       <- "results/card_correction"

suppressPackageStartupMessages(library(tidyverse))
dir.create(out, showWarnings = FALSE, recursive = TRUE); dir.create(out_data, showWarnings = FALSE, recursive = TRUE)
means <- c("lumMean", "lwMean", "mwMean", "swMean", "uvMean", "dblMean")
sds   <- sub("Mean", "SD", means)
card_names <- list(ventral = c("w1", "w2", "w3"), dorsal = c("w1", "w2", "w3"),
                   side = c("q1", "q2", "q3"), crown = c("q1", "q2", "q3"))

views <- names(card_names)[file.exists(file.path(base, names(card_names),
                            "Image Analysis Results Samsung NX1000 Nikkor EL 80mm D65 to Bluetit D65.csv"))]
cat("Views with batch results:", paste(views, collapse = ", "), "\n")
res <- map_dfr(views, function(v)
  read.csv(file.path(base, v, "Image Analysis Results Samsung NX1000 Nikkor EL 80mm D65 to Bluetit D65.csv")) %>%
    select(-any_of("X")) %>% mutate(file_view = v)) %>%
  separate(Label, c("ID", "view", "roi"), sep = "_", extra = "merge", remove = FALSE) %>%
  filter(!grepl("^Scale", roi)) %>%
  # two Carter birds have 7-digit typo file names (6129897, 6129898 = 612897, 612898); they also
  # have a correctly named redo/ version, which was built too: keep that one
  mutate(ID6 = if_else(nchar(ID) == 7, paste0(substr(ID, 1, 3), substr(ID, 5, 7)), ID)) %>%
  group_by(ID6, view) %>% filter(!(nchar(ID) == 7 & any(nchar(ID) == 6))) %>% ungroup() %>%
  mutate(ID = ID6, Label = paste(ID, view, roi, sep = "_")) %>% select(-ID6)

# Redo measurements (2026-10-02, redo_dirs): used only for the photos that had no usable earlier
# measurement; they replace any card-check rows for that photo. (The other redo items keep their old
# .mspec + card correction.)
redo_use  <- c("613585_crown", "613586_crown", "613591_crown", "608348_dorsal", "608618_crown",
               "606662_side", "614305_ventral")
redo <- map_dfr(redo_dirs, function(d) {
  f <- file.path(d, "Image Analysis Results Samsung NX1000 Nikkor EL 80mm D65 to Bluetit D65.csv")
  if (file.exists(f)) read.csv(f) %>% select(-any_of("X")) else NULL }) %>%
  separate(Label, c("ID", "view", "roi"), sep = "_", extra = "merge", remove = FALSE) %>%
  filter(paste(ID, view, sep = "_") %in% redo_use, !grepl("^Scale", roi)) %>%
  mutate(file_view = view) %>% distinct(Label, .keep_all = TRUE)
cat("Redo photos used:", n_distinct(paste(redo$ID, redo$view)), "of", length(redo_use), "\n")
res <- res %>% filter(!paste(ID, view, sep = "_") %in% paste(redo$ID, redo$view, sep = "_")) %>% bind_rows(redo)

# Crown photos whose automatic card boxes were wrong, re-measured with hand-placed boxes
# (manual_boxes/crown.json; batch folder <base>/crown_fix/, 2026-10-02): replace those photos' rows when present
cf <- file.path(base, "crown_fix", "Image Analysis Results Samsung NX1000 Nikkor EL 80mm D65 to Bluetit D65.csv")
if (file.exists(cf)) {
  fixr <- read.csv(cf) %>% select(-any_of("X")) %>% mutate(file_view = "crown") %>%
    separate(Label, c("ID", "view", "roi"), sep = "_", extra = "merge", remove = FALSE) %>% filter(!grepl("^Scale", roi))
  cat("crown_fix photos used:", n_distinct(fixr$ID), "\n")
  res <- res %>% filter(!(view == "crown" & ID %in% fixr$ID)) %>% bind_rows(fixr)
} else cat("crown_fix not measured yet: those crown photos stay uncorrected\n")

# card patches per photo x channel
card <- res %>% rowwise() %>%
  mutate(patch = c("white", "grey18", "dark")[match(roi, card_names[[file_view]])]) %>% ungroup() %>%
  filter(!is.na(patch)) %>% select(ID, view, patch, all_of(means)) %>%
  pivot_longer(all_of(means), names_to = "channel") %>% pivot_wider(names_from = patch, values_from = value)
# Reference = the average photo of the same view (crown close-ups are set up differently from the
# other views, so photos are corrected towards their own view's average) (changed 2026-10-02;
# with ventral + dorsal only, the pooled and per-view references were nearly the same)
ref <- card %>% group_by(view, channel) %>% summarise(ref_white = mean(white), ref_grey18 = mean(grey18), ref_dark = mean(dark), .groups = "drop")
# Which patch(es) measure contrast (2026-10-02):
#   crown: exposure (g) only, no contrast correction. The white patch is clipped in the crown close-ups
#          (reads 0.93 vs 0.73 in the other views, up to 1.04; dark-vs-white agreement r = 0.07), and
#          k from the dark patch alone was too noisy: it scrambled the crown values (r = 0.20 with
#          measured) while the measured crown had no session effect to correct (18e).
#   608348 side: white patch only; the automatic dark-patch box landed on the bird's black face
bad_dark <- c("608348_side")
card <- card %>% left_join(ref, by = c("view", "channel")) %>%
  mutate(g = grey18 / ref_grey18,
         k_dark = (dark / g - ref_grey18) / (ref_dark - ref_grey18), k_white = (white / g - ref_grey18) / (ref_white - ref_grey18),
         k = case_when(channel == "uvMean" ~ 1,
                       view == "crown" ~ 1,
                       paste(ID, view, sep = "_") %in% bad_dark ~ k_white,
                       TRUE ~ (k_dark + k_white) / 2))
# Sanity check of the card boxes (2026-10-02): the ratios between patches don't depend on exposure,
# so a photo whose boxes sit on the right patches has white > 3 x the 18% patch and dark 0.4-0.8 x it
# (judged on the luminance channel; the dark check is skipped where the dark box is known to be bad).
# Photos that fail (boxes on the wrong patch, e.g. crown 608346, 608628) are NOT corrected: their
# measured values are kept (g = k = 1) and they are listed in card_boxes_to_check.csv.
card_ok <- card %>% filter(channel == "lumMean") %>%
  transmute(ID, view, card_ok = white > 3 * grey18 &
              (paste(ID, view, sep = "_") %in% bad_dark | (dark > 0.4 * grey18 & dark < 0.8 * grey18)))
card <- card %>% left_join(card_ok, by = c("ID", "view")) %>%
  mutate(g = if_else(card_ok, g, 1), k = if_else(card_ok, k, 1))
write_csv(card %>% filter(!card_ok, channel == "lumMean") %>% select(ID, view, white, grey18, dark),
          file.path(out, "card_boxes_to_check.csv"))
cat("Photos left uncorrected (card boxes implausible):", sum(!card_ok$card_ok), "\n")
print(table(card_ok$view, card_ok$card_ok, dnn = c("view", "card ok")))
write_csv(card, file.path(out_data, "card_k_by_photo.csv"))
cat("Photos with card values:", n_distinct(paste(card$ID, card$view)), "| r(k_dark, k_white) by channel (crown and", bad_dark, "left out):\n")
print(card %>% filter(view != "crown", !paste(ID, view, sep = "_") %in% bad_dark) %>% group_by(channel) %>% summarise(r = round(cor(k_dark, k_white), 2), k_sd = round(sd(k_dark + k_white) / 2, 3),
                                                g_sd = round(sd(g), 3), g_range = paste(round(range(g), 2), collapse = "-")) %>% as.data.frame())

# plumage outlines: correct means and SDs
plum <- res %>% rowwise() %>% filter(!roi %in% card_names[[file_view]]) %>% ungroup()
long <- plum %>% select(Label, ID, view, roi, all_of(means), all_of(sds), area) %>%
  pivot_longer(c(all_of(means), all_of(sds)), names_to = "col") %>%
  mutate(channel = sub("SD$", "Mean", col)) %>%
  left_join(card %>% select(ID, view, channel, g, ref_grey18, k), by = c("ID", "view", "channel")) %>%
  mutate(corrected = if_else(grepl("Mean$", col), ref_grey18 + (value / g - ref_grey18) / k, value / (g * k)))
no_card <- long %>% filter(is.na(k)) %>% distinct(ID, view)
if (nrow(no_card)) { cat("Photos without card values (left out):\n"); print(as.data.frame(no_card)) }
# UV unusable where the .mspec uses the visible photo as the UV photo (found by checking every .mspec's photo list)
no_uv <- tibble(ID = c("606654", "612882", "612884"), view = c("dorsal", "dorsal", "side"))
cat("UV set to NA (visible photo used as UV):", paste(no_uv$ID, no_uv$view, collapse = ", "), "\n")
long <- long %>% left_join(no_uv %>% mutate(no_uv = TRUE), by = c("ID", "view")) %>%
  mutate(corrected = if_else(channel == "uvMean" & coalesce(no_uv, FALSE), NA_real_, corrected))
corr <- long %>% filter(!is.na(k)) %>% select(Label, ID, view, roi, area, col, corrected) %>%
  pivot_wider(names_from = col, values_from = corrected) %>% select(Label, all_of(as.vector(rbind(means, sds))), area)
for (v in views) write.csv(corr %>% filter(sub("^[^_]+_([^_]+)_.*", "\\1", Label) == v),
                           file.path(out_data, paste0(v, "_card_corrected_Image Analysis Results.csv")))

# wide tables, coded like data_cleaning.R: dorsal -> m, crown -> c, belly dropped; throat = t1 only
to_wide <- function(d) d %>% separate(Label, c("ID", "view", "roi"), sep = "_", extra = "merge") %>%
  mutate(pl_code = sub("[0-9]+$", "", roi),
         pl_code = case_when(view == "dorsal" ~ "m", view == "crown" ~ "c", TRUE ~ pl_code)) %>%
  filter(pl_code != "b", !(pl_code == "t" & roi != "t1"), pl_code %in% c("t", "m", "c", "o", "w")) %>%
  group_by(ID, pl_code) %>% summarise(across(c(all_of(means), all_of(sds), area), mean), .groups = "drop") %>%
  pivot_wider(names_from = pl_code, values_from = c(all_of(means), all_of(sds), area), names_sep = "_") %>%
  mutate(ID = as.integer(ID))
write_csv(to_wide(corr), file.path(out, "corrected_wide.csv"))
write_csv(to_wide(plum %>% select(Label, all_of(means), all_of(sds), area)), file.path(out, "remeasured_wide.csv"))

# project values vs re-measured (same outline, uncorrected): mismatches = different photo or .mspec
proj <- map_dfr(list.files("data_raw/by_pop_batch_mspec", "Image", full.names = TRUE),
                ~ read.csv(.x) %>% mutate(project_file = sub("_scaled.*", "", basename(.x)))) %>%
  separate(Label, c("ID", "view", "roi"), sep = "_", extra = "merge") %>% filter(!grepl("^Scale|whole", roi)) %>%
  distinct(ID, view, roi, .keep_all = TRUE) %>% select(ID, view, roi, project_file, lum_project = lumMean)
cmp <- inner_join(proj, plum %>% select(ID, view, roi, lum_remeasured = lumMean), by = c("ID", "view", "roi")) %>%
  group_by(ID, view, project_file) %>%
  summarise(n_outlines = n(), lum_project = mean(lum_project), lum_remeasured = mean(lum_remeasured),
            ratio = lum_remeasured / lum_project, .groups = "drop") %>% arrange(desc(abs(log(ratio))))
write_csv(cmp, file.path(out, "project_vs_remeasured_by_photo.csv"))
cat("\nPhotos compared:", nrow(cmp), "| identical (ratio within 0.5%):", sum(abs(cmp$ratio - 1) < 0.005),
    "| differ by > 2%:", sum(abs(cmp$ratio - 1) > 0.02), "\n")
print(cmp %>% filter(abs(ratio - 1) > 0.02) %>% as.data.frame(), digits = 3)
