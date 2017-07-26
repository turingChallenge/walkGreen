##  Access graphics
library(ggplot2)

##  Plot of access by cumulative prop
ggplot(aes(x = min.dist, y = cum.pop),  data=access.stats) + 
  geom_area(fill = 'red') + ggtitle('Pop. within x metres of a green space')

##  Plot the map of accessibility ranks
newcastle <- merge(newcastle, access.stats, by = 'lsoa11cd')
head(newcastle)
green.prop <- read.csv('../Data/newcastle_green_lsoas_intersects.csv')
newcastle <- merge(newcastle, green.prop, by = 'lsoa11cd')
newcastle$per.green <- newcastle$sqm_green / newcastle$sqm_lsoa * 100

#doesn't work: imd
imdNc <- read.csv('../Data/newcastle lsoa/imd 2015 deciles.csv', 
                  stringsAsFactors = F)
nref <- nchar(imdNc$Reference.area)
imdNc$lsoa11cd <- substr(imdNc$Reference.area, nref - 9, nref)
newcastle <- merge(newcastle, imdNc, by = 'lsoa11cd')

head(imdNc)
table(imdNc$lsoa11cd %in% newcastle$lsoa11cd)
head(newcastle)
# can't work

?tm_polygons

mapNc <- tm_shape(newcastle) +
  tm_polygons(c('per.green', 'access.index'), palette = list('Greens', "Reds"), 
              contrast = .7, alpha = 0.5, legend.show = T,
              title = c("Percentage green space", "Accessibilty by walking index")) +
  tm_shape(nc.parks) + tm_dots('accessType', title = "Green space entrance")

mapNc

