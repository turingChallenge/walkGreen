##  File to calculate potential accessibility of each green space

##  maybe not run this 
x <- c("ggmap", "rgdal", "rgeos", "maptools", "dplyr", "tidyr", "tmap",
       'shapefiles','sp','spdep','MCMCpack', 'raster')
lapply(x, library, character.only = TRUE) # load the required packages; again this is a remarkably 


##  Load lsoa centroid files 
library(sf)
newcastle <- readOGR(dsn = '../Data/newcastle lsoa', 
                     layer='nc lsoa') #England and Wales technically; huge number of LSOAs so seems right


##  load in parks file 
nc.parks <- read_sf('../Data/park-points.geojson')
nc.parks <- st_transform(nc.parks, proj4string(newcastle))



