# ==============================================================================
# STAT1951 - Exploratory Data Analysis (EDA) on Airbnb Stockholm
# Script 02: Variation & Lead Covariation Analysis — GOBIJAN
# Focus: Pricing & Capacity (price, room_type, accommodates)
# ==============================================================================

source("scripts/01_import_and_tidy.R")

# ==============================================================================
# PART A: VARIATION ANALYSIS (UNIVARIATE)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. VARIATION OF 'price' (Continuous, SEK)
# ------------------------------------------------------------------------------
# Summary statistics (Valid N = 2,957 | Missing = 1,617 [35.4%])
# Min = 120 SEK | Q1 = 1,071 SEK | Median = 1,791 SEK | Mean = 2,328 SEK
# Q3 = 3,004 SEK | P95 = 5,706 SEK | Max = 40,000 SEK
stockholm |>
  filter(!is.na(price)) |>
  summarise(
    n = n(),
    min = min(price),
    q25 = quantile(price, 0.25),
    median = median(price),
    mean = mean(price),
    q75 = quantile(price, 0.75),
    p95 = quantile(price, 0.95),
    max = max(price)
  )

# Plot 1A: Full distribution of price showing extreme right skewness & outliers
p1a_price_full <- stockholm |>
  filter(!is.na(price)) |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 500, fill = "#2b5c8f", color = "white") +
  labs(
    title = "Distribution of Nightly Prices in Stockholm (Full Range)",
    subtitle = "Strong right skew with extreme outliers up to 40,000 SEK (n = 2,957 valid listings)",
    x = "Nightly Price (SEK)",
    y = "Number of Listings"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/m1_01a_price_full_histogram.png", p1a_price_full, width = 8, height = 5, dpi = 300)

# Plot 1B: Zooming into the typical price range (< 8,000 SEK) with finer binwidth
p1b_price_typical <- stockholm |>
  filter(!is.na(price)) |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 200, fill = "#2b5c8f", color = "white") +
  geom_vline(aes(xintercept = median(price)), color = "#d95f02", linetype = "dashed", linewidth = 1) +
  coord_cartesian(xlim = c(0, 8000)) +
  annotate(
    "text", x = 2100, y = 270,
    label = "Median: 1,791 SEK\nMean: 2,328 SEK",
    hjust = 0, color = "#d95f02", fontface = "bold"
  ) +
  labs(
    title = "Typical Nightly Prices in Stockholm (Zoomed: 0 to 8,000 SEK)",
    subtitle = "binwidth = 200 SEK | 50% of listings fall between 1,071 SEK (Q1) and 3,004 SEK (Q3)",
    x = "Nightly Price (SEK)",
    y = "Number of Listings"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/m1_01b_price_zoomed_typical.png", p1b_price_typical, width = 8, height = 5, dpi = 300)

# Plot 1C: Isolating rare high-price outliers using coord_cartesian(ylim = c(0, 30))
p1c_price_outliers <- stockholm |>
  filter(!is.na(price)) |>
  ggplot(aes(x = price)) +
  geom_histogram(binwidth = 500, fill = "#b22222", color = "white") +
  coord_cartesian(ylim = c(0, 30)) +
  labs(
    title = "Isolating Extreme Price Outliers with coord_cartesian(ylim = c(0, 30))",
    subtitle = "22 ultra-luxury/anomaly listings exceed 10,000 SEK/night, reaching up to 40,000 SEK",
    x = "Nightly Price (SEK)",
    y = "Count (Zoomed to 0–30)"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/m1_01c_price_outliers_ylim.png", p1c_price_outliers, width = 8, height = 5, dpi = 300)

# Inspect top 10 most expensive listings to see what drives >15,000 SEK prices
stockholm |>
  filter(!is.na(price)) |>
  arrange(desc(price)) |>
  select(id, name, neighbourhood_cleansed, room_type, accommodates, bedrooms, price) |>
  head(10) |>
  print()


# ------------------------------------------------------------------------------
# 2. VARIATION OF 'room_type' (Categorical)
# ------------------------------------------------------------------------------
# Frequency table:
# Entire home/apt: 3,760 (82.2%) | Private room: 787 (17.2%)
# Shared room: 24 (0.5%) | Hotel room: 3 (0.1%)
stockholm |>
  count(room_type, name = "n_listings") |>
  mutate(percentage = round(100 * n_listings / sum(n_listings), 2)) |>
  print()

# Plot 2: Bar chart of room_type
p2_room_type <- stockholm |>
  ggplot(aes(x = room_type, fill = room_type)) +
  geom_bar(show.legend = FALSE, width = 0.65) +
  geom_text(
    stat = "count",
    aes(label = paste0(after_stat(count), " (", round(100 * after_stat(count) / nrow(stockholm), 1), "%)")),
    vjust = -0.5, fontface = "bold", size = 3.8
  ) +
  scale_fill_brewer(palette = "Set2") +
  coord_cartesian(ylim = c(0, 4200)) +
  labs(
    title = "Distribution of Room Types in Stockholm",
    subtitle = "Entire homes/apartments dominate the supply (82.2%), while shared & hotel rooms are <1%",
    x = "Room Type",
    y = "Number of Listings"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/m1_02_room_type_bar.png", p2_room_type, width = 8, height = 5, dpi = 300)


# ------------------------------------------------------------------------------
# 3. VARIATION OF 'accommodates' (Discrete)
# ------------------------------------------------------------------------------
# Summary & frequency table:
# Peaks at even numbers: 2 guests (1,490 = 32.6%), 4 guests (955 = 20.9%),
# 3 guests (523 = 11.4%), 6 guests (445 = 9.7%), 5 guests (399), 1 guest (392)
stockholm |>
  count(accommodates, sort = TRUE) |>
  mutate(pct = round(100 * n / sum(n), 1)) |>
  print()

# Plot 3: Histogram / Bar distribution of guest capacity
p3_accommodates <- stockholm |>
  ggplot(aes(x = accommodates)) +
  geom_histogram(binwidth = 1, fill = "#2a9d8f", color = "white", boundary = 0.5) +
  scale_x_continuous(breaks = 1:16) +
  labs(
    title = "Distribution of Guest Capacity (accommodates)",
    subtitle = "Clear clustering on even capacities (2, 4, 6 guests); 2-guest listings represent 32.6% of market",
    x = "Maximum Number of Guests (accommodates)",
    y = "Number of Listings"
  ) +
  theme_minimal(base_size = 12)

ggsave("figures/m1_03_accommodates_histogram.png", p3_accommodates, width = 8, height = 5, dpi = 300)

