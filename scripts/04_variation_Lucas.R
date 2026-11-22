library(tidyverse)

# Load the CSV from the Dataset folder (expected structure) or scripts
data_path <- if (file.exists("Dataset/listings")) {
  "Dataset/listings"
} else if (file.exists("listings.csv")) {
  "listings.csv"
} else {
  stop("Listings file not found. Check the Dataset/ or scripts/ folder.")
}

listings_geo <- read_csv(data_path, show_col_types = FALSE) |>
  select(neighbourhood_cleansed, latitude, longitude) |>
  mutate(
    latitude = readr::parse_number(as.character(latitude)),
    longitude = readr::parse_number(as.character(longitude)),
    neighbourhood_cleansed = fct_infreq(neighbourhood_cleansed)
  )

dir.create("figures/member2", showWarnings = FALSE, recursive = TRUE)

# Listing counts and central coordinates by neighbourhood
neighbourhood_summary <- listings_geo |>
  filter(!is.na(neighbourhood_cleansed)) |>
  group_by(neighbourhood_cleansed) |>
  summarise(
    n_listings = n(),
    median_latitude = median(latitude, na.rm = TRUE),
    median_longitude = median(longitude, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(n_listings))

print(neighbourhood_summary)

# 1. Number of listings per neighbourhood
neighbourhood_counts <- listings_geo |>
  filter(!is.na(neighbourhood_cleansed)) |>
  count(neighbourhood_cleansed, sort = TRUE)

p1_neighbourhood_counts <- neighbourhood_counts |>
  ggplot(aes(x = fct_reorder(neighbourhood_cleansed, n), y = n)) +
  geom_col(fill = "#2b5c8f") +
  coord_flip() +
  labs(
    title = "Number of Airbnb Listings per Neighbourhood in Stockholm",
    x = "Neighbourhood",
    y = "Number of Listings"
  ) +
  theme_minimal(base_size = 12)

print(p1_neighbourhood_counts)
ggsave(
  "figures/member2/m2_01_listings_per_neighbourhood.png",
  p1_neighbourhood_counts,
  width = 9, height = 6, dpi = 300
)

# 2. Geographical distribution of listings, coloured by neighbourhood
map_data <- listings_geo |>
  filter(
    !is.na(neighbourhood_cleansed),
    !is.na(latitude),
    !is.na(longitude)
  )

p2_geographical_distribution <- ggplot(
  map_data,
  aes(x = longitude, y = latitude, color = neighbourhood_cleansed)
) +
  geom_point(alpha = 0.55, size = 1.4) +
  coord_fixed(ratio = 1 / cos(mean(map_data$latitude) * pi / 180)) +
  labs(
    title = "Geographical Distribution of Airbnb Listings in Stockholm",
    x = "Longitude",
    y = "Latitude",
    color = "Neighbourhood"
  ) +
  theme_minimal(base_size = 12)

print(p2_geographical_distribution)
ggsave(
  "figures/member2/m2_02_geographical_distribution.png",
  p2_geographical_distribution,
  width = 9, height = 7, dpi = 300
)

ggsave(
  "figures/member2/m2_04_longitude_by_neighbourhood.png",
  p4_longitude_by_neighbourhood,
  width = 9, height = 6, dpi = 300
)