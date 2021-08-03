########################################################
# Script to generate figures for SpatialExperiment paper
# Lukas Weber, August 2021
########################################################

# using code from ggspavis package vignette


library(SpatialExperiment)
library(STexampleData)
library(ggspavis)
library(ggplot2)


# ------------------------------------------------
# 10x Genomics Visium: mouse coronal brain section
# ------------------------------------------------

# load data
spe <- load_data("Visium_mouseCoronal")
# add some values in 'colData' to show using color scale
colData(spe)$sum <- colSums(counts(spe))
# plot
plotVisium(spe, fill = "sum", highlight = "in_tissue") + 
  scale_fill_viridis_c(trans = "log", breaks = c(403, 2981, 22026)) + 
  theme(strip.text.x = element_blank())
ggsave("plots/Fig_Visium_mouseCoronal.png", width = 4.5, height = 4)


# ----------------------------------------
# 10x Genomics Visium: human brain (DLPFC)
# ----------------------------------------

# load data
spe <- load_data("Visium_humanDLPFC")
# modify 'ground_truth' factor to show NAs (background spots)
colData(spe)$ground_truth <- as.character(colData(spe)$ground_truth)
colData(spe)$ground_truth[is.na(colData(spe)$ground_truth)] <- "NA"
colData(spe)$ground_truth <- factor(colData(spe)$ground_truth, levels = c(paste0("Layer", 1:6), "WM", "NA"))
# update 'libd_layer_colors' palette to include lighter gray
palette <- c("#F0027F", "#377EB8", "#4DAF4A", "#984EA3", "#FFD700", "#FF7F00", "#1A1A1A", "gray55")
# plot
plotVisium(spe, fill = "ground_truth", highlight = "in_tissue", palette = palette) + 
  theme(strip.text.x = element_blank()) + 
  ggtitle("Visium human DLPFC")
ggsave("plots/Fig_Visium_humanDLPFC.png", width = 5, height = 4.5)

# alternatively
palette <- c("#F0027F", "#377EB8", "#4DAF4A", "#984EA3", "#FFD700", "#FF7F00", "#1A1A1A", "gray80")
plotSpots(spe, annotate = "ground_truth", palette = palette)
ggsave("plots/Fig_Visium_humanDLPFC_alt.png", width = 4.25, height = 3.5)


# ---------------------
# seqFISH: mouse embryo
# ---------------------

# load data
spe_seqfish <- load_data("seqFISH_mouseEmbryo")
# plot
plotMolecules(spe_seqfish, molecule = "Sox2") + 
  ggtitle("seqFISH mouse embryogenesis: Sox2")
ggsave("plots/Fig_seqFISH_mouseEmbryo.png", width = 4.75, height = 5.75)

