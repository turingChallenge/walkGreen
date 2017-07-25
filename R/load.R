library(sf)
g_data = "../OSOpenGreenspace_GB.gml" # the data source
st_layers(g_data)
g_point = st_read(g_data, layer = "AccessPoint")
g_poly = st_read(g_data, layer = "GreenspaceSite")
summary(g)
summary(g$geometry)
plot(g[1:9,])
