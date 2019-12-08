# Notes from 2019-12-06



library(dplyr)
library(akima)
library(plotly)

data<-read.csv("Chuck.txt")
names(data)<-c("location","xpos","ypos","ain")
data$ain<-data$ain*-1

x<-data$xpos
y<-data$ypos
z<-data$ain

#yop and xop determine resolution of surface plot
# these are use as interp parameters
yop<-as.matrix(seq(-11800, 11800, 100))
xop<-as.matrix(seq(-12000, 12000, 100))

data<-data.frame(x,y,z)
chuckToPlot <- with(data,interp(x,y,z, yo=yop, xo=xop))
p<-plot_ly(z=chuckToPlot$z, type="surface")

# The following old comapany doesn't work 
#htmlwidgets::saveWidget(as.widget(p), "test.html")

htmlwidgets::saveWidget(p, "chuck.html")

## Reference Notes:
        #Warning message:
        #  ‘as.widget’ is deprecated.
        #Use ‘plot_ly’ instead.
        #See help(“Deprecated”)
        
        #For anyone using the above line of code to save output as html widget. Change the code to…
        
        #htmlwidgets::saveWidget(p, "test.html")
#####


#Getting and scaling the data
circuit_data<-read.csv("CircuitUniDirectionFlat.txt", header=FALSE)
xseq<-seq(1,length(circuit_data[,1]),by=3)
yseq<-seq(2,length(circuit_data[,1]),by=3)
ainseq<-seq(3,length(circuit_data[,1]),by=3)
x<-circuit_data[xseq,][1:129999]
x<-x/50
y<-circuit_data[yseq,][1:129999]
y<-y/50
z<-circuit_data[ainseq,][1:129999]
z<-z/1
z<-z*-1
circuit_data<-data.frame(x,y,z)[1:127926,]
data<-circuit_data

#yop and xop determine resolution of surface plot
# these are use as interp parameters
xop<-as.matrix(seq(min(x), max(x), 200)) #100 here, worked well
yop<-as.matrix(seq(min(y), max(y),200))

data<-data.frame(x,y,z)
circuitToPlot <- with(data,interp(x,y,z, yo=yop, xo=xop, duplicate="mean"))

p<-plot_ly(z=circuitToPlot$z, type="surface")%>% 
  layout(
    scene = list(
      zaxis = list(range = c(-50000,-20000)),
      aspectratio = list(x = 1, y = .3, z = .1)
    )
  )

htmlwidgets::saveWidget(p, "board.html")