# Helpers for the results tables (added 2026-10-03)
# Each analysis writes two things:
#   results/<name>.csv            tidy, one row per estimate, numbers kept as numbers (full precision)
#   results/tables/<name>.html    formatted table for reading (+ .docx for Word when pandoc is available,
#                                 i.e. when knitting from RStudio)
# Use:  source(here("R_scripts/table_helpers.R"))
library(gt)

# p-values: "< 0.001" below 0.001, else 2 significant digits; exact = TRUE gives e.g. "1.5e-13" instead
fmt_p <- function(p, exact = FALSE) {
  small <- if (exact) formatC(p, format = "e", digits = 1) else "<\u00a00.001"
  ifelse(is.na(p), NA_character_, ifelse(p < 0.001, small, sub("\\.$", "", trimws(formatC(signif(p, 2), format = "fg", digits = 2, flag = "#")))))
}

# numbers with n significant digits, without scientific notation where avoidable (e.g. 0.0718)
fmt_num <- function(x, digits = 2) {
  ifelse(is.na(x), NA_character_,
         ifelse(abs(x) >= 10^digits, as.character(round(x)),          # e.g. 144 rather than 140
         ifelse(abs(x) < 1e-3 & x != 0, formatC(x, format = "e", digits = digits - 1),
                # "#" keeps trailing zeros (0.20, not 0.2); trimws drops formatC's padding
                sub("\\.$", "", trimws(formatC(signif(x, digits), format = "fg", digits = digits, flag = "#"))))))
}

# estimate (SE)
fmt_est <- function(est, se, digits = 2) paste0(fmt_num(est, digits), " (", fmt_num(se, digits), ")")

# one lookup for column codes -> readable names, used by every table
patch_labels <- c(lumMean_c = "Crown luminance", lumMean_m = "Mantle luminance", lumMean_o = "Covert luminance",
                  lumMean_t = "Throat luminance", lumMean_w = "Wing spot luminance", area_mm2_w = "Wing spot area (mm²)")
patch_label <- function(code) unname(ifelse(code %in% names(patch_labels), patch_labels[code], code))

# GAM / model terms -> readable names (breeding season = the months averaged in 02_Environment_by_individual.R)
term_labels <- c("s(lon,lat)" = "Location (longitude × latitude)", "s(RH_br)" = "Relative humidity, breeding season",
                 "s(Tave_br)" = "Mean temperature, breeding season", "s(PPT_br)" = "Precipitation, breeding season",
                 "s(srtm)" = "Elevation", "s(ndvi_M)" = "NDVI (maximum)", "Age (SY vs ASY)" = "Age (SY vs ASY)")
term_label <- function(term) unname(ifelse(term %in% names(term_labels), term_labels[term], term))

# for knitr::kable() in the .md files (GitHub can't show merged cells): show a repeated value
# only on the first row of its block, so the column reads like a merged cell
blank_repeats <- function(df, col) { df[[col]][duplicated(df[[col]])] <- ""; df }

# write results/tables/<name>.html, and .docx when pandoc is available
save_table <- function(gt_obj, name, dir = here::here("results/tables")) {
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  gt::gtsave(gt_obj, file.path(dir, paste0(name, ".html")))
  if (rmarkdown::pandoc_available()) gt::gtsave(gt_obj, file.path(dir, paste0(name, ".docx")))
  invisible(gt_obj)
}

# shared look: bold row-group headers, compact rows
style_table <- function(gt_obj) {
  gt_obj %>%
    tab_style(cell_text(weight = "bold"), cells_row_groups()) %>%
    tab_options(table.font.size = px(13), data_row.padding = px(3), row_group.padding = px(4),
                source_notes.font.size = px(12))
}
