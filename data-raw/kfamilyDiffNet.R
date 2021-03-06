rm(list=ls())

library(foreign)

kfamily <- read.dta("data-raw/kfp_v3_labels_fixed.dta")

# Subsetting
netvars <- names(kfamily)[grepl("^net", names(kfamily))]

# Replacing 0s with NAs
for (i in netvars)
  kfamily[[i]] <- ifelse(kfamily[[i]]==0,NA, kfamily[[i]])

# Creating an ID
for (i in c("id",netvars))
  kfamily[[i]] <- kfamily[[i]] + kfamily$village*1000L

surveyed <- kfamily$id

length(table(unlist(kfamily[,netvars])))

# Removing farmes that are not part of the experiment, i.e. weren't
# surveyed.
for (i in netvars)
  kfamily[[i]][which(!(kfamily[[i]] %in% surveyed))] <- NA

length(table(unlist(kfamily[,netvars])))

# [2016-02-24]: keep.isolates working
# # Adding autoedges to farmers that are isolated
# isolated <- which(apply(kfamily[, netvars], 1, function(x) all(is.na(x))))
# kfamily[isolated, netvars[1]] <- kfamily$id[isolated]

length(table(unlist(kfamily[,netvars])))

# Reshaping data
kfamily.long <- reshape(
  kfamily[, c("id",netvars)], v.names= "net",
  varying = netvars,
  timevar = "level", idvar="id", direction="long")

library(netdiffuseR)

# Coercing the edgelist to an adjacency matrix. Here we are assuming that the
# network is constant through time.
graph <- with(
  kfamily.long,
  edgelist_to_adjmat(cbind(id, net), t=11, undirected=FALSE,
                     keep.isolates = TRUE, multiple=TRUE)
)

# [2016-02-24]: keep.isolates working
# # Here we are retrieving the set of individuals who actually were used in the
# # network (as these are not isolated nodes)
# used.vertex <- rownames(graph[[1]])
#
# # Create the vector (subset) of times of adoption using only the individuals
# # that are included in the adjacency matrix
# toa <- kfamily$toa[kfamily$id %in% used.vertex]
toa <- kfamily$toa

# Creating a diffnet -----------------------------------------------------------
kfamilyDiffNet <- as_diffnet(graph, toa, vertex.static.attrs = subset(kfamily, select=c(-id,-toa)),
                             name = "Korean Family Planning",
                             behavior = "Family Planning Methods")
# [2016-02-24]: keep.isolates working
# diffnet.attrs(kfamilyDiffNet, "vertex", "static") <- as.matrix(subset(kfamily, id %in% used.vertex))
# [2016-03-05]: Deprecated
# diffnet.attrs(kfamilyDiffNet, "vertex", "static") <- subset(kfamily, select=c(-id,-toa))

save(kfamilyDiffNet, file="data/kfamilyDiffNet.rdata",
     compress = "xz")
