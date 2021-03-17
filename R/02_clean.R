# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------



# Load data ---------------------------------------------------------------
gravier_data_x <- read_tsv(file = "data/01_gravier_x.tsv.gz")
gravier_data_y <- read_tsv(file = "data/01_gravier_y.tsv.gz")

# Wrangle data ------------------------------------------------------------
gravier_data <- bind_cols(gravier_data_x, gravier_data_y)


# Write data --------------------------------------------------------------
write_tsv(x = gravier_data,
          path = "data/02_gravier_data.tsv.gz")
