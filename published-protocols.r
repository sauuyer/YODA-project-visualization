install.packages("igraph") 
library("igraph")
library("network")
library(tidyr)
library(dplyr)

edges <- read.csv("published-protocols/yoda-pub-protocol-edges.csv")
edges <- select(edges, from, to)
nodes <- read.csv("published-protocols/yoda-pub-protocol-nodes.csv")
nodes <- select(nodes, node_ID, type, id)
nodes <- nodes[-c(18), ]
nodes$type <- as.character(nodes$type)

colrs <- c("#11A960", "#EAB132", "#700BA0","#CD88AF", "#D4554B")

net <- graph_from_data_frame(d = edges, vertices = nodes, directed = F)
net <- simplify(net)
V(net)$color=V(net)$type #assign the "Document" attribute as the vertex color
V(net)$color=gsub("Requested Trial","#11A960",V(net)$color) #Trials will be darker green
V(net)$color=gsub("Mediation analysis", "#EAB132",V(net)$color) #Unrequested Trials will be marigold
V(net)$color=gsub("Metaanalysis", "#700BA0",V(net)$color) #Publications will be purpleish 
V(net)$color=gsub("Reproduction analysis", "#CD88AF",V(net)$color) #Publications will be light fusia
V(net)$color=gsub("Retrospective analysis", "#D4554B",V(net)$color) #Publications will be coral
V(net)$label=NA
V(net)$size=6
E(net)$color="#404040"

##F88279
#EEB368
#ceb <- cluster_edge_betweenness(net)
#plot(ceb, net, vertex.label.dist=1.5, mode="hclust")
plot(net)


legend(x=-1.5, y=-1.1, c("Requested Trial", "Mediation analyis", "Metaanalysis", "Reproduction analysis", "Retrospective analysis"), 
       pch=21, col='#000000', 
       pt.bg = colrs, pt.cex = 2, cex = .8, bty="n", ncol=1)


