##############################################################
# tutorial with the data set women from the datasets package
##############################################################

data(women)

# new variables
women$heightCm = women$height * 2.54
women$weightKg = women$weight / 2

# check
str(women)
summary(women)

# plot
hist(women$heightCm, breaks = 5)
plot(x = women$weightKg, y = women$heightCm)

# save
saveRDS(women, file = "women.rds")


##############################################################
# tutorial with the iris set women from the datasets package
##############################################################
data(iris)

# check
str(iris)
summary(iris)

iris_sel <- iris[iris$Species == "versicolor" & iris$Sepal.Length > 6.5, ]

# plot
plot(iris)
hist(iris$Petal.Length)

plot(x = iris$Petal.Length, 
     y = iris$Sepal.Length, 
     main = "Petal against sepal length", 
     xlab = "Petal length", 
     ylab = "Sepal length")

# table
iris$Sepal.Length.Class <- cut(iris$Sepal.Length, breaks = 4:8)
table(iris$Species, iris$Sepal.Length.Class)

# save
saveRDS(iris_sel, file = "iris_sel.rds")

