## Load requires packages

library(sf)
library(stars)
library(terra)
library(tmap) # NOTE: this demo script uses version tmap 3.3. Currently a major update is being developed, which will be released at the end of 2023 or early 2024.
library(tmaptools)

## load datasets from tmap
data(World, land, metro)

## Shapefiles from Eurostat

# download here: https://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units/countries
eu <- st_read("day3/data/ref-countries-2020-10m/CNTR_RG_10M_2020_3035.shp.zip")
qtm(eu)

# switch to view mode
tmap_mode("view")

# reload the plot, but now in interactive mode
qtm(eu)

# plot the variable EU_STAT (whether a country is in the EU or not)
tm_shape(eu) +
  tm_polygons("EU_STAT")

# static plot
tmap_mode("plot")
tm_shape(eu, projection = "+proj=robin") +
  tm_polygons("EU_STAT")

## tmap examples
qtm(World)

tm_shape(World) +
  tm_bubbles("area") +
  tm_borders()

data(land)
qtm(land)

tm_shape(World) +
  tm_bubbles("area") +
  tm_borders()

tmap_mode("view")

qtm(land) +
  tm_shape(World) +
  tm_borders()

# color palettes for tmap can be selected from a tool called palette_explorer:
library(tmaptools)
palette_explorer()

tmap_mode("plot")
tm_shape(World) +
  tm_polygons("HPI", palette = "viridis")

tmap_mode("view")
tm_shape(World) +
  tm_polygons("HPI", palette = "viridis")

ttm()
qtm(World)

# tmap v4.0 will not support these palettes anymore, but instead, will support a much greater set of palettes, namely from the cols4all package
library(cols4all)
c4a_gui()

# You can use this tool to select a color palette. You can click on the little R on the right-hand-side of the palette which is a copy button. And paste the result in the script:

pal_viridis_10 <- c("#FDE725", "#B3DD2B", "#6DCD58", "#38B777", "#219D87", "#26828D", "#31688D", "#3E4A88", "#472877", "#440154")

# Or, even easier, use the c4a function:
pal_viridis_10 <- c4a("viridis", n = 10)

# special palette for land use
pal8 <- c("#33A02C", "#B2DF8A", "#FDBF6F", "#1F78B4", "#999999", "#E31A1C", "#E6E6E6", "#A6CEE3")

tm_shape(land) +
  tm_raster("cover_cls", palette = pal8) +
tm_shape(World) +
  tm_borders(lwd = 0.5) +
  tm_legend(frame = TRUE, position = c("left", "bottom"))

## Cartogram
library(cartogram)

World_robin <- st_transform(World, crs = "+proj=robin")

# three different types of cartograms:

World_inflated <- cartogram_cont(
  World_robin,
  weight = "pop_est")

tm_shape(World_inflated) +
  tm_polygons()

World_ncont <- cartogram_ncont(
  World_robin,
  weight = "pop_est")

tm_shape(World_ncont) +
  tm_polygons()

World_dorling <- cartogram_dorling(
  World_robin,
  weight = "pop_est")

tm_shape(World_dorling) +
  tm_polygons()

## case study: Montenegro data
M_data <- read.csv2("day3/data/mne_population_2022.csv")
M_shp <- st_read("day3/data/graniceop_utm_CGP.shp")

# find mismatches
setdiff(M_shp$SIFRAOPSTI, M_data$code)
setdiff(M_data$code, M_shp$SIFRAOPSTI)

# plot mismatches
tmap_mode("view")
M_shp[M_shp$SIFRAOPSTI == 0, ] |> qtm()

# impute 0 by the correct codes
M_shp$SIFRAOPSTI[which(M_shp$IMEOPSTINE == "Petnjica")] <- 20265
M_shp$SIFRAOPSTI[which(M_shp$IMEOPSTINE == "Gusinje")] <- 20273
M_shp$SIFRAOPSTI[which(M_shp$IMEOPSTINE == "Herceg Novi")] <- 20192

# join the data
M_shp2 <- M_shp |> 
  left_join(M_data, by = c("SIFRAOPSTI" = "code"))

tm_shape(M_shp2) +
  tm_bubbles("Pop_est_2022", col = "blue", scale = 2, id = "IMEOPSTINE", popup.vars = TRUE) +
  tm_borders()
