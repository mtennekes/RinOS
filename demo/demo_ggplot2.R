library(tidyverse)

adult <- readr::read_csv2("day2/data/adult.csv") %>% 
  rename(marital = 'marital-status')


adult_age_per_educ <- adult %>% 
  group_by(education) %>% 
  summarize(age = mean(age))

ggplot(adult, aes(x = education, y = age)) +
  geom_bar(stat = "identity", fill = "#FF34DE")

ggplot(adult, aes(x = education, y = age)) +
  geom_bar(stat = "identity", fill = "#FF34DE") +
  coord_flip() +
facet_wrap(~marital)

ggplot(adult, aes(x = education, y = age)) +
  geom_bar(stat = "identity", fill = "#FF34DE") +
  coord_flip() +
  facet_grid(marital~sex)





