##  Access graphics
library(ggplot2)

##  Plot of access by cumulative prop
ggplot(aes(x = min.dist, y = cum.pop),  data=access.stats) + 
  geom_area(fill = 'red') + ggtitle('Pop. within x metres of a green space')

##  Plot the map of accessibility ranks
newcastle <- merge(newcastle, access.stats, by = 'lsoa11cd')
head(newcastle)
qtm(newcastle, fill = 'access.index')


nc.parks <- read_sf('../Data/park-points.geojson')
nc.parks <- st_transform(nc.parks, new.proj)
plot(nc.parks)
