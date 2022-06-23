library(tidyverse)

adult <- readr::read_csv2("day2/data/adult.csv")

# tidy way
filter(adult, age > 65)
select(adult, age, occupation)

adult_old <- adult %>% 
  filter(age > 65) %>% 
  select(age, occupation)

# |> can also be used:
adult_old <- adult |>
  filter(age > 65) |> 
  select(age, occupation)

# pipe operator explanation
#
# simple function that adds y to x
ADD <- function(x, y) {
  x + y
}  

# suppose we want to add 4, 6, and 8

# without pipe 
n1 <- ADD(4, 6)
n2 <- ADD(n1, 8)

# with pipe
4 |>
  ADD(6) |> 
  ADD(8)




adult %>% 
  group_by(education) %>% 
  summarize(min_age = min(age),
            max_age = max(age),
            mean_age = mean(age)) %>% 
  arrange(mean_age)


# base R
table(adult$education)

adult %>% 
  group_by(education) %>% 
  summarize(number = n())

summary(adult)


# base R
adult[adult$age > 65, ]
adult[, c("age", "occupation")]

temp <- adult[adult$age > 65, ]
adult_old <- temp[, c("age", "occupation")]


# joins
(d1 <- tibble(key = letters[1:4], X = 1:4))
(d2 <- tibble(KEY = letters[2:5], Y = 6:9))

inner_join(d1, d2, by = c("key"= "KEY"))
left_join(d1, d2, by = c("key"= "KEY"))
right_join(d1, d2, by = c("key"= "KEY"))
full_join(d1, d2, by = c("key"= "KEY"))

d1 %>% 
  filter(X > 3) %>% 
  left_join(d2, by = c("key"= "KEY")) %>% 
  rename(x = X,
         y = Y)

library(data.table)

