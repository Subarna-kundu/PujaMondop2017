# Haseeb Mahmud
# haseeb.mahmud@gmail.com 

library(ggplot2)
library(scales)
library(RColorBrewer)
library(maptools)
library(rgeos)
library(Cairo)
library(ggmap)

setwd("~/R/PujaMondop")

districts <- readShapeSpatial("bgd_bnd_adm2.shp")
class(districts)
names(districts)
print(districts$District)
print(districts$Division)
print(districts$OBJECTID)

districts.shp.f <- fortify(districts, region = "OBJECTID")
class(districts.shp.f)
head(districts.shp.f)
merge.shp.coef <- merge(districts.shp.f, mydata, by="id", all.x=TRUE)
final.plot <- merge.shp.coef[order(merge.shp.coef$order), ] 

#basic plot
ggplot() + geom_polygon(data = final.plot, aes(x = long, y = lat, group = group, fill = mondop), color = "black", size = 0.25) + coord_map()

#nicer plot
ggplot() + geom_polygon(data = final.plot, aes(x = long, y = lat, group = group, fill = mondop), color = "black", size = 0.1) + 
  coord_map() + scale_fill_distiller(name="Number of Mondops", palette = "Blues", labels = comma, trans = "reverse", breaks = pretty_breaks(n = 5)) + 
  theme_nothing(legend = TRUE) + theme(plot.title = element_text(hjust = 1)) + ggtitle("Number Mondops in Durga Puja 2017")

##################################################################
# Bar plot
mydata1 <- transform(mydata, NAME_1 = reorder(NAME_1, mondop))
c <- ggplot(mydata1, aes(x=NAME_1, y=mondop, fill=mondop)) + 
  geom_bar(stat = "identity") + coord_flip() + scale_y_continuous('') + scale_x_discrete('') +
  scale_fill_distiller(name="Mandops", palette = "RdYlGn", labels = comma, trans = "reverse")
c

d <- ggplot(mydata1, aes(x=NAME_1, y=mondop, fill=mondop)) + 
  geom_bar(stat = "identity", position=position_dodge()) + coord_flip() + scale_y_continuous('') + scale_x_discrete('') +
  geom_text(aes(label=mondop), vjust=.45, color="black", position = position_dodge(3), size=2.5)+
  scale_fill_distiller(name="Mondops", palette = "Set3", labels = comma, trans = "reverse")

d 