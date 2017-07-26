##  Access graphics
library(ggplot2)

##  Plot of access by cumulative prop
ggplot(aes(x = min.dist, y = cum.pop),  data=access.stats) + 
  geom_area(fill = 'red') + ggtitle('Pop. within x metres of a green space')


##
newcastle <- merge(newcastle, access.stats, by = 'lsoa11cd')
head(newcastle)
green.prop <- read.csv('../Data/newcastle_green_lsoas_intersects.csv')
newcastle <- merge(newcastle, green.prop, by = 'lsoa11cd')
newcastle$per.green <- newcastle$sqm_green / newcastle$sqm_lsoa * 100

#imd
imdNc <- read.csv('../Data/newcastle lsoa/E08000021.csv', 
                  stringsAsFactors = F)
imdNc
nref <- nchar(imdNc$Reference.area)
imdNc$lsoa11cd <- substr(imdNc$Reference.area, nref - 9, nref)
newcastle <- merge(newcastle, imdNc, by.x = 'lsoa11cd', by.y = 'LSOA11CD')
head(newcastle)

# ahah
ahahNc <- read.csv('../Data/newcastle lsoa/newcastle ahah.csv', 
                  stringsAsFactors = F)
newcastle <- merge(newcastle, ahahNc, by = 'lsoa11cd')
head(newcastle)


##
mapNc <- tm_shape(newcastle) +
  tm_polygons(c('per.green', 'access.index', 'e_dom'), 
              palette = list('Greens', "Purples", 'Blues'), 
              contrast = .7, alpha = 0.7, legend.show = T,
              title = c("Percentage green space", "Accessibilty by walking index", 'Access to physical environment AHAH')) +
  tm_shape(nc.parks) + tm_dots('accessType', title = "Green space entrance")

mapNc
##  Lorenz curve of prop of city pop to green space
newcastle$sqm_green[is.na(newcastle$sqm_green)] <- 0 
newcastle$prop.total.green <- newcastle$sqm_green / sum(newcastle$sqm_green)


newcastle <- newcastle[order(newcastle$prop.total.green), ]
newcastle$cum.green <- cumsum(newcastle$prop.total.green)
newcastle$cum.popgreen <- cumsum(newcastle$pop) / sum(newcastle$pop)
plot(y = newcastle$cum.green, x = newcastle$cum.popgreen)

## Calculating the gini coefficient of the it 
source('gini function.R')
gini.green <- gini(y = newcastle$cum.green, x = newcastle$cum.popgreen, 
                   sort.var = newcastle$cum.green)

ggplot(aes(x = cum.popgreen, y = cum.green),  data= newcastle@data) + 
  geom_area(fill = 'green', alpha = 0.7) + 
  geom_abline(intercept = 0, slope = 1, alpha =0.2) +
  ggtitle('Proportion of green space in city by population (Gini coef = 0.65)') +
  ylab('Cumulative proportion of public green space') +
  xlab('Cumulative proportion of population')
