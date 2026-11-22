# 📊 STAT1951 - Exploratory Data Analysis (EDA) on Airbnb Stockholm
**Course:** Statistical Programming (STAT1951) - CRN: 19727  
**Academic Term:** Sept–Dec 2026/27 — Technological University Dublin (TU Dublin)  
**Team Name:** Group 8 - Epitech  
**Weight:** 30% of Overall Course Grade  
**Submission Deadline:** 23 November 2026, 22:00  

---

## 🏙️ 1. Project Overview & Context

This project involves performing an end-to-end **Exploratory Data Analysis (EDA)** in **R** using public Airbnb summary data from [Inside Airbnb](http://insideairbnb.com/get-the-data.html). 

Our chosen city is **Stockholm, Sweden**—a major metropolitan area where no team member has previously lived, guaranteeing strict analytical objectivity. The raw dataset (`Dataset/listings.csv`, 4,574 rows × 90 columns) captures listing attributes, host behaviours, geographical distributions, pricing, and availability.

### Core Objective
To uncover empirical insights by strictly applying the **iterative EDA cycle**:
\[\text{Generate Questions} \longrightarrow \text{Visualise \& Transform} \longrightarrow \text{Refine Questions}\]
Every conclusion must be backed by data-driven evidence rather than subjective assumptions.

---

## 👥 2. Team Work Breakdown (3 Members)

Each team member is assigned **3 variables** for in-depth **Variation Analysis** (9 variables total across the group). For the final presentation, each student acts as lead storyteller for **1 primary variable**, exploring how it co-varies with variables analyzed by other teammates.

| Member | Primary Focus Area | 3 Assigned Variables (Variation) | Lead Storytelling Variable & Narrative |
| :--- | :--- | :--- | :--- |
| **Gobijan** | **Pricing & Housing Typology** | `price` *(continuous, SEK)*<br>`room_type` *(categorical)*<br>`accommodates` *(discrete)* | **`price` vs Capacity & Room Types**<br>*How listing prices vary in Stockholm and what drives extreme peaks & missing values.* |
| **Lucas S.** | **Geographical Analysis** | `neighbourhood_cleansed` *(categorical)*<br>`latitude` *(continuous)*<br>`longitude` *(continuous)* | **`neighbourhood_cleansed` & Spatial Distribution**<br>*Geographical distribution across Stockholm (central districts vs periphery).* |
| **Lucas C.** | **Activity, Demand & Booking Rules** | `number_of_reviews` *(continuous)*<br>`availability_365` *(continuous/discrete)*<br>`minimum_nights` *(discrete/continuous)* | **`availability_365` & Booking Dynamics**<br>*Study of listing activity, guest demand, host types, and minimum stay rules.* |

> **Covariation Bonus Variables:** `calculated_host_listings_count` / `host_portfolio_type` (single-listing hosts vs commercial operators) and `host_is_superhost` (used as grouping/facet aesthetic).
>
> **Slide 1 Requirement:** The team video presentation must open with an explicit breakdown of individual contributions. Work must be split equally (unequal contributions are subject to individual grade penalties).

---

## 🔬 3. Methodology & Technical Framework

The analysis relies on the **Tidyverse** suite within R / Positron / RStudio:

### A. Variation Analysis (Per Variable)
* **Categorical Variables:** Bar charts via `geom_bar()` (ordered with `fct_reorder()` / `fct_infreq()`). Identify common categories, rare classes, and frequency imbalances.
* **Continuous / Discrete Variables:** Histograms (`geom_histogram()`) exploring different bin widths (`binwidth`), and frequency polygons (`geom_freqpoly()`).
* **Key Observations to extract (3 to 5 per variable):**
  * *Typical values* and center of distribution.
  * *Outliers* and extreme values (isolated using `coord_cartesian(ylim = ...)` or `xlim = ...`).
  * *Clusters / Subgroups* pointing to distinct market segments.
  * *Missing values (`NA`)* and structural reasons behind them (e.g., 35.4% `NA` in `price` linked to inactive listings).
  * *Follow-up questions:* Why do these patterns appear?

### B. Covariation Analysis (Cross-Variable Teamwork)
* **Categorical vs Continuous:** Boxplots (`geom_boxplot()`) and normalized density polygons (`geom_freqpoly(aes(y = after_stat(density)))`).
* **Continuous vs Continuous:** Scatter plots (`geom_point()`) with transparency (`alpha`) to alleviate overplotting, combined with smoothed trend lines (`geom_smooth()`).
* **Categorical vs Categorical:** Frequency counts via `geom_count()` or grouped summary tables with `dplyr`.
* **Advanced Visualisations:** Strategic use of aesthetic mappings (`color`, `size`, `shape`) and facet splits (`facet_wrap()`, `facet_grid()`), plus spatial mapping via `longitude` and `latitude`.

---

## 📦 4. Deliverables & Evaluation Rubric

### 1. Group Video Presentation (15 Minutes)
* **Format:** Recorded screencast (max 15 mins; penalties apply for running >10% over time).
* **Structure:**
  1. *Slide 1:* Work division & individual member contributions.
  2. *Body:* Individual segments where each member presents the variation of their variable, followed by cross-variable covariation analysis answering follow-up questions.
  3. *Evidence:* Graph screenshots accompanied by clean R code snippets.
  4. *Final Slide:* Retrospective — lessons learned and what the team would do differently next time.

### 2. Individual In-Class Presentation (3 Minutes per Member)
* Live defense in class: present one compelling finding discovered in the data, explain how it was detected, demonstrate the best way to visualize it, and explain its real-world implication.
* *Note:* Mandatory component to confirm individual ownership of findings; no grade is awarded if skipped.

### 3. Individual AI Documentation
* Use of Generative AI is permitted for R code generation, debugging, and structuring.
* All data observations and analytical insights **must be genuine and original**.
* Each member must submit an individual document including:
  * Full prompt log used during the project.
  * Reflection on what worked well and what failed with AI.

---

## 🎯 5. Grading Rubric (100 Points Total)

| Criteria | Points | Target standard for top marks (16–20 pts) |
| :--- | :---: | :--- |
| **Application of EDA Process** | 20 | Rigorous application of the iterative cycle; clear, cohesive narrative. |
| **Variation Analysis** | 20 | Comprehensive exploration of spreads, typical values, outliers, and insightful follow-ups. |
| **Covariation Analysis** | 20 | In-depth exploration that successfully answers the follow-up questions. |
| **Visualisations (`ggplot2`)** | 20 | Proficient use of diverse geom layers, aesthetics, facets, and scales. |
| **Communication** | 20 | Articulate, precise, and well-structured delivery across all members. |

---

## 🛠️ 6. Repository Structure

```text
├── Dataset/
│   └── listings.csv                 # Stockholm Airbnb dataset (4,574 rows x 90 cols)
├── Documentation/
│   ├── PROJECT.md                   # Project specification & EDA plan (English)
│   └── PROJECT_FR.md                # Project specification & EDA plan (French)
├── scripts/
│   ├── 01_import_and_tidy.R         # Data loading, price parsing (SEK), type casting
│   ├── 02_variation_gobijan.R       # price, room_type, accommodates (Gobijan)
│   ├── 03_variation_lc.R            # number_of_reviews, availability_365, minimum_nights (Lucas C.)
│   └── 04_variation_Lucas.R         # neighbourhood_cleansed, latitude, longitude (Lucas S.)
├── figures/                         # Exported high-resolution plots for the slides
│   ├── gobijan/
│   ├── lucas/
│   └── lucasLeVrai/
├── presentation/
│   └── slides.pdf                   # Final slide deck for video recording
├── ai_statements/
│   ├── ai_statement_gobijan.md      # Individual AI prompt logs & reflections (Gobijan)
│   ├── ai_statement_lucas.md        # Individual AI prompt logs & reflections (Lucas C.)
│   └── ai_statement_lucas_s.md      # Individual AI prompt logs & reflections (Lucas S.)
└── README.md
```

---

## 🚀 7. Getting Started

1. Clone this repository into your local environment (Positron / RStudio / VS Code).
2. Verify that `Dataset/listings.csv` is present in the workspace.
3. Open `scripts/01_import_and_tidy.R` and execute:
   ```r
   library(tidyverse)

   stockholm <- read_csv("Dataset/listings.csv") |>
     mutate(
       price = parse_number(price),
       host_is_superhost = case_when(
         host_is_superhost == TRUE | host_is_superhost == "t" ~ "Superhost",
         host_is_superhost == FALSE | host_is_superhost == "f" ~ "Regular Host",
         TRUE ~ NA_character_
       )
     )

   glimpse(stockholm)
   ```
