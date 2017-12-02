# Manipulating Data -- dplyr ----------------------------------------------
library("tidyverse")    ## load the tidyverse packages, incl. dplyr
select(surveys, plot_id, species_id, weight)
filter(surveys, year == 1995) # choose rows based on a specific criteria

surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)

surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)


surveys_sml <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

surveys_sml

surveys %>%
  mutate(weight_kg = weight / 1000)

surveys %>%
  mutate(weight_kg = weight / 1000,
         weight_kg2 = weight_kg * 2)

surveys %>%
  mutate(weight_kg = weight / 1000) %>%
  head

surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight / 1000) %>%
  head

surveys_gw <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(genus, plot_id) %>%
  summarize(mean_weight = mean(weight))

str(surveys_gw)


surveys_spread <- surveys_gw %>%
  spread(key = genus, value = mean_weight)

str(surveys_spread)


# Visualizing Data -- a toolkit -------------------------------------------


