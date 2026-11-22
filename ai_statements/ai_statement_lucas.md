# Individual AI Usage Documentation - Lucas

## Course
STAT1951 - Exploratory Data Analysis on Stockholm Airbnb

## Role
Activity, booking rules and demand: `number_of_reviews`, `availability_365` and `minimum_nights`.

## AI Use
I used generative AI to translate the project instructions into French, to help generate and improve R code for `scripts/03_variation_lc.R`, and to structure this individual AI usage statement.

I created two R script versions:

1. A simple exploratory version to understand the data and build the basic plots.
2. A more developed version for the covariation graph. I asked the AI to improve graph `p6`, where the points were difficult to read, and to produce a clearer boxplot such as the existing minimum-nights-by-price visualisation. I also specified the desired visualisation structure and colours.

## What Worked
The AI correctly produced useful `ggplot2` and `dplyr` code for histograms, boxplots, facets and file export with `ggsave()`. The second version clearly improved the readability of the minimum-nights and price comparison.

It also helped translate the project brief and presentation requirements into French.

## What Needed Human Verification
I had to run the scripts myself and verify the resulting figures. The AI had difficulty diagnosing RStudio launch and working-directory errors. I therefore checked the paths, loaded the data, and ran the script again rather than relying only on its proposed fixes.

## Prompts Used

The following prompts are a concise reconstruction of my main requests. Some RStudio launch and error-correction prompts were copied directly from RStudio error messages and were not kept in full.

1. «tu peux traduire l'énoncé du projet EDA en français stp ?»

2. «Tu peux me faire le fichier inspiré du fichier ai_statement_gobijan.md vide pour que je puisse le remplir stp»

3. «Voici le jeu de données Stockholm Airbnb. Aide-moi à créer une première version simple en R avec tidyverse pour étudier `number_of_reviews`, `availability_365` et `minimum_nights`, avec des histogrammes et des résumés statistiques.»

4. «Je trouve le p6 illisible il y a trop de points tu peux le trasnformer en graphique "Faceted Grouped Boxplot" avec de meilleurs couleurs pour qu'ils soient lisibles dans une présentation ?»

5. «j'arrive pas a lancer le fichier "03_variation_lc.R". Rstudio me donne ca : ...»
