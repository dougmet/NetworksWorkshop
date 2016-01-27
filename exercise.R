# Exercise - Standard Structures -----------------------------------------------

g <- make_star(n=5, mode="undirected")
as_adjacency_matrix(g, sparse = FALSE)

# Exercise - Importing from csv ------------------------------------------------

dolphinEdges <- read.csv("data/dolphin_edges.csv")
dolphinVertices <- read.csv("data/dolphin_vertices.csv")

# Must tell igraph if it's directed or not
dolphin <- graph_from_data_frame(dolphinEdges, vertices = dolphinVertices,
                                 directed = FALSE)

 
# Exercise - Attributes --------------------------------------------------------
# 
# Using the igraph object created in the previous exercise, count the number of 
# male and female dolphins in the pod. Add a weight=1 attribute to every edge 
# in the dolphin network. Verify that the igraph object is now a weighted network.

table(V(dolphin)$Gender)

E(dolphin)$weight <- 1
dolphin

# Exercise - Subgraphs ---------------------------------------------------------
library(igraphdata)
data("USairports")
# Find the edges in the USairports network that have a Distance>1500.

E(USairports)[Distance > 1500]

# Use the edge indices to create the long haul (> 1500 miles) flights network.

longhaul <- subgraph.edges(USairports, E(USairports)[Distance > 1500])

# How many airports can you get to from Oakland (OAK) with a single stop?

oak <- make_ego_graph(USairports, nodes="OAK", order=2)[[1]]

# Number of airports within distance 2
vcount(oak) - 1
# 395
 
# Exercise - Structural Measures -----------------------------------------------
# 
# For the dolphin network
# 
# Find the vertex with the highest degree, k.

V(dolphin)[which.max(degree(dolphin))]

# Find the vertex with the highest local clustering coefficient.

V(dolphin)[which.max(transitivity(dolphin, "local"))]

# Plot a histogram of the shortest path lengths between all vertices.
hist(distances(dolphin), freq=FALSE, col="orange")
