##  Proximity to nearest green space
nc.N <- nrow(newcastle.coords)
min.dist <- rep(NA, nc.N)

for (i in 1:nc.N) {
  e.dist <- sqrt((newcastle.coords[i,1] - parks.coords [,1])^2 + 
    (newcastle.coords[i,2] - parks.coords [,2])^2)
  min.dist[i] <- min(e.dist)
}

##  Local index of access

access.index <- rep(NA, nc.N)
for (i in 1:nc.N) {
  e.dist <- sqrt((newcastle.coords[i,1] - parks.coords [,1])^2 + 
                   (newcastle.coords[i,2] - parks.coords [,2])^2)
  e.dist <- e.dist[e.dist<500]
  access.index [i] <- new.pop$All.usual.residents [i] * sum(exp(-e.dist / 1000))
}
rank.access <- order(access.index, decreasing = T)
order(access.index)

newcastle$All.usual.residents
##  Gini access
access.stats <- data.frame(lsoa11cd = newcastle$lsoa11cd,
                           pop = newcastle$All.usual.residents,
                           min.dist, access.index, 
                           rank.access)
write.csv(access.stats, file = '../Data/access stats.csv')

##  Within X distance of a park
access.stats <- access.stats[order(access.stats$min.dist), ]
access.stats$cum.pop <- cumsum(access.stats$pop) / sum(access.stats$pop)
plot(access.stats$min.dist, access.stats$cum.pop)

##  