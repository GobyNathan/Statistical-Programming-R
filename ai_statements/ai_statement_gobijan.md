# Individual AI Usage Documentation — Gobijan
**Course:** Statistical Programming (STAT1951) - CRN: 19727  
**Academic Term:** Sept–Dec 2026/27 — Technological University Dublin (TU Dublin)  
**Team:** Group 8 - Epitech  
**Student Name:** Gobijan  
**Role:** Listing Economics & Guest Capacity (`price`, `room_type`, `accommodates`)  

---

## 1. Introductory Reflection: What Worked Well and What Worked Badly with AI

In strict compliance with the course guidelines, I used Generative AI exclusively as a **coding and formatting assistant** to help write `ggplot2` / `dplyr` syntax, debug string parsing in R, and structure our project repository. **All data exploration, observations, hypotheses, and analytical insights were formulated by me after running the R scripts and inspecting the plots and data tables myself.**

### What Worked Well with AI
1. **Generating Clean `tidyverse` and `ggplot2` Code from My Specifications:**
   - Once I had decided which variables to plot and what patterns I wanted to investigate, AI was very efficient at providing the exact `ggplot2` syntax—such as adding `coord_cartesian(ylim = c(0, 30))` to zoom in on the y-axis of my `price` histogram, or writing the `after_stat(density)` syntax for `geom_freqpoly()` so I could compare `Entire home/apt` and `Private room` on a normalized scale.
2. **String Parsing and Factor Reordering Syntax:**
   - When I noticed in RStudio/Positron that the `price` column was loaded as a character string (`"$1,091.00"`), asking AI for the cleanest Tidyverse function to strip currency symbols and commas quickly gave me `readr::parse_number(price)`. Similarly, it helped me apply `forcats::fct_infreq()` and `fct_reorder()` to sort my bar charts and boxplots cleanly.
3. **Structuring the Repository and Translating Team Notes:**
   - AI was very helpful in formatting our `README.md` structure and translating our variable division plan between English and French so that my teammates and I could stay aligned on file paths and script organization.

### What Worked Badly with AI (Where Human Correction Was Required)
1. **AI Blindly Suggested Dropping Missing Values (`NA`) Without Investigating Them:**
   - When I asked AI for standard `ggplot2` histogram code for `price`, it automatically suggested adding `filter(!is.na(price))` or `na.rm = TRUE` as a routine cleaning step. If I had followed that blindly, I would have ignored 1,617 rows (35.4% of the dataset). Instead, I wrote a query myself to investigate *why* those prices were `NA`, which led to my own key discovery that 92.1% of the missing-price listings have `availability_365 == 0` (closed calendars).
2. **Overplotting and Distorted Density Curves on Rare Categories:**
   - When I asked AI for a `geom_freqpoly(aes(y = after_stat(density), color = room_type))` template, the raw code included all four `room_type` categories. When I ran the plot and looked at it, I noticed a massive vertical spike that ruined the y-axis scale. Upon checking the frequency table myself, I realized `Hotel room` only had 1 priced listing and `Shared room` only had 19, which distorted the density calculation. I had to manually modify the filter to keep only `Entire home/apt` and `Private room` in the density plot.
3. **Default Binwidths Hid Important Patterns:**
   - AI's default histogram code used `bins = 30` across the full `0 to 40,000 SEK` range, which squashed almost the entire Stockholm market into two giant bars on the left and hid the sawtooth pattern in `accommodates`. I had to experiment manually with different `binwidth` values (`binwidth = 200` for zoomed prices, `binwidth = 1` for `accommodates`) to actually see the distribution and identify the clusters myself.

---

## 2. Complete Log of Prompts Used During the Project

Below is the complete list of prompts I used to generate R code, debug syntax, and structure my work:

### A. Project Structure & Setup
**Prompt 1:**
> *"Here is our draft README for the STAT1951 EDA project on Stockholm Airbnb (`Dataset/listings.csv`). Can you help format it into a clean Markdown template with our 3-member variable split (`price`, `room_type`, `accommodates` for Gobijan; `neighbourhood_cleansed`, `minimum_nights`, `bedrooms` for Member 2; `availability_365`, `calculated_host_listings_count`, `number_of_reviews` for Member 3) and a standard R repository folder structure?"*

