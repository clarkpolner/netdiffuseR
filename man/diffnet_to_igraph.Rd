% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/igraph.R
\name{diffnet_to_igraph}
\alias{diffnet_to_igraph}
\alias{igraph_to_diffnet}
\title{Convertion between graph classes}
\usage{
diffnet_to_igraph(graph, slices = 1:nslices(graph))

igraph_to_diffnet(graph, toavar, t0 = NULL, t1 = NULL)
}
\arguments{
\item{graph}{A diffnet class object.}

\item{slices}{An integer vector indicating the slices to subset.}

\item{toavar}{Character scalar. Name of the attribute that holds the times of adoption.}

\item{t0}{Integer scalar. Passed to \code{\link{as_diffnet}}.}

\item{t1}{Integer scalar. Passed to \code{\link{as_diffnet}}.}
}
\value{
A list of \code{length(slices)} \code{\link[igraph:igraph]{igraph}}
objects.
}
\description{
Convertion between graph classes
}
\examples{
# Reading the meddical innovation data into igraph --------------------------
x <- diffnet_to_igraph(medInnovationsDiffNet)

# Fetching the times of adoption
igraph::vertex_attr(x[[1]], "toa")

}
