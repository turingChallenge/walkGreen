AccessIndex <- function(ParkCoordinates, AreasData)
{
  
  AreasData$AccessibilityIndex <- NULL
  
  for (i in seq(1,length(AreasData)))
  {
    AreasData$AccessibilityIndex[i] <- AreasData$Population[i] *exp(-dist(data.frame(x1 = ParkCoordinates, x2 = c(AreasData$x, AreasData$y))))
  }
  
  return(sum(AreasData$AccessibilityIndex))
  
}