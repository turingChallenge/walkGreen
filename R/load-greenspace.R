library(sf)
library(dplyr)

g_data = "../OSOpenGreenspace_GB.gml" # the data source
st_layers(g_data)
g_point = st_read(g_data, layer = "AccessPoint")
g_poly = st_read(g_data, layer = "GreenspaceSite")
st_bbox(g_poly)
g_poly$area = st_area(g_poly)
summary(g_poly$area)
summary(g_point)
summary(g_poly)
summary(g$geometry)
plot(g[1:9,])


# analysis
g_poly_large = g_poly %>% 
  filter(as.numeric(area) > 1e6)
plot(g_poly_large$geometry)
mapview::mapview(g_poly_large)
library(tmap)
tmap_mode("view")
qtm(g_poly_large, fill = "function.")
