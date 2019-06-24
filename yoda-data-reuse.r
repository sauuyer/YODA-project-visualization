install.packages("igraph") 
library("igraph")
library("network")
library(dplyr)

nodes <- read.csv("network-data/yoda-nodes.csv", header=T, as.is=T)
nodes <- select(nodes, node_ID, value_name, value_type)
nodes$value_type <- as.character(nodes$value_type)
nodes$value_type[nodes$value_type == "Data Access"] <- "Active Protocol"
nodes$value_type[nodes$value_type == "Approved - no data access yet"] <- "Active Protocol"
nodes$value_type[nodes$value_type == "Approved - closed, no plans to publish"] <- "Active Protocol"

edges <- read.csv("network-data/yoda-edges.csv", header=T, as.is=T)
edges <- select(edges, from, to)

colrs <- c("#3E5BAB", "#006B38", "#57C490","#FFFF71" )

net <- graph_from_data_frame(d = edges, vertices = nodes, directed = F)
net <- simplify(net)
V(net)$color=V(net)$value_type #assign the "Document" attribute as the vertex color
V(net)$color=gsub("Active Protocol","#3E5BAB",V(net)$color) #Protocols not resulting in publication will be blue
V(net)$color=gsub("Requested Trial","#006B38",V(net)$color) #Trials will be darker green
V(net)$color=gsub("Unrequested Trial", "#57C490",V(net)$color) #Unrequested Trials will be lighter green
V(net)$color=gsub("Published", "#FFFF71",V(net)$color) #Publications will be yellow 
V(net)$label=NA
V(net)$size=5
E(net)$color="#404040"



plot(net, rescale = F, ylim=c(10,35), xlim=c(-10,30), asp = 1, vertex.size=60)



legend(x=-1.5, y=20, c("Protocol not resulting in publication","Clinical trial dataset requested by at least one research protocol","Clinical trial dataset unrequested by a research protocol","Protocol resulting in publication"), 
       pch=21, col='#000000', 
      pt.bg = colrs, pt.cex = 2, cex = .8, bty="n", ncol=1)

legend(x=-15, y=40, c("Protocol not resulting in publication","Clinical trial dataset requested by at least one research protocol","Clinical trial dataset unrequested by a research protocol","Protocol resulting in publication"), 
       pch=21, col='#000000', 
       pt.bg = colrs, pt.cex = 2, cex = .8, bty="n", ncol=1)

