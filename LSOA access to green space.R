##  Proximity to nearest green space
nc.N <- nrow(newcastle.coords)
min.dist <- rep(NA, nc.N)

for (i in 1:nc.N) {
  e.dist <- sqrt((newcastle.coords[i,1] - parks.coords [,1])^2 + 
    (newcastle.coords[i,2] - parks.coords [,2])^2)
  min.dist[i] <- min(e.dist)
}

##  Local index of access
for (i in 1:nc.N) {
  e.dist <- sqrt((newcastle.coords[i,1] - parks.coords [,1])^2 + 
                   (newcastle.coords[i,2] - parks.coords [,2])^2)
  access.index [i] <- new.pop$All.usual.residents [i] * sum(exp(-e.dist / 1000))
}
rank.access <- order(access.index)

##  Gini access
access.stats <- data.frame(lsoa = newcastle$lsoa11cd, min.dist, access.index, 
                           rank.access)
write.csv(access.stats, file = '../Data/access stats.csv')
