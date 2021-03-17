# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
#source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_clean <- read_tsv(file = "data/02_my_data_clean.tsv.gz")


# Wrangle data ------------------------------------------------------------
gravier_data <- my_data_clean %>%
  mutate(outcome = case_when(value == "good" ~ 0,
                             value == "poor" ~ 1)) %>% 
  select(-value)

# Creating a long version of the data
gravier_data_long <- gravier_data %>% 
  pivot_longer(cols = -outcome,
               names_to = "gene",
               values_to = "log2_expr_level")

# Now, a nested version
gravier_data_long_nested <- gravier_data_long %>% 
  group_by(gene) %>% 
  nest() %>% 
  ungroup()

# Sampling 100 random genes from that
set.seed(1928374)
gravier_data_long_nested <- gravier_data_long_nested %>% 
  sample_n(size = 100)

# Data ready for PCA-analysis
my_data_clean_aug <- gravier_data %>%
  select(outcome, pull(gravier_data_long_nested, gene))


# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean_aug,
          path = "data/03_my_data_clean_aug.tsv.gz")
