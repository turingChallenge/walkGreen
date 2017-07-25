##  File to calculate potential accessibility of each green space

##  maybe not run this 
x <- c("ggmap", "rgdal", "rgeos", "maptools", "dplyr", "tidyr", "tmap",
       'shapefiles','sp','spdep', 'raster')
lapply(x, library, character.only = TRUE) # load the required packages; again this is a remarkably 


##  Load lsoa centroid files 
library(sf)
newcastle.df <- readOGR(dsn = '../Data/newcastle lsoa', 
                     layer='nc lsoa') #England and Wales technically; huge number of LSOAs so seems right
new.proj <- proj4string(newcastle.df)
newcastle.coords <- coordinates(newcastle.df)


new.pop <- read.csv('../Data/newcastle lsoa/newcastle pop.csv', 
                    stringsAsFactors = F)
names(new.pop)[1] <- 'lsoa11cd'
new.pop$lsoa11cd <- substr(new.pop$lsoa11cd, 1, 9)
newcastle <- merge(newcastle.df, new.pop, by = 'lsoa11cd')

##  load in parks file 
nc.parks <- read_sf('../Data/park-points.geojson')
nc.parks <- st_transform(nc.parks, new.proj)

##  Extract coords for parks
parks.coords <- st_coordinates(nc.parks)

