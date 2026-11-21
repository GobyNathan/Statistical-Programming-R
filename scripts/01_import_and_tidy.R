library(tidyverse)

raw_listings <- read_csv("Dataset/listings.csv", show_col_types = FALSE)
glimpse(raw_listings)

# Parse price in SEK and format categorical factors
stockholm <- raw_listings |>
  mutate(
    price = parse_number(price),
    room_type = fct_infreq(room_type),
    neighbourhood_cleansed = fct_infreq(neighbourhood_cleansed),
    host_is_superhost = case_when(
      host_is_superhost == TRUE | host_is_superhost == "t" ~ "Superhost",
      host_is_superhost == FALSE | host_is_superhost == "f" ~ "Regular Host",
      TRUE ~ NA_character_
    ) |> factor(levels = c("Superhost", "Regular Host")),
    host_portfolio_type = case_when(
      calculated_host_listings_count == 1 ~ "Single-Listing Host (1)",
      calculated_host_listings_count <= 4 ~ "Small Multi-Host (2–4)",
      calculated_host_listings_count >= 5 ~ "Commercial Operator (5+)"
    ) |> factor(levels = c("Single-Listing Host (1)", "Small Multi-Host (2–4)", "Commercial Operator (5+)"))
  )

# Missing values check across core variables
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

# Check relationship between missing price and availability_365
stockholm |>
  mutate(price_status = if_else(is.na(price), "Missing Price (NA)", "Valid Price")) |>
  group_by(price_status) |>
  summarise(
    n_listings = n(),
    pct_zero_availability = round(100 * mean(availability_365 == 0), 1),
    median_availability_365 = median(availability_365)
  ) |>
  print()

if (!dir.exists("figures/gobijan")) dir.create("figures/gobijan", recursive = TRUE)
