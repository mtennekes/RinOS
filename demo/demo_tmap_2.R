library(tmap)
library(tmaptools)

data("World")

tmap_mode("plot")

tm_shape(World) +
  tm_fill("grey80") +
  tm_borders(lwd = 0.5, col = "white")

tm_shape(World) +
  tm_polygons(col = "grey80", border.col = "white", lwd = 0.5)


tm_shape(World) +
  tm_polygons(col = "life_exp", palette = "viridis", border.col = "white", lwd = 0.5)

tm_shape(World) +
  tm_polygons(col = "pop_est_dens", breaks = c(0, 100, 200, 400, 800, 1600))

tm_shape(World) +
  tm_polygons(col = "", style = "kmeans")


hist(World$pop_est_dens, breaks = 50)


tm_shape(World) +
  tm_polygons(col = "grey80", border.col = "white", lwd = 0.5) +
  tm_bubbles(size = "pop_est", col = "orange", scale = 1.5)

tm_shape(World) +
  tm_fill("pop_est_dens") +
  tm_facets("continent")

Europe <- World %>% 
  filter(continent == "Europe")

tm_shape(Europe) +
  tm_fill("pop_est_dens")

data("NLD_muni")
NLD_muni$pop_density <- NLD_muni$population / (as.numeric(sf::st_area(NLD_muni)) / 1e6)

tm_shape(NLD_muni) +
  tm_polygons("pop_density", breaks = c(0, 500, 1000, 2500, 5000, Inf))

max(NLD_muni$pop_density)

hist(log(NLD_muni$pop_density))

tm_shape(NLD_muni) +
  tm_polygons("pop_density", breaks = c(0, 500, 1000, 2500, 5000, Inf), legend.hist = TRUE) +
  tm_layout(inner.margins = c(0.02,0.2,0.05,0.05))

data("land")

tm_shape(land) +
  tm_raster("cover_cls", palette = c("green", "brown", "green2", "blue", "yellow", "red", "white", "lightblue")) +
  tm_layout(legend.position = c("left", "bottom"))


# alternative to tmap is mapview
library(mapview)
mapview(NLD_muni)
