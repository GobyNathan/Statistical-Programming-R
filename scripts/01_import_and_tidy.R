# ==============================================================================
# STAT1951 - Exploratory Data Analysis (EDA) on Airbnb Stockholm
# Script 01: Import, Data Cleaning & Initial Exploration
# Team: Group 8 - Epitech
# ==============================================================================

library(tidyverse)

# 1. Load Raw Dataset ----------------------------------------------------------
raw_listings <- read_csv("Dataset/listings.csv", show_col_types = FALSE)

# Initial dimensions check (Expected: 4,574 rows x 90 columns)
glimpse(raw_listings)

# 2. Data Cleaning & Transformation --------------------------------------------
# Note: 'price' is formatted with a '$' sign (e.g., "$1,091.00"), but as confirmed
# by 'price_quote_raw', the actual currency is Swedish Krona (SEK).
stockholm <- raw_listings |>
  mutate(
    # Parse numeric price in SEK
    price = parse_number(price),
    
    # Order room_type by frequency
    room_type = fct_infreq(room_type),
    
    # Order neighbourhood_cleansed by frequency
    neighbourhood_cleansed = fct_infreq(neighbourhood_cleansed),
    
    # Clean superhost status into human-readable labels
    host_is_superhost = case_when(
      host_is_superhost == TRUE | host_is_superhost == "t" ~ "Superhost",
      host_is_superhost == FALSE | host_is_superhost == "f" ~ "Regular Host",
      TRUE ~ NA_character_
    ) |> factor(levels = c("Superhost", "Regular Host")),
    
    # Derived categorical variable for host portfolio scale (useful for covariation)
    host_portfolio_type = case_when(
      calculated_host_listings_count == 1 ~ "Single-Listing Host (1)",
      calculated_host_listings_count <= 4 ~ "Small Multi-Host (2–4)",
      calculated_host_listings_count >= 5 ~ "Commercial Operator (5+)"
    ) |> factor(levels = c("Single-Listing Host (1)", "Small Multi-Host (2–4)", "Commercial Operator (5+)"))
  )

# 3. Missing Values Audit across the 9 Core Variables --------------------------
core_vars <- c(
  "price", "room_type", "accommodates",
  "neighbourhood_cleansed", "minimum_nights", "bedrooms",
  "availability_365", "calculated_host_listings_count", "number_of_reviews"
)

missing_summary <- stockholm |>
  select(all_of(core_vars)) |>
  summarise(across(everything(), ~ sum(is.na(.)))) |>
  pivot_longer(everything(), names_to = "variable", values_to = "n_missing") |>
  mutate(pct_missing = round(100 * n_missing / nrow(stockholm), 2))

print(missing_summary)

# 4. Investigating Missing Values in 'price' (1,617 NAs = 35.35%) --------------
# EDA Question: Are missing prices random, or tied to zero annual availability?
stockholm |>
  mutate(price_status = if_else(is.na(price), "Missing Price (NA)", "Valid Price")) |>
  group_by(price_status) |>
  summarise(
    n_listings = n(),
    pct_zero_availability = round(100 * mean(availability_365 == 0), 1),
    median_availability_365 = median(availability_365)
  ) |>
  print()
# Insight: 92.1% (1,490 out of 1,617) of listings with missing prices have
# availability_365 == 0 (inactive or closed calendars).

# Ensure output directories exist for plots
if (!dir.exists("figures")) dir.create("figures", recursive = TRUE)
