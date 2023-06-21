library(tidyverse)

un <- read_table("day2/data/UnitedNations.txt")

ggplot(un, aes(x = lifeFemale, y = tfr, col = region, size = GDPperCapita)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x)
  
g <- ggplot(un, aes(x = lifeFemale))

g + geom_histogram()
g + geom_freqpoly(mapping = aes(col = region), binwidth = 5)
g + geom_histogram(mapping = aes(fill = region)) + facet_wrap(~region)
