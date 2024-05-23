
################################################
# Demonstration of R package survey
# - GREG weighting
#   'model-assisted' method based on a linear regression model
# - Estimation of population means and totals, possibly for subpopulations
# - Variance estimation


library(survey)
data(api)  # load the Academic Performance Data, provided by the survey package

dim(apipop)  # population of schools in California
dim(apisrs)  # a simple random sample from apipop

# based on the sample apisrs, estimate the population total of
# api00 (academic performance index of Californian schools)

# define the regression model
model <- api00 ~ ell + meals + stype + hsg + col.grad + grad.sch
# api00: academic performance index, year 2000
# ell: percentage English language learners
# meals: percentage of students in free or reduced price lunch program
# stype: school type (elementary, middle, high)
# hsg: parent education, percentage high school graduate
# col.grad: parent education, percentage college graduate
# grad.sch: parent education, percentage graduate school

# compute corresponding population totals
XpopT <- colSums(model.matrix(model, apipop))
N <- XpopT[["(Intercept)"]]  # population size

# create the survey design object
des <- svydesign(ids = ~ 1, data = apisrs, weights = ~ pw, fpc = ~ fpc)
summary(des)
weights(des)  # inclusion weights, i.e. inverse sampling probabilities
?svydesign


# compute the calibration or GREG estimator
cal <- calibrate(des, formula = model, population = XpopT)
?calibrate

w <- weights(cal)
hist(w)
# weight diagnostic: square root of design effect of the weights
(deft <- sqrt((1 + var(w)/mean(w)^2)))


# estimation of population total
svytotal(~ api00, des)  # HT estimate
svytotal(~ api00, cal)  # GREG estimate

# estimation of population means
(HT <- svymean(~ api00, des))  # HT estimate
(GREG <- svymean(~ api00, cal))  # GREG estimate

coef(HT); coef(GREG)        # extract the estimates
SE(HT); SE(GREG)            # extract the estimated standard errors
confint(HT); confint(GREG)  # extract approximate 95% confidence intervals

# this is just a demo, and here the true mean is available to check our estimates against:
mean(apipop$api00)


# GREG estimates for subpopulations, e.g. by province
svyby(~ api00, by = ~ stype, design=cal, FUN=svymean)


# detailed estimates:
svyby(~ api00, by = ~ cname, design=cal, FUN=svymean)
# but wait, why are there zero standard errors?



