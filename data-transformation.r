library(dplyr)
library(readxl)


file <- read.csv("published-protocols/published-protocols.csv")
raw_all_trials <- read_excel('raw_data/trials-approved-protocol-from-yoda.xlsx', sheet = 'Trial List 4.5.2019')

df <- select(file, Protocol.Title, Research.Outcome, Requested.Trial.s.)

# replace optics trial bundle with actual trial NCT numbers

#optics_bundle <- "'NCT00299715' 'NCT00309699' 'NCT00309686' 'NCT00397033' 'NCT00412373' 'NCT00086320' 
#'NCT00085748' 'NCT00650793' 'NCT00077714' 'NCT00083668' 'NCT00334126' 'NCT00111189' 'NCT00210717' 'NCT00147173' 
#'NCT00210548' 'NCT00590577' 'NCT00590577' 'NCT00074477' 'NCT00752427'"
optics_bundle <- "NCT00299715\nNCT00309699\nNCT00309686\nNCT00397033\nNCT00412373\nNCT00086320\nNCT00085748\nNCT00650793\nNCT00077714\nNCT00083668\nNCT00334126\nNCT00111189\nNCT00210717\nNCT00147173\nNCT00210548\nNCT00590577\nNCT00590577\nNCT00074477\nNCT00752427'"

df$Requested.Trial.s. <- gsub('Multiple NCT#s - OPTICS Trial Bundle', optics_bundle, df$Requested.Trial.s.)
names(df)

############create edge file

edges <- select(df, Protocol.Title, Requested.Trial.s.)
names(edges)

s_e <- strsplit(as.character(edges$Requested.Trial.s.), split = "\n")
s_e
new_edges <- data.frame(Protocol.Title = rep(edges$Protocol.Title, sapply(s_e, length)), edges = unlist(s_e))
names(new_edges) <- c("Protocol.Title", "Trial.Number")
new_edges$edge_ID <- seq.int(nrow(new_edges))

#############create node file
raw_nodes <- df
names(raw_nodes)
raw_nodes$Trial.Status <- "Requested Trial"
protocol_nodes <- select(raw_nodes, Protocol.Title, Research.Outcome)
names(protocol_nodes) <- c("id", "type")


s_tn <- strsplit(as.character(raw_nodes$Requested.Trial.s.), split = "\n")

trial_nodes <- data.frame(Trial.Status = rep(raw_nodes$Trial.Status, sapply(s_tn, length)), raw_nodes = unlist(s_tn))
trial_nodes <- trial_nodes[,c(2,1)]
names(trial_nodes) <- c("id", "type")

nodes <- rbind(protocol_nodes, trial_nodes)


names(df)

#get all trials
#names(raw_all_trials)
#all_trials <- select(raw_all_trials, "NCT Number", "Sponsor Protocol Number")
#names(all_trials) <- c('NCT.Number', 'Sponsor.Protocol.Number')
#all_trials$value_name <- all_trials$NCT.Number
#all_trials$value_name[all_trials$value_name == "N/A"] <- all_trials$Sponsor.Protocol.Number[all_trials$value_name == "N/A"]
#all_trials[!is.na(all_trials$value_name),]
#all_trials$value_type <- "Unrequested Trial"
#all_trials_cleanlist <- select(all_trials, value_name, value_type)
#all_trials_cleanlist
#names(all_trials_cleanlist) <- c("id", "type")

#all_nodes <- rbind(nodes, all_trials_cleanlist)
#names(all_nodes)
# deduplicate the trials in the nodes table (actually all of the values)
nodes <- nodes[!duplicated(nodes$id),]

#add an id column to the dedupled nodes df
nodes$node_ID <- seq.int(nrow(nodes))
nodes <- nodes[c(3,2,1)]

##############numerize edge file


num_edges_pro <- new_edges %>%
  left_join(nodes, by = c("Protocol.Title" = "id")) 
num_edges_pro <- select(num_edges_pro, Protocol.Title, node_ID, edge_ID)


num_edges_tri <- new_edges %>%
  left_join(nodes, by = c("Trial.Number" = "id"))
num_edges_tri <- select(num_edges_tri, Trial.Number, node_ID, edge_ID)


num_edges <- merge(num_edges_pro, num_edges_tri, by = "edge_ID")
num_edges <- select(num_edges, node_ID.x, node_ID.y)
colnames(num_edges) <- c("from", "to")

final_edges <- num_edges
final_nodes <- nodes

write.csv(final_edges, "published-protocols/yoda-pub-protocol-edges.csv")
write.csv(final_nodes, "published-protocols/yoda-pub-protocol-nodes.csv")
