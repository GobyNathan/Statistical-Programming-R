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

print(p1a_price_full)
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

print(p1b_price_typical)
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

print(p1c_price_outliers)
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

print(p2_room_type)
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

print(p3_accommodates)
ggsave("figures/m1_03_accommodates_histogram.png", p3_accommodates, width = 8, height = 5, dpi = 300)


# ==============================================================================
# PART B: COVARIATION ANALYSIS (GOBIJAN LEAD STORYTELLING)
# Lead Question: How do room_type, accommodates, and neighbourhood drive price?
# ==============================================================================

# ------------------------------------------------------------------------------
# 4. COVARIATION: 'price' vs 'room_type' (Categorical vs Continuous)
# ------------------------------------------------------------------------------
# Plot 4A: Boxplot of price across room_type (zoomed to < 8,000 SEK for readability)
p4a_price_by_room_box <- stockholm |>
  filter(!is.na(price)) |>
  ggplot(aes(x = fct_reorder(room_type, price, .fun = median), y = price, fill = room_type)) +
  geom_boxplot(outlier.alpha = 0.25, show.legend = FALSE) +
  coord_cartesian(ylim = c(0, 8000)) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Nightly Price by Room Type in Stockholm",
    subtitle = "Entire home/apt median (2,168 SEK) is 2.7x higher than Private rooms (808 SEK)",
    x = "Room Type (Ordered by Median Price)",
    y = "Nightly Price (SEK, Zoomed 0–8,000)"
  ) +
  theme_minimal(base_size = 12)

print(p4a_price_by_room_box)
ggsave("figures/m1_04a_price_by_room_boxplot.png", p4a_price_by_room_box, width = 8, height = 5, dpi = 300)

# Plot 4B: Normalized density frequency polygon (after_stat(density))
# Exclude Hotel room (n=1) & Shared room (n=19) to avoid noisy density spikes
p4b_price_density_poly <- stockholm |>
  filter(!is.na(price), room_type %in% c("Entire home/apt", "Private room")) |>
  ggplot(aes(x = price, y = after_stat(density), color = room_type)) +
  geom_freqpoly(binwidth = 300, linewidth = 1.1) +
  coord_cartesian(xlim = c(0, 8000)) +
  scale_color_manual(values = c("Entire home/apt" = "#1f78b4", "Private room" = "#e6550d")) +
  labs(
    title = "Normalized Price Density: Entire Homes vs Private Rooms",
    subtitle = "geom_freqpoly(aes(y = after_stat(density))) reveals distinct market distributions",
    x = "Nightly Price (SEK)",
    y = "Normalized Density",
    color = "Room Type"
  ) +
  theme_minimal(base_size = 12)

print(p4b_price_density_poly)
ggsave("figures/m1_04b_price_room_freqpoly_density.png", p4b_price_density_poly, width = 8, height = 5, dpi = 300)


# ------------------------------------------------------------------------------
# 5. COVARIATION: 'price' vs 'accommodates' & 'bedrooms' (Continuous vs Discrete)
# ------------------------------------------------------------------------------
# Plot 5: Price scaling with guest capacity, split by room_type
p5_price_vs_accommodates <- stockholm |>
  filter(!is.na(price), room_type %in% c("Entire home/apt", "Private room")) |>
  ggplot(aes(x = accommodates, y = price, color = room_type)) +
  geom_jitter(alpha = 0.25, width = 0.2) +
  geom_smooth(method = "loess", se = TRUE, linewidth = 1.2) +
  coord_cartesian(ylim = c(0, 10000), xlim = c(1, 10)) +
  scale_x_continuous(breaks = 1:10) +
  scale_color_manual(values = c("Entire home/apt" = "#1f78b4", "Private room" = "#e6550d")) +
  labs(
    title = "How Nightly Price Scales with Guest Capacity (accommodates)",
    subtitle = "Steady positive trend: each additional guest adds ~350–450 SEK for entire apartments",
    x = "Guest Capacity (accommodates)",
    y = "Nightly Price (SEK, Zoomed 0–10,000)",
    color = "Room Type"
  ) +
  theme_minimal(base_size = 12)

print(p5_price_vs_accommodates)
ggsave("figures/m1_05_price_vs_accommodates_smooth.png", p5_price_vs_accommodates, width = 8, height = 5, dpi = 300)


# ------------------------------------------------------------------------------
# 6. CROSS-TEAM COVARIATION: 'price' across Top Neighbourhoods (Gobijan x Member 2)
# ------------------------------------------------------------------------------
top_6_neighbourhoods <- stockholm |>
  count(neighbourhood_cleansed, sort = TRUE) |>
  slice_head(n = 6) |>
  pull(neighbourhood_cleansed)

p6_price_neighbourhood_facets <- stockholm |>
  filter(!is.na(price), neighbourhood_cleansed %in% top_6_neighbourhoods) |>
  ggplot(aes(x = accommodates, y = price, color = room_type)) +
  geom_jitter(alpha = 0.3, width = 0.2) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
  facet_wrap(~ neighbourhood_cleansed, ncol = 3) +
  coord_cartesian(ylim = c(0, 8000), xlim = c(1, 8)) +
  labs(
    title = "Price vs Capacity Faceted Across Stockholm's Top 6 Districts",
    subtitle = "Central districts (Norrmalms, Östermalms, Södermalms) command higher baseline prices across all sizes",
    x = "Accommodates (Guests)",
    y = "Nightly Price (SEK)",
    color = "Room Type"
  ) +
  theme_minimal(base_size = 11)

print(p6_price_neighbourhood_facets)
ggsave("figures/m1_06_price_capacity_by_neighbourhood_facets.png", p6_price_neighbourhood_facets, width = 10, height = 6, dpi = 300)


# ------------------------------------------------------------------------------
# 7. IN-CLASS DEFENSE PLOT: Missing Prices vs Calendar Availability (Gobijan x Member 3)
# ------------------------------------------------------------------------------
p7_missing_price_availability <- stockholm |>
  mutate(
    price_status = if_else(is.na(price), "Missing Price (n = 1,617)", "Quoted Price (n = 2,957)"),
    calendar_state = if_else(availability_365 == 0, "0 Days Available (Closed)", "1–365 Days Available (Open)")
  ) |>
  ggplot(aes(x = price_status, fill = calendar_state)) +
  geom_bar(position = "fill", width = 0.55) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c(
    "0 Days Available (Closed)" = "#d95f02",
    "1–365 Days Available (Open)" = "#1b9e77"
  )) +
  labs(
    title = "Why Are 35.4% of Stockholm Airbnb Prices Missing?",
    subtitle = "92.1% of missing-price listings have closed calendars (availability_365 == 0)",
    x = "Listing Price Status",
    y = "Percentage of Listings",
    fill = "Annual Calendar State"
  ) +
  theme_minimal(base_size = 12)

print(p7_missing_price_availability)
ggsave("figures/m1_07_missing_price_vs_availability.png", p7_missing_price_availability, width = 8, height = 5, dpi = 300)
