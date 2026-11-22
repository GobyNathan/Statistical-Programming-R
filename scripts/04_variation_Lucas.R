# 1. Load cleaned data from script 01 -----------------------------------------
source("scripts/01_import_and_tidy.R")

# 2. Ensure output directory exists -------------------------------------------
dir.create("figures/lucasLeVrai", showWarnings = FALSE, recursive = TRUE)

# 3. Summary statistics for geographical variables ----------------------------
neighbourhood_summary <- stockholm |>
  filter(!is.na(neighbourhood_cleansed)) |>
  group_by(neighbourhood_cleansed) |>
  summarise(
    n_listings = n(),
    pct_listings = round(100 * n() / nrow(stockholm), 1),
    median_latitude = median(latitude, na.rm = TRUE),
    median_longitude = median(longitude, na.rm = TRUE),
    median_price = median(price, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(n_listings))

print(neighbourhood_summary)

stockholm |>
  select(latitude, longitude) |>
  summary() |>
  print()

# 4. Variation Analysis -------------------------------------------------------

# Plot 1: Geographical distribution of listings coloured by neighbourhood
map_data <- stockholm |>
  filter(
    !is.na(neighbourhood_cleansed),
    !is.na(latitude),
    !is.na(longitude)
  )

p1_geographical_distribution <- ggplot(
  map_data,
  aes(x = longitude, y = latitude, color = neighbourhood_cleansed)
) +
  geom_point(alpha = 0.55, size = 1.4) +
  coord_fixed(ratio = 1 / cos(mean(map_data$latitude) * pi / 180)) +
  labs(
    title = "Geographical Distribution of Airbnb Listings in Stockholm",
    subtitle = "Dense clustering in the inner-city archipelago core (59.30–59.35°N, 18.00–18.10°E)",
    x = "Longitude",
    y = "Latitude",
    color = "Neighbourhood"
  ) +
  theme_minimal(base_size = 12)

print(p1_geographical_distribution)
ggsave(
  "figures/lucasLeVrai/p1.png",
  p1_geographical_distribution,
  width = 9, height = 7, dpi = 300
)

# Plot 2: Number of listings per neighbourhood (categorical variation)
neighbourhood_counts <- stockholm |>
  filter(!is.na(neighbourhood_cleansed)) |>
  count(neighbourhood_cleansed, sort = TRUE)

p2_neighbourhood_counts <- neighbourhood_counts |>
  ggplot(aes(x = fct_reorder(neighbourhood_cleansed, n), y = n)) +
  geom_col(fill = "#2b5c8f") +
  coord_flip() +
  labs(
    title = "Number of Airbnb Listings per Neighbourhood in Stockholm",
    subtitle = "Södermalms alone accounts for 25.0% of all listings (1,145 / 4,574)",
    x = "Neighbourhood",
    y = "Number of Listings"
  ) +
  theme_minimal(base_size = 12)

print(p2_neighbourhood_counts)
ggsave(
  "figures/lucasLeVrai/p2.png",
  p2_neighbourhood_counts,
  width = 9, height = 6, dpi = 300
)

# Plot 3: Variation of Latitude (North-South distribution)
p3_latitude_distribution <- stockholm |>
  filter(!is.na(latitude)) |>
  ggplot(aes(x = latitude)) +
  geom_histogram(binwidth = 0.005, fill = "#2a9d8f", color = "white") +
  geom_vline(
    aes(xintercept = median(latitude)),
    color = "#d95f02", linetype = "dashed", linewidth = 1
  ) +
  labs(
    title = "North-South Distribution of Listings (Latitude Variation)",
    subtitle = "Sharp peak around median 59.317°N corresponding to Södermalms and central islands",
    x = "Latitude (°N)",
    y = "Number of Listings"
  ) +
  theme_minimal(base_size = 12)

print(p3_latitude_distribution)
ggsave(
  "figures/lucasLeVrai/p3_latitude_distribution.png",
  p3_latitude_distribution,
  width = 8, height = 5, dpi = 300
)

# Plot 4: Variation of Longitude (East-West distribution)
p4_longitude_distribution <- stockholm |>
  filter(!is.na(longitude)) |>
  ggplot(aes(x = longitude)) +
  geom_histogram(binwidth = 0.008, fill = "#1b9e77", color = "white") +
  geom_vline(
    aes(xintercept = median(longitude)),
    color = "#d95f02", linetype = "dashed", linewidth = 1
  ) +
  labs(
    title = "East-West Distribution of Listings (Longitude Variation)",
    subtitle = "Left-skewed distribution: dense urban core around 18.05°E with a long western suburban tail",
    x = "Longitude (°E)",
    y = "Number of Listings"
  ) +
  theme_minimal(base_size = 12)

print(p4_longitude_distribution)
ggsave(
  "figures/lucasLeVrai/p4_longitude_distribution.png",
  p4_longitude_distribution,
  width = 8, height = 5, dpi = 300
)

# 5. Covariation Analysis -----------------------------------------------------

# Plot 5: Covariation - Nightly Price across Neighbourhoods
p5_price_by_neighbourhood <- stockholm |>
  filter(!is.na(price), !is.na(neighbourhood_cleansed)) |>
  ggplot(aes(
    x = fct_reorder(neighbourhood_cleansed, price, .fun = median),
    y = price,
    fill = neighbourhood_cleansed
  )) +
  geom_boxplot(outlier.alpha = 0.25, show.legend = FALSE) +
  coord_flip(ylim = c(0, 6000)) +
  labs(
    title = "Nightly Price Distribution by Neighbourhood in Stockholm",
    subtitle = "Central & villa districts (~1,800–2,200 SEK median) vs outer northern/southern suburbs (<1,050 SEK)",
    x = "Neighbourhood (Ordered by Median Price)",
    y = "Nightly Price (SEK, Zoomed 0–6,000)"
  ) +
  theme_minimal(base_size = 12)

print(p5_price_by_neighbourhood)
ggsave(
  "figures/lucasLeVrai/p5_price_by_neighbourhood.png",
  p5_price_by_neighbourhood,
  width = 9, height = 6, dpi = 300
)

# Plot 6: Covariation - Room Type Composition by Neighbourhood
p6_room_type_by_neighbourhood <- stockholm |>
  filter(!is.na(neighbourhood_cleansed), !is.na(room_type)) |>
  ggplot(aes(
    x = fct_rev(neighbourhood_cleansed),
    fill = room_type
  )) +
  geom_bar(position = "fill") +
  coord_flip() +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Room Type Composition Across Stockholm Neighbourhoods",
    subtitle = "Entire homes dominate the inner city (>85%), while outer districts have up to 40% Private Rooms",
    x = "Neighbourhood (Ordered by Total Supply)",
    y = "Share of Listings",
    fill = "Room Type"
  ) +
  theme_minimal(base_size = 12)

print(p6_room_type_by_neighbourhood)
ggsave(
  "figures/lucasLeVrai/p6_room_type_by_neighbourhood.png",
  p6_room_type_by_neighbourhood,
  width = 9, height = 6, dpi = 300
)
