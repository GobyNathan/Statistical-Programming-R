# 1. Load cleaned data
source("scripts/01_import_and_tidy.R")

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
  filter(minimum_nights <= 30, price <= 5000) |>
  ggplot(aes(x = minimum_nights, y = price, color = room_type)) +
  geom_point(alpha = 0.3) +
  facet_wrap(~ room_type) +
  labs(title = "Price vs Minimum Nights by Room Type", x = "Minimum nights", y = "Price (SEK)") +
  theme_minimal()

p6
ggsave("figures/lucas/p6_nights_price.png", p6, width = 8, height = 5)
