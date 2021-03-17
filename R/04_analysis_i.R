# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")


# Define functions --------------------------------------------------------
#source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv.gz")


# Wrangle data ------------------------------------------------------------
#my_data_clean_aug %>% ...


# Model data
# Making the PCA analysis
pca_fit <- my_data_clean_aug %>% 
  select(where(is.numeric)) %>%
  prcomp(scale = TRUE)


# Visualise data ----------------------------------------------------------

# PCA coordinates plot
pca_pl1 <- pca_fit %>%
  augment(my_data_clean_aug) %>% 
  ggplot(aes(x = .fittedPC1,
             y = .fittedPC2,
             color = factor(outcome))) + 
  geom_point()+
  theme_minimal()+
  labs(color = "Outcome")

# Rotation matrix
# Defining arrow style
arrow_style = arrow(angle = 15,
                    ends = "first",
                    type = "open",
                    length = grid::unit(7,
                                        "pt"))

# Plotting the rotation matrix
pca_pl2 <- pca_fit %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(names_from = "PC",
              names_prefix = "PC",
              values_from = "value") %>%
  ggplot(aes(x = PC1,
             y = PC2)) +
  geom_segment(xend = 0, yend = 0, arrow = arrow_style) +
  geom_text(aes(label = column),
            hjust = 1,
            nudge_x = -0.01,
            color = "#904C2F") +
  theme_minimal()

# Variance explained by each PCA

pca_pl3 <- pca_fit %>%
  tidy(matrix = "eigenvalues") %>%
  ggplot(aes(x = PC,
             y = percent)) +
  geom_col(fill = "#56B4E9",
           alpha = 0.8) +
  scale_x_continuous(breaks = 1:100) +
  scale_y_continuous(labels = scales::percent_format(),
                     expand = expansion(mult = c(0, 0.01))) +
  theme_minimal()


# Write data --------------------------------------------------------------
#write_tsv(...)
ggsave(filename = "results/04_PCA_plot_1.png",
       plot = pca_pl1,
       width = 16,
       height = 9,
       dpi = 72)

ggsave(filename = "results/04_PCA_plot_2.png",
       plot = pca_pl2,
       width = 16,
       height = 9,
       dpi = 72)

ggsave(filename = "results/04_PCA_plot_3.png",
       plot = pca_pl3,
       width = 16,
       height = 9,
       dpi = 72)

