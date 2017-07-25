##  Code to get the gini coef for a lorenz curve

gini <- function(x, y, sort.var){
  ascending <- sort(sort.var)
  
  N <- length(ascending)
  
  ##  Now to get the sums per percentile group for our x and ys
  sum.x <- rep(NA,N); sum.y<-rep(NA,N)
  for (i in 1:N){
    sum.x[i] <- sum(x[sort.var == ascending[i]])
    sum.y[i] <- sum(y[sort.var == ascending[i]])#i think this is superfluous but let's go with it
  }
  ##  cumulative sums
  csum.x <- cumsum(sum.x) / sum(sum.x)
  csum.y <- cumsum(sum.y) / sum(sum.y)
  
  ## The below has been checked to be right;
  out <- t(csum.y[-N]) %*% csum.x[-1] - t(csum.y[-1]) %*% csum.x[-N]
  return(out)
}
