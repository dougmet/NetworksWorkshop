
# Matrix Representation ---------------------------------------------------

A <- rbind(c(0,1,0), c(1,0,1), c(1,0,0))
nodeNames <- c("A","B","C")
dimnames(A) <- list(nodeNames, nodeNames)
A

A %*% A %*% A %*% A

library(igraph)

# A simple network in igraph
g <- graph_from_literal(A++B, B-+C, C-+A)
g
class(g)
# Default plot method
plot(g)

# Turn the matrix into an igraph object
g <- graph_from_adjacency_matrix(A)

# Convert back
as_adjacency_matrix(g, sparse=FALSE)
as_edgelist(g)

# Standard Structures -----------------------------------------------------

g <- make_tree(10, children = 2, mode="in")
plot(g)

g <- make_full_graph(10, directed=FALSE)
plot(g)

# Surface of a sphere
g <- make_lattice(dimvector = c(25,25),
                  circular = TRUE)


# Exercise - Standard Structures

g <- make_star(n=5, mode="undirected")
plot(g)
as_adjacency_matrix(g, sparse=FALSE)

# The data can be found here
https://github.com/dougmet/NetworksWorkshop/tree/master/data.

dolphinEdges <- read.csv("data/dolphin_edges.csv")
View(dolphinEdges)

dolphin <- graph_from_data_frame(dolphinEdges,
                          directed = FALSE)

plot(dolphin)

# This adds vertex attributes
dolphinVertices <- read.csv("data/dolphin_vertices.csv")
View(dolphinVertices)

dolphin <- graph_from_data_frame(dolphinEdges,
                vertices = dolphinVertices,
                directed = FALSE)

# Convert back to data frames
dolphinDFs <- as_data_frame(dolphin, what="both")
class(dolphinDFs)
head(dolphinDFs$vertices)
head(dolphinDFs$edges)

# Lots of export options
?write_graph()


# Network Manipulation ----------------------------------------------------


library(igraphdata)
# igraph data needs to be explicitly loaded into the namespace
data(package="igraphdata")
data(USairports)
USairports

View(as_data_frame(USairports, what="edges"))

vertex_attr_names(USairports)
vertex_attr(USairports, "City")


# Sequences ---------------------------------------------------------------

V(USairports)

V(USairports)$City

V(USairports)[1:5]$City
V(USairports)$City[1:5]

V(USairports)["JFK"]
V(USairports)[["JFK"]]

V(USairports)$Group <- sample(c("A","B"),
                        vcount(USairports),
                        replace=TRUE)

V(USairports)["JFK"]$Group <- "B"


# Edge Selectors ---------------------------------------------------------

E(USairports)["JFK" %--% "BOS"]

E(USairports)["JFK" %->% "BOS"]

x <- E(USairports)["JFK" %--% "BOS"]$Carrier

unique(x)

# Grep the state code from the city
inCal <- grepl("CA$", V(USairports)$City)
inNy <- grepl("NY$", V(USairports)$City)


ca <- V(USairports)[inCal]
ny <- V(USairports)[inNy]

E(USairports)[ca %--% ny]

calAirports <- induced_subgraph(USairports, 
                                inCal)
aAirports <- induced_subgraph(USairports,
                V(USairports)$Group=="A")


# Adding and deleting -----------------------------------------------------

g <- make_empty_graph(n=0, directed=FALSE)

g <- g + vertex(c("A","B","C"))
g

g <- g + edges(c("A","B",   "C","B"))

# Deleting

g <- g - E(g)["A" %--% "B"]


# Visualisation -----------------------------------------------------------

?plot.igraph
?"igraph.plotting"

g <- make_ring(10, directed=FALSE,
               mutual=TRUE)
V(g)$name <- LETTERS[1:10]
plot(g)

g <- g + edges(c(9,5, 7,1, 1,5))

lo <- layout_in_circle(g)
lo

plot(g, layout=lo)
# Equivalent
plot(g, layout=layout_in_circle)

plot(g, layout=layout_as_tree(g, root=1))

# Force based

set.seed(1)
plot(dolphin, layout=layout_with_drl(dolphin))

plot(dolphin, layout=layout_with_drl(dolphin),
     vertex.label=NA)

# Vertex properties
vowel <- V(g)$name %in% c("A","E","I","O","U") + 1 # gives 1 or 2

plot(g, 
     vertex.shape=c("circle", "square")[vowel],
     layout=lo)


plot(g, 
     vertex.shape=c("circle", "square")[vowel],
     vertex.color=c("red", "blue")[vowel],
     layout=lo)

# Easier to set attributes before plotting

V(g)$color <- "red"
g
plot(g, layout=lo)

V(g)[V(g)$name %in% c("A","E","I","O","U")]$color <- "blue"

# Or more succinctly
V(g)[name %in% c("A","E","I","O","U")]$color <- "blue"

# This function finds return, or mutual edges
which_mutual(g)

# Curve all the edges
plot(g, edge.curved=0.1)

# Components

# For graphs that are not fully connected look at
components(g)

# Degree

degDol <- degree(dolphin)
degDol

hist(degDol)

# Clustering

transitivity(dolphin, type = "global")
transitivity(dolphin, type = "local")

# Diameter (path lengths)

diameter(dolphin)
vcount(dolphin)

# Shortest paths

sp <- shortest_paths(dolphin, from="Beak", to="Whitetip")

sp$vpath

# Betweenness

g <- make_full_graph(4) + vertex(1) + make_full_graph(4)
g <- g + edges(c(4,5,5,6))
V(g)$name <- LETTERS[1:9]
plot(g)

betweenness(g)
betweenness(g, normalized = TRUE)

# Eigenvector Centrality

ec <- eigen_centrality(g)
ec$vector

cliques(g, 4)

# PageRank

pr <- page_rank(g)
pr$vector

