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

2.2 * weight_kg

## Variables can be reassigned
weight_kg <- 57.5
2.2 * weight_kg

## Functions
a <- 5
b <- sqrt(a)

# function can have multiple arguments
round(3.14159)
args(round)   # What arguments does round take?
?round     # help! what does round() do???
round(3.14159, digits = 2)  # arguments can be named. This often helps with clarity.
round(3.14159, 2)     # Don't have to explicitly name the arguments
round(digits = 2, x = 3.14159)     # but if you do, they can be in any order

# Vectors
weight_g <- c(50, 60, 65, 82)
animals <- c("mouse", "rat", "dog")

length(weight_g)
length(animals)

class(weight_g) 
class(animals)

str(weight_g)   # structure of weight_g
str(animals)

weight_g <- c(weight_g, 90) # add to the end of the vector

# subsetting
animals <- c("mouse", "rat", "dog", "cat")
animals[2]

# Conditional subsetting
weight_g <- c(21, 34, 39, 54, 55)
weight_g[c(TRUE, FALSE, TRUE, TRUE, FALSE)]

# Missing data
# NA is a special data type in R. R has many built in functions deal with NAs (ex. na.rm = TRUE)

# Starting with Data ------------------------------------------------------
download.file("https://ndownloader.figshare.com/files/2292169",
              "portal_data_joined.csv")

surveys <- read.csv("portal_data_joined.csv")

head(surveys)
str(surveys)

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


# Visualizing Data -- a toolkit -------------------------------------------


