# install packages from CRAN
install.packages("deducorrect")

# install package from github

library(remotes)
remotes::install_github("edwindj/ffbase", subdir="pkg")
remotes::install_github("mtennekes/tabplot")

# test package
library(tabplot)
tableplot(iris)

# R version, OS, packages installaed (with version numbers)
sessionInfo()

install.packages("treemap")
library(treemap)
data("business")

treemap(business,
        index=c("NACE1", "NACE2"),
        vSize="employees",
        title.legend="number of NACE4 categories",
        type="value")

treemap(business, 
        index=c("NACE1", "NACE2", "NACE3"), 
        vSize="turnover", 
        type="index")
