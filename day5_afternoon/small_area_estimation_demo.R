
#############################################################################
# Demonstration of small area estimation using R packages hbsae and mcmcsae
# - direct domain estimates using survey
# - regression synthetic estimates
# - domain-specific regression estimates
# - SAE based on a basic multilevel model
# - benchmarking
# - SAE using independent and spatial random effects


# use api dataset from the survey package
library(survey)
data(api)

head(apipop)

dim(apipop)  # population of schools in California
dim(apisrs)  # a simple random sample from apipop

# we will estimate the average academic performance index (variable api00)
# for Californian schools by county (variable cname)
# and suppose that we only observe api00 for schools in the sample
# (unlike in real life, we can compare our estimates with true values computed from apipop)


# sample data provided is really small (favouring simple regression synthetic estimates)
# --> we draw our own, larger, sample, stratified by school type (variable stype)

table(apipop$cname)

# stratify by school type
Nst <- table(apipop$stype)
nst <- c(200, 150, 150)  # stratum sample sizes
s <- NULL
for (i in seq_len(nlevels(apipop$stype))) {
  s <- c(s, sample(which(apipop$stype == levels(apipop$stype)[i]), nst[i]))
}
apisam <- apipop[s, ]
table(apisam$stype)
apisam$iw <- (Nst/nst)[apisam$stype]  # inclusion weight

table(apisam$cname)  # highly unbalanced over counties

# based on the sample apisam, estimate the population mean of
# api00 (academic performance index of Californian schools)

# define the regression/weighting model
model <- api00 ~ stype + col.grad + sch.wide
# include stype, as it is a design variable, defining the sampling strata
# col.grad: parent education level, percentage college graduate
# sch.wide: met school-wide growth target

# compute corresponding population totals
XpopT <- colSums(model.matrix(model, apipop))
N <- XpopT[["(Intercept)"]]  # population size


####################
# direct estimates

# create the survey design object
des <- svydesign(ids=~1, data=apisam, strata = ~ stype, weights=~iw, fpc=Nst[apisam$stype])
# compute the calibration or GREG estimator
cal <- calibrate(des, formula=model, population=XpopT)

# direct GREG estimates of mean api by county:
direct <- svyby(~ api00, by = ~ cname, design = cal, FUN=svymean)
direct


######################################
# regression 'synthetic' estimates

fit <- lm(model, data=apisam)
summary(fit)  # note the high R-squared

# by county:
# the easiest way to compute estimates is by using lm's predict method:
reg_synthetic <- c(tapply(predict(fit, newdata=apipop), apipop$cname, mean))
# for clarity of presentation we ignore fpc here

estimates <- data.frame(
  reg_synthetic = reg_synthetic,
  direct = coef(direct)[names(reg_synthetic)]
)
estimates
# NB some small counties have zero sample size! for those counties there are no direct estimates

plot(estimates$direct, estimates$reg_synthetic, xlab="direct", ylab="regression synthetic",
     col="green", pch=20); abline(0, 1, col="red")
abline(lm(reg_synthetic ~ direct, data=estimates), lty=2)
# note the shrinkage


#########################################
# domain specific regression estimates

# what if we include county regression effects? (omitting effects for out-of-sample counties)
model2 <- update(model, . ~ . + cname)
model2
fit2 <- lm(model2, data=apisam)
summary(fit2)  # note that some county coefficients have large standard errors

Xpop_county <- rowsum(model.matrix(model2, apipop), group=apipop$cname)
N_county <- Xpop_county[, "(Intercept)"]  # county population sizes
reg_direct <- drop(Xpop_county[, names(coef(fit2))] %*% coef(fit2) / N_county)
# out-of-sample counties here estimated using base-level
# could use predict here as well, but should first make cname a factor variable including all levels existing in apipop

estimates$reg_direct <- reg_direct

plot(estimates$direct, estimates$reg_synthetic, xlab="direct", ylab="model-based",
     ylim=range(c(estimates$reg_synthetic, estimates$reg_direct)))
abline(0, 1, col="red")
points(estimates$direct, estimates$reg_direct, pch=20, col="green")
# less shrinkage, closer to direct estimates
legend("topleft", legend=c("regression-synthetic", "including county regression effects"),
       col=c("black", "green"), pch=c(1, 20))
abline(lm(reg_synthetic ~ direct, data=estimates), lty=2)
abline(lm(reg_direct ~ direct, data=estimates), col="green", lty=2)



############################################################
# SAE based on a multilevel model - basic unit-level model

library(hbsae)  # R package for hierarchical Bayesian small area estimation
# use argument area to specify the random effects (independent random intercepts)
sae <- fSAE(model, data=apisam, area="cname", popdata = Xpop_county)
sae  # summary of model fit and estimates

estimates$sae = EST(sae)

plot(estimates$direct, estimates$reg_synthetic, xlab="direct", ylab="model-based",
     ylim=range(c(estimates$reg_synthetic, estimates$reg_direct, estimates$sae)))
abline(0, 1, col="red")
points(estimates$direct, estimates$reg_direct, pch=20, col="green")
points(estimates$direct, estimates$sae, pch=3, col="blue")
legend("topleft", legend=c("regression-synthetic", "including county regression effects", "basic unit-level multilevel model"),
       col=c("black", "green", "blue"), pch=c(1, 20, 3))
