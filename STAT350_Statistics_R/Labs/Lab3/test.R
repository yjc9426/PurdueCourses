setwd("~/Desktop/STAT350/STAT350/Labs/Lab3")


#rnorm(n,mean=x,sd=y) generates n random numbers
# that belong to the normal distribution with mean of x # and standard deviation of y.
RandomData <- rnorm(100,mean=5,sd=12)
mean(RandomData)
sd(RandomData)


#generating the histogram with blue line being the normal distribution # and red line the smoothed curve.
# freq = FALSE means that we are plotting relative frequencies or
# densities
std<-sd(RandomData)
m <- mean(RandomData)
quartz()    # pop up a window
#Histogram
# You can change the titles by using main, xlab, and ylab.
# freq = FALSE is required if you will be adding the extra two lines. 

#The blue line is the normal distribution with the estimated  and 
#the red line is the density curve (smoothed curve of the histogram itself).
hist(RandomData, xlab="Data from Normal Distribution", freq = FALSE, 
     main="Histogram with Normal Curve and Smoothed Curve")
# this command plots the normal curve
# dnorm() plots the density curve, x is the density of quantiles # add=TRUE: adds on top of the previous graph
curve(dnorm(x, mean=m, sd=std), col="blue", lwd=2, add=TRUE)  # normal
#this command plots the smooth curve (density)
# If there are too many peaks on the curve, increase the value of # adjust
lines(density(RandomData, adjust=1),col = "red", lwd=2)     # pdf






#If the graphics area in RStudio
#    following command to open a
#    have multiple windows open.
quartz()
#Normal Probability Plot
#qqnorm plots the points for the
# includes a line from Q1 to Q3
# is normal or not.
qqnorm(RandomData,main="Normal Quantile Plot for normal distribution") 
qqline(RandomData)




#n is the number of data points, this is constant
n = 100
#nonnormal distributions

right <- rexp(n,rate=2)
left <- rbeta(n,2,0.5,ncp=2)
short <- runif(n,min=0,max=2)
long <- rcauchy(n,location=0,scale=1)
#right skewed: exponential distribution (lambda=2) with mu=0.5 and sigma=0.5
#left skewed: Beta distribution (on [0,1], alpha = 2, beta = 0.5) with mu = 0.8 and sigma = 0.0457
#short tailed: Uniform (on [0,2]) with mu = 1 and sigma = 0.3333; 
#long tailed: Standard Cauchy with median = 0 and sigma = ?



#there are only two things that need to be changed in the code below. #1) Change which data set that you will be using (in RandomData).
# I have it set for right skewed, you will need to change this to
# left, short, long as appropriate.
#2) The first word in the main title
#  to right skewed, you will need to needs to be changed. I have it set
# change this to left, long, or
#  short as appropriate.
RandomData <- short
title <- "short tailed Distribution"
quartz()






#generating the histogram with blue line being the normal distribution # and red line the smoothed curve.
std<-sd(RandomData)
m <- mean(RandomData)
hist(RandomData, xlab="Data", freq = FALSE, main=title)


curve(dnorm(x, mean=m, sd=std), col="blue", lwd=2, add=TRUE)
lines(density(RandomData, adjust=1),col = "red", lwd=2)     # pdf
#Notice that we recommend that you use adjust = 3 here. However, if # this is too smooth, feel free to reduce that number lines(density(RandomData,adjust=3),col = "red", lwd=2)
quartz()
#plots the qqplot with line on a separate plot
qqnorm(RandomData,main=title)
qqline(RandomData)


















airline_cleaned <- read.delim("~/Desktop/STAT350/STAT350/Labs/Lab2/airline_cleaned.txt")
RandomData <- AirTime
title <- "Airtime Distribution"
quartz()

#generating the histogram with blue line being the normal distribution # and red line the smoothed curve.
std<-sd(RandomData)
m <- mean(RandomData)
hist(RandomData, xlab="Data", freq = FALSE, main=title)


curve(dnorm(x, mean=m, sd=std), col="blue", lwd=2, add=TRUE)
lines(density(RandomData, adjust=1),col = "red", lwd=2)     # pdf
#Notice that we recommend that you use adjust = 3 here. However, if # this is too smooth, feel free to reduce that number lines(density(RandomData,adjust=3),col = "red", lwd=2)
quartz()
#plots the qqplot with line on a separate plot
qqnorm(RandomData,main=title)
qqline(RandomData)

  

