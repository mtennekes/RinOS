library(tmap)

data("World")
data("metro")
data("land")

World

plot(World)

# qtm = quick thematic map
qtm(World)

head(World)

qtm(World, fill = "well_being")

tm_shape(World) +
  tm_polygons(col = "well_being")

tmap_mode("view")

tm_shape(World) +
  tm_polygons(col = "well_being") +
  tm_dots()


tmap_mode("plot")

# lazy option
ttm()

plot(metro)
qtm(metro)

tm_shape(metro) +
  tm_dots("pop2020", size = 1, palette = "viridis")

tmaptools::palette_explorer()

ttm()

tm_shape(metro) +
  tm_dots("pop2020", size = .05, palette = "viridis", style = "pretty", n = 10)

tm_shape(land) +
  tm_raster()


tm_shape(land) +
  tm_raster("trees", alpha = 0.8, style = "cont") +
tm_shape(World) + 
  tm_borders()

library(spData)
data("nz")
data("nz_height")

qtm(nz) +
qtm(nz_height)

tm_shape(nz) +
  tm_polygons("grey") +
tm_shape(nz_height) +
  tm_dots("magenta")

library(rnaturalearth)

airports <- rnaturalearth::ne_download(scale = 10, type = "airports", returnclass = "sf")

qtm(airports)

# csv
# read.csv  / read.csv2 / read.table

# readr (from tidyverse)
# read_csv  / read_csv2 / read_table

# read excel
# readxl::read_xlsx()

# spatial data
# sf::st_read

# dbplyr for databases

# sparklyr for spark