**Prompt 2:**
> *"Can you translate our `PROJECT.md` project structure and variable breakdown table into French (`PROJECT_FR.md`) so I can share the exact plan with my French-speaking teammates?"*

### B. Data Import & Cleaning Queries (`01_import_and_tidy.R`)
**Prompt 3:**
> *"In `Dataset/listings.csv`, the `price` column is imported as character strings like `"$1,091.00"` and `"$3,201.83"`. Also, `host_is_superhost` has `"t"` and `"f"`. Write a `dplyr::mutate()` pipeline in R using `tidyverse` to convert `price` into a numeric column and recode `host_is_superhost` into `"Superhost"` and `"Regular Host"`."*

**Prompt 4:**
> *"Write a `dplyr` summary query in R that counts the number and percentage of missing values (`NA`) across our 9 selected variables in the `stockholm` dataframe."*

**Prompt 5:**
> *"I noticed in my summary table that `price` has 1,617 `NA` values (35.4%), and I suspect it is because those listings are not available for booking (`availability_365 == 0`). Write a `dplyr` query grouping by whether `price` is `NA` or not, and calculate the total count, the percentage of listings where `availability_365 == 0`, and the median `availability_365`."*

### C. Variation Analysis Code for Gobijan (`02_variation_gobijan.R`)
**Prompt 6:**
> *"Write R code using `ggplot2` to create three histograms for `price`: (1) the full distribution with `binwidth = 500`, (2) a zoomed-in view from 0 to 8,000 SEK using `coord_cartesian(xlim = c(0, 8000))` and `binwidth = 200` with a vertical dashed line at the median price, and (3) a plot using `coord_cartesian(ylim = c(0, 30))` so I can inspect the rare high-price outliers in the right tail."*

**Prompt 7:**
> *"I want to inspect the extreme price outliers I saw above 15,000 SEK in my histogram. Write a `dplyr` query to filter `!is.na(price)`, sort by `desc(price)`, and display the top 10 rows with `id`, `name`, `neighbourhood_cleansed`, `room_type`, `accommodates`, `bedrooms`, and `price`."*

**Prompt 8:**
> *"Write `ggplot2` code for a bar chart of `room_type` ordered by frequency using `fct_infreq()`, adding text labels above each bar showing both the count and the percentage of total listings."*

**Prompt 9:**
> *"Write `ggplot2` code for a histogram of `accommodates` with `binwidth = 1` and `scale_x_continuous(breaks = 1:16)` so I can clearly see the count for each integer guest capacity from 1 to 16."*

### D. Covariation Analysis Code for Gobijan (`02_variation_gobijan.R`)
**Prompt 10:**
> *"I want to compare how `price` varies across `room_type`. Write `ggplot2` code for: (1) a boxplot of `price` by `room_type` ordered by median price (`fct_reorder`) zoomed to `ylim = c(0, 8000)`, and (2) a normalized frequency polygon using `geom_freqpoly(aes(y = after_stat(density), color = room_type))` filtered only to `Entire home/apt` and `Private room`."*

**Prompt 11:**
> *"Write a `ggplot2` scatter plot of `price` vs `accommodates` colored by `room_type`, using `geom_jitter(alpha = 0.25, width = 0.2)` to reduce overplotting and `geom_smooth(method = "loess")` to show the trend line, zoomed to `ylim = c(0, 10000)` and `xlim = c(1, 10)`."*

**Prompt 12:**
> *"To connect my `price` and `accommodates` analysis with Member 2's `neighbourhood_cleansed` variable, write `ggplot2` code that filters for the top 6 most frequent neighbourhoods and creates a faceted scatter plot (`facet_wrap(~ neighbourhood_cleansed)`) of `price` vs `accommodates` with linear trend lines (`geom_smooth(method = "lm")`)."*

**Prompt 13:**
> *"For my 3-minute individual presentation on why 35.4% of prices are missing, write a `ggplot2` proportional bar chart (`geom_bar(position = "fill")`) comparing the share of closed calendars (`availability_365 == 0`) vs open calendars (`availability_365 > 0`) between listings with missing prices and listings with valid prices."*
