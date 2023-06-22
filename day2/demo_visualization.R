## example of a treemap

library(treemap)

# example taken from documentation, see ?treemap
data(GNI2014)
treemap(GNI2014,
        index=c("continent", "iso3"),
        vSize="population",
        vColor="GNI",
        type="value",
        format.legend = list(scientific = FALSE, big.mark = " "))

# save to a png file
png("treemap.png", width = 1000, height = 700)
treemap(GNI2014,
        index=c("continent", "iso3"),
        vSize="population",
        vColor="GNI",
        type="value",
        format.legend = list(scientific = FALSE, big.mark = " "))
dev.off()

## example of an interactive visualization

library(dygraphs) # a package for interactive time-series plots

# taken from documentation example, see ?dygraph
lungDeaths <- cbind(mdeaths, fdeaths)
w <- dygraph(lungDeaths)
w

# save this plot (or any interactive plot):
library(htmlwidgets)
htmlwidgets::saveWidget(w, file = "ts.html")

## ggplot2 examples
library(tidyverse)

# for this example, we use the mpg dataset
data(mpg)
?mpg
str(mpg)

# create a new variable: number of cylinders as a categorical variable
mpg$cyl_fact = as.factor(mpg$cyl)

g = ggplot(data = mpg,
       aes(x = displ,
           y = hwy,
           color = cyl_fact,
           shape = cyl_fact)) +
  geom_point()
  
g

# change titles
  
g + 
  scale_x_continuous("Displacement") +
  scale_y_continuous("Highway miles per gallon") +
  scale_color_discrete("Number of cylinders") +
  scale_shape_discrete("Number of cylinders")

# create small multiples
g + facet_wrap(~trans, scales = "free")


# small dataset taken from a website: https://www.learnbyexample.org/r-bar-plot-ggplot2/
survey <- data.frame(fruit=c("Apple", "Banana", "Grapes", "Kiwi", "Orange", "Pears"),
                     people=c(40, 50, 30, 15, 35, 20))

# manual colors
ggplot(survey, aes(x=fruit, y=people, fill = fruit)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values = c("green", "yellow", "pink", "#00CC33", "orange", "lightgreen"))


## colors in R: cols4all package
library(cols4all)
# if not installed, please install fist

# opens a dashboard for selecting color palettes
c4a_gui()

# apply the carto.safe palette in ggplot
ggplot(survey, aes(x=fruit, y=people, fill = fruit)) +
  geom_bar(stat="identity") +
  cols4all::scale_fill_discrete_c4a_cat("carto.safe")

# another ggplot2 example

p <- ggplot(mtcars) + 
  geom_point(aes(x = disp, y = hp))
             
p + facet_wrap(~cyl)
p + facet_wrap(~am)

# create an interactive version of ggplot2 charts
library(plotly)
wp = ggplotly(p)

saveWidget(wp, "mpg.html")

