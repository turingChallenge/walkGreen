library(sp)
library(sf)
library(dplyr)
# Aim: download and analyse OD data for walking
u = "https://github.com/npct/pct-bigdata/releases/download/1.6-beta/l_nat.Rds"
download.file(u, "l.Rds")
l = readRDS("l.Rds")
l = st_as_sf(l)
# find all people walking to work in newcastle
download.file(url = "https://github.com/npct/pct-bigdata/blob/master/england_lad_2011.Rds?raw=true", "england_lad_2011.Rds")
lads = readRDS("england_lad_2011.Rds")
lads$namechar = as.character(lads$name)
lads = st_as_sf(lads)
lads = st_transform(lad, 4326)
lad = lads[grepl(pattern = "Newcastle up", x = lads$name), ]
plot(lad)
write_sf(lad, "../data/newcastle.geojson")

# analyse walking to work
l = select(l, dist, msoa1, msoa2, all, foot, bicycle, car_driver)
l = l %>% filter(dist < 2)
l = l[lad,]
plot(l$geometry)
plot(lad, add = T)

write_sf(l, "../data/od-lines.geojson")

g_poly = st_transform(g_poly, 4326)
g_point = st_transform(g_point, 4326)
g_poly_lad = g_poly[lad,]
g_point_lad = g_point[lad,]
plot(g_poly_lad, add = T, col = "green")
plot(g_point_lad, add = T, col = "red")
write_sf(g_poly_lad, "../data/parks.geojson")
write_sf(g_point_lad, "../data/park-points.geojson")

# buffer geographic data
devtools::install_github("ropensci/stplanr", ref = "sfr")
library(stplanr)
l_buff_200 = geo_projected(l, st_buffer, dist = 200)
write_sf(l_buff_200, "../data/l_buff_200.geojson")
l_buff_500 = geo_projected(l, st_buffer, dist = 500)
write_sf(l_buff_500, "../data/l_buff_500.geojson")
plot(l_buff_500$geometry)
g_walk = aggregate(l["foot"], g_poly_lad, sum, drop = F)
g_walk200 = aggregate(l_buff_200["foot"], g_poly_lad, sum, drop = F)
g_walk500 = aggregate(l_buff_500["foot"], g_poly_lad, sum, drop = F)
g_walk_cent = st_centroid(g_walk)
g_joined = st_join(g_poly_lad, g_walk)
nrow(g_joined)
names(g_joined)
g_all = left_join(x = g_poly_lad, y = st_set_geometry(g_joined[c("gml_id", "foot")], value = NULL))
g = select(g_all, gml_id, walk_00 = foot)
g_joined = st_join(g_poly_lad, l_buff_200) %>% 
  group_by(gml_id) %>% 
  summarise(foot = sum(foot))
g_all = left_join(x = g, y = st_set_geometry(g_joined[c("gml_id", "foot")], value = NULL))
g$walk200 = g_all$foot

g_joined = st_join(g_poly_lad, l_buff_500) %>% 
  group_by(gml_id) %>% 
  summarise(foot = sum(foot))
g_all = left_join(x = g, y = st_set_geometry(g_joined[c("gml_id", "foot")], value = NULL))
g$walk500 = g_all$foot

plot(g$walk_00, g$walk200)
tmap_mode("view")
qtm(st_union(l_buff_500)) +
  qtm(g, "walk500") +
  tm_shape(l) +
  tm_lines(col = "all", lwd = 2, palette = "RdBu", breaks = c(0, 100, 1000, 2000))

readr::write_csv(st_set_geometry(g, NULL), "../data/parks-walk.csv")
plot(g)
plot(g_joined["foot"])
g_poly_lad$walk00 = g_joined$foot
summary(g_joined)
nrow(g_walk)
nrow(g_poly_lad)
row.names(g_walk)
g_walk$gml_id = g_poly_lad$gml_id
plot(g_walk, add = T)
g_df = st_set_geometry(g_poly_lad, NULL)
g_df = left_join(g_df, g_walk)


# geo_bufferag = function(x = l, y = g_poly_lad, var = "foot", dist = 200, fun = sum) {
#   var_quo = quo(var)
#   buff = geo_projected(x, st_buffer, dist = dist)
#   x_agg = aggregate(buff[var], g_poly_lad, sum)
#   g = st_join(x, x_agg) %>% 
#     group_by()
#     summarise(sum(!!var_quo))
#   g
# }