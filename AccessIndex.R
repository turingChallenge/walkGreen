AccessIndex <- function(ParkCoordinates, AreasData, newcastle)
{
  
  for (j in seq(1,nrow(parks.coords)))
  {
    
    ParkCoordinates <- parks.coords[j,]
      
    for (i in seq(1,length(AreasData)))
    {
      Coords <- newcastle.coords[i,]
      IndividualParkIndex[i] <- as.numeric(newcastle$All.usual.residents[i]) *exp(-dist(rbind(ParkCoordinates,Coords))/1000)
    }
    
    ParkAccessibilityIndexVector[j] <- sum(IndividualParkIndex)
    
  }
  
  return(ParkAccessibilityIndexVector)
  
}