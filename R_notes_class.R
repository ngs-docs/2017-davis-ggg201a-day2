# Welcome to R and R Studio, GGG 201a!


# Intro to R --------------------------------------------------------------
## adapted from http://www.datacarpentry.org/R-ecology-lesson/01-intro-to-r.html
## R can do math
3 + 5
12 / 7

## Assigning value can be more useful
weight_kg <- 55    # doesn't print anything
(weight_kg <- 55)  # but putting parenthesis around the call prints the value of `weight_kg`
weight_kg          # and so does typing the name of the object

2.2 * 55

2.2 * weight_kg

## Variables can be reassigned
weight_kg <- 57.5
weight_kg
2.2 * weight_kg


## Functions
a <- 5
b <- sqrt(a)
b
sd(a)

# function can have multiple arguments
round(3.14159)
args(round)   # What arguments does round take?
?round     # help! what does round() do???
round(3.14159, digits = 2)  # arguments can be named. This often helps with clarity.
round(3.14159, 2)     # Don't have to explicitly name the arguments
round(digits = 2, x = 3.14159)     # but if you do, they can be in any order

# Vectors
weight_g <- c(50, 60, 65, 82) # concatenate numbers together to make a numeric vector
animals <- c("mouse", "rat", "dog") # concatenate character strings together to make a character vector

length(weight_g)  # determine length of vector
length(animals)

class(weight_g) # determine the type of data (numeric, character, integer, logical, factor, etc.)
class(animals)

str(weight_g)   # structure of weight_g
str(animals)

weight_g <- c(weight_g, 90) # add to the end of the vector

# subsetting
animals <- c("mouse", "rat", "dog", "cat")
animals[2] # subset to the second index of the vector animal, "rat"

# Conditional subsetting
weight_g <- c(21, 34, 39, 54, 55)
weight_g[c(TRUE, FALSE, TRUE, TRUE, FALSE)]  # subest based on logical values. Returns only TRUE indices

# Missing data
# NA is a special data type in R. R has many built in functions deal with NAs (ex. na.rm = TRUE)

# Starting with Data ------------------------------------------------------
download.file("https://ndownloader.figshare.com/files/2292169",
              "portal_data_joined.csv")  # download an external file to your computer

surveys <- read.csv("portal_data_joined.csv") # read the file into R's working memory

head(surveys) # examine the first 6 rows of the data frame
str(surveys) # examine the structure of the data frame

surveys[1, 1]   # first element in the first column of the data frame (as a vector)
surveys[1, 6]   # first element in the 6th column (as a vector)
surveys[, 1]    # first column in the data frame (as a vector)
surveys[1]      # first column in the data frame (as a data.frame)
surveys[1:3, 7] # first three elements in the 7th column (as a vector)
surveys[3, ]    # the 3rd element for all columns (as a data.frame)
head_surveys <- surveys[1:6, ] # equivalent to head_surveys <- head(surveys)


# Explanation of factors
# Factors are used to represent categorical data. 

# Manipulating Data -- dplyr ----------------------------------------------
# install.packages("dplyr") # Run this command if tidyverse or dplyr are not already installed

library(tidyverse) # load the tidyverse library 
surveys # print surveys in the consol
surveys <- read_csv("portal_data_joined.csv") # use the tidyverse function to read csv file. Object will be a tibble, and character fields will be characters, not factors.
surveys
str(surveys) # Examine the structure of surveys

# filter() and select() dplyr functions
select(surveys, plot_id, species_id, weight) # select 3 columns from the surveys data
filter(surveys, year == 1995) # return all columns for which the year record is equal to 1995

# Combine filter and select
surveys_tmp <- filter(surveys, weight > 5)  # filter, making a temporary object to save the results
surveys_sml <- select(surveys_tmp, species_id, sex, weight) # select columns from temporary object
surveys_sml 

surveys_sml <- select(filter(surveys, weight > 5 ), species_id, sex, weight) # nest functions
surveys_sml

# pipes
surveys_sml <- surveys %>%
  filter(weight > 5) %>%
  select(species_id, sex, weight) # Use pipes to send the output of one function to the input of another

remove(surveys_tmp) # remove one variable from environment

# mutate() function

surveys %>% 
  mutate(weight_kg = weight / 1000) # add another column named weight_kg to the dataframe (tibble) by dividing an existing column, weight, by 1000. Because we did not assign this to an object, the output will print to the console but won't be saved.

surveys_mut <- surveys %>% 
  mutate(weight_kg = weight / 1000) # to save the output, assign it to an object

surveys_mut <- surveys %>%
  mutate(weight_kg = weight /1000,
         weight_kg2 = weight_kg * 2) # mutate can also take as input a newly created variable (weight_kg) to perform another mutation that will produce another new column.. 

surveys %>% 
  mutate(weight_kg = weight / 1000) %>%
  head  # Pipes work with any R function, as long as dplyr is loaded as a library

surveys %>%
  filter(!is.na(weight)) %>%
  head  # NAs can be removed by negating (!) is.na(). The exclamation point means "does not" or "is not" in R.

# Split, apply, combine
# Split groups, perform something to each group, and combine the results
surveys %>%
  group_by(sex) %>%   # group_by() groups observations of the same kind together within on column
  summarize(mean_weight = mean(weight, na.rm = TRUE)) # when piped to a function like summarize() and mean(), this will take the observations that have been grouped together and take the mean of each group, and then summarize the output into a interpretable output.


surveys %>% 
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE)) %>%
  tail    # tail is a useful way to look at the end of a data frame

surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight)) %>%
  print(n = 15) # print is a useful way to increase the number of lines printed in the console.

surveys %>%
  group_by(sex) %>%
  tally  # tally will count the number of observations in each group.

# Exporting data from dplyr
# Below, we cleaned our original data using dplyr commands, and then exported the document as a csv file.
 
surveys_complete <- surveys %>%
  filter(species_id != "",
         !is.na(weight),
         !is.na(hindfoot_length),
         sex != "")

species_count <- surveys_complete %>%
  group_by(species_id) %>%
  tally %>%
  filter(n >= 50) %>%
  select(species_id)

surveys_complete <- surveys_complete %>%
  filter(species_id %in% species_count$species_id)

surveys_complete

write_csv(surveys_complete, path = "surveys_complete.csv") # write a csv document 

# Visualizing Data -- a toolkit -------------------------------------------
library(tidyverse) # not necessary if package is already loaded, but helps to communicate that this package is still needed in this section of code.

surveys_complete <- read_csv("surveys_complete.csv") # reads in the surveys_complete.csv file.

ggplot(data = surveys_complete) # initiates a plot

ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
  geom_point()  # creates a plot of variables weight and hindfoot_length using a scatterplot geometry. The plot will appear in the "Plots" pane, but will not be saved.

surveys_plot <- ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
  geom_point() # saves the plot as an object, but does not appear in the "Plots" pane.

surveys_plot + ggtitle("Wow! Look at those hindfeet") # adds a layer to the surveys_plots object. 

ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 1/20, color = "blue") # change the color of the scatter plot. When alpha = 1/20, only locations on the scatter plot where 20 points overlap will be full color, while places where there is only one point will have 1/20th the color. This helps with seeing the density of points in a densely populated scatter plot. Additionally, because the color is not mapped to an aesthetic, the whole plot will be blue.

ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 1/10, aes(color = species_id)) # here, the color is mapped to the aesthetic species_id, so colors will be coded by species.

ggplot(data = surveys_complete, aes(x = species_id, y = weight)) +
  geom_boxplot() # there are additional geometries that can be used, like geom_boxplot, which makes a boxplot

ggplot(data = surveys_complete, aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 3/10, color = "tomato") +
  geom_boxplot(alpha = 0) # geometries can be combined together, and because ggplots are layered, the last addition will be on "top". 

ggplot(data = surveys_complete, aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 3/10, color = "tomato") +
  geom_violin(alpha = 0) + 
  scale_y_log10() +   # axes can be changed to find better ways to visualize the data
  facet_wrap(~ plot_id)  # plots can be broken out by groups


