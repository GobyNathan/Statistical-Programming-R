# 1. Load and prepare data without changing 01_import_and_tidy.R
library(tidyverse)

raw_listings <- read_csv("Dataset/listings.csv", show_col_types = FALSE)

stockholm <- raw_listings |>
  mutate(
    price = parse_number(as.character(price)),
    room_type = fct_infreq(room_type),
    neighbourhood_cleansed = fct_infreq(neighbourhood_cleansed),
    host_portfolio_type = case_when(
      calculated_host_listings_count == 1 ~ "Single-Listing Host (1)",
      calculated_host_listings_count <= 4 ~ "Small Multi-Host (2–4)",
      calculated_host_listings_count >= 5 ~ "Commercial Operator (5+)"
    ) |> factor(levels = c(
      "Single-Listing Host (1)",
      "Small Multi-Host (2–4)",
      "Commercial Operator (5+)"
    ))
  )

# 2. Ensure output directory exists
dir.create("figures/lucas", showWarnings = FALSE, recursive = TRUE)

# 3. Summary statistics for assigned variables
stockholm |>
  select(number_of_reviews, availability_365, minimum_nights) |>
  summary()

# Plot 1: Variation of availability_365
p1 <- stockholm |>
  ggplot(aes(x = availability_365)) +
  geom_histogram(binwidth = 15, fill = "#1b9e77", color = "white") +
  labs(title = "Annual Availability in Stockholm", x = "Days Available", y = "Number of Listings") +
  theme_minimal()

p1
ggsave("figures/lucas/p1_availability.png", p1, width = 8, height = 5)


# Plot 2: Variation of number_of_reviews (0 to 60)
p2 <- stockholm |>
  filter(number_of_reviews <= 60) |>
  ggplot(aes(x = number_of_reviews)) +
  geom_histogram(binwidth = 2, fill = "#2b5c8f", color = "white") +
  labs(title = "Number of Reviews (0 to 60)", x = "Number of Reviews", y = "Number of Listings") +
  theme_minimal()

p2
ggsave("figures/lucas/p2_reviews.png", p2, width = 8, height = 5)


# Plot 3: Variation of minimum_nights (1 to 30)
p3 <- stockholm |>
  filter(minimum_nights <= 30) |>
  ggplot(aes(x = minimum_nights)) +
  geom_bar(fill = "#d95f02") +
  labs(title = "Minimum Nights (1 to 30)", x = "Minimum Nights", y = "Number of Listings") +
  theme_minimal()

p3
ggsave("figures/lucas/p3_min_nights.png", p3, width = 8, height = 5)

# Plot 4: Covariation - Availability vs Reviews by Room Type
p4 <- stockholm |>
  filter(number_of_reviews <= 150) |>
  ggplot(aes(x = availability_365, y = number_of_reviews, color = room_type)) +
  geom_point(alpha = 0.3) +
  facet_wrap(~ room_type) +
  labs(title = "Reviews vs Availability by Room Type", x = "Availability (days)", y = "Reviews") +
  theme_minimal()

p4
ggsave("figures/lucas/p4_avail_reviews.png", p4, width = 8, height = 5)


# Plot 5: Covariation - Availability by Host Portfolio Type
p5 <- stockholm |>
  filter(!is.na(host_portfolio_type)) |>
  ggplot(aes(x = host_portfolio_type, y = availability_365, fill = host_portfolio_type)) +
  geom_boxplot() +
  labs(title = "Availability by Host Type", x = "Host category", y = "Availability (days)") +
  theme_minimal()

p5
ggsave("figures/lucas/p5_avail_host.png", p5, width = 8, height = 5)


# Plot 6: Covariation - Minimum Nights vs Price by Room Type
p6 <- stockholm |>
  filter(!is.na(minimum_nights), !is.na(price), price > 0) |>
  mutate(stay_policy = ifelse(minimum_nights >= 7, "Long Stay (7+ nights)", "Short Stay (1–6 nights)")) |>
  ggplot(aes(x = stay_policy, y = price, fill = stay_policy)) +
  geom_boxplot(outlier.color = "#b22222", outlier.alpha = 0.2) +
  coord_cartesian(ylim = c(0, 5000)) +
  scale_fill_manual(values = c("Short Stay (1–6 nights)" = "#2b5c8f", "Long Stay (7+ nights)" = "#2a9d8f")) +
  facet_wrap(~ room_type) +
  labs(
    title = "Nightly Price by Minimum Stay Policy and Room Type",
    x = "Minimum stay policy",
    y = "Price per night",
    fill = "Stay policy"
  ) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "none")

p6
ggsave("figures/lucas/p6_min_nights_vs_price.png", p6, width = 8, height = 5, dpi = 300)