# note the partial pooling: small area estimates typically in between complete pooling (regression-synthetic)
#   and no pooling (model with county regression effects)
abline(lm(reg_synthetic ~ direct, data=estimates), lty=2)
abline(lm(reg_direct ~ direct, data=estimates), col="green", lty=2)
abline(lm(sae ~ direct, data=estimates), col="blue", lty=2)

# weights of direct estimates in the composite sae estimates:
sae$gamma

# compare also with 'truth':
Ybar <- drop(tapply(apipop$api00, apipop$cname, mean))

# construct a data frame for easy plotting using package dotwhisker
plot_data <- rbind(
  data.frame(
    model="direct",
    term=rownames(estimates),
    estimate=estimates$direct,
    std.error=direct[names(reg_synthetic), "se"]
  ),
  data.frame(
    model="sae",
    term=rownames(estimates),
    estimate=EST(sae),
    std.error=hbsae::SE(sae)
  ),
  data.frame(
    model="true",
    term=rownames(estimates),
    estimate=Ybar,
    std.error=0
  )
)
#install.packages("dotwhisker")
dotwhisker::dwplot(plot_data)

# mean absolute error
sum(abs(estimates$direct - Ybar), na.rm=TRUE)  # note that 'empty' areas are removed!!
sum(abs(estimates$reg_synthetic - Ybar))
sum(abs(estimates$reg_direct - Ybar))
sum(abs(estimates$sae - Ybar))
# for a fairer comparison to direct estimates:
sum(abs(estimates$sae - Ybar)[!is.na(estimates$direct)])

# more visualisation: map plots
# first read shape file for geographic information
California <- rgdal::readOGR("day5/data/CaliforniaCounty/CaliforniaCounty.shp")
class(California)
head(California@data)
m <- match(California@data$NAME, rownames(estimates))
California@data$direct <- estimates$direct[m]
California@data$reg_synthetic <- estimates$reg_synthetic[m]
California@data$reg_direct <- estimates$reg_direct[m]
California@data$sae <- estimates$sae[m]
California@data$true <- Ybar[m]
sp::spplot(California, c("direct", "reg_synthetic", "sae", "true"))
# or use package tmap



################
# benchmarking

(GREG_total <- coef(svytotal(~ api00, cal)))
sum(N_county * EST(sae))
# small 'cosmetic' difference
sae_bm <- hbsae::bench(sae, rhs=GREG_total)
sum(N_county * EST(sae_bm))
plot(sae, sae_bm)



###########################
# using R package mcmcsae

library(mcmcsae)

# here we need a factor variable for the counties
apipop$cname <- as.factor(apipop$cname)
apisam$cname <- factor(apisam$cname, levels=levels(apipop$cname))

# set up a sampler object
sampler <- create_sampler(
  api00 ~ 
    reg(~ stype + col.grad + sch.wide, name="beta") +   # regression part
    gen(~ 1, factor = ~ cname, name="v"),               # random area intercepts
  data=apisam
)

# model fitting by MCMC simulation
sim <- MCMCsim(sampler, store.all=TRUE)
(summ <- summary(sim))

(DIC <- compute_DIC(sim))

# now compute SAE by predicting for the non-observed population units, and aggregate to the county level
m <- match(apisam$cds, apipop$cds)  # population units in the sample
samplesums <- tapply(apisam$api00, apisam$cname, sum)  # observed part
samplesums[is.na(samplesums)] <- 0
pred <- predict(sim, 
                newdata = apipop[-m, ],
                fun = function(x) (samplesums + tapply(x, apipop$cname[-m], sum)) / N_county,
                labels = levels(apipop$cname))
(summpred <- summary(pred))
estimates[, "mcmcsae"] <- summpred[, "Mean"]
# as expected, very similar to those found using hbsae



##########
# Example of a multilevel model with spatial in addition to independent county effects
?correlation  # see what correlation structures are supported


# make sure the county ordering is the same
California <- California[match(levels(apipop$cname), California@data$NAME), ]

samplerS <- create_sampler(
  api00 ~ 
    reg(~ stype + col.grad + sch.wide, name="beta") +                      # regression part
    gen(~ 1, factor = ~ cname, name="v") +                                 # independent random area intercepts
    gen(~ 1, factor = ~ spatial(cname, poly.df = California), name="vs"),  # spatial random area intercepts
  block = TRUE,  # improves MCMC convergence
  data=apisam
)

# model fitting by MCMC simulation
simS <- MCMCsim(samplerS, store.all=TRUE)
(summS <- summary(simS))

(DICS <- compute_DIC(simS))

# plot the independent and random county effect estimates
California@data$v <- summS$v[, "Mean"]
California@data$vs <- summS$vs[, "Mean"]
sp::spplot(California, c("v", "vs"))


# compute SAE based on this fitted model in exactly the same way
predS <- predict(simS,
                 newdata = apipop[-m, ],
                 fun = function(x) (samplesums + tapply(x, apipop$cname[-m], sum)) / N_county,
                 labels = levels(apipop$cname))
(summpredS <- summary(predS))
estimates[, "mcmcsae_spatial"] <- summpredS[, "Mean"]


