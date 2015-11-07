#' Calculates degree of each node
#' @param adjmat Square matrix. Adjacency matrix
#' @param cmode Integer. 0 for indegree, 1 for outdegree and 2 for degree.
#' @param undirected Logical. TRUE when the graph is undirected.
#' @param self Logical. TRUE when self edges should not be considered.
#' @return A numeric vector with the degree of each node.
#' @export
#' @examples
#' # Creating a directed graph
#' graph <- rand_graph(undirected=FALSE)
#' graph
#'
#' # Comparing degree measurements
#'  data.frame(
#'    In=degree(graph, 0, undirected = FALSE),
#'    Out=degree(graph, 1, undirected = FALSE),
#'    Degree=degree(graph, 2, undirected = FALSE)
#'  )
degree <- function(adjmat, cmode=2, undirected=TRUE, self=FALSE) {
  # Performing checks
  if (!inherits(adjmat, 'matrix')) stop('-adjmat- should be a matrix.')
  if (!(cmode %in% 0:2)) stop('Invalid -cmode- ',cmode,'. Should be either ',
                              '0 (indegree), 1 (outdegree) or 2 (degree).')

  # Computing degree
  degree_cpp(adjmat, cmode, undirected, self)
}

#' Ego exposure
#' @param graph An array of adjacency matrices
#' @param cumadopt nxT matrix. Cumulative adoption matrix obtained from
#' \code{\link{toa_mat}}
#' @param wtype Integer. Weighting type (see details).
#' @param v Double. Constant for Structural Equivalence.
#' @param undirected Logical. TRUE if the graph is undirected.
#' @details
#'
#' When \code{wtype=0} (default), exposure is defined as follows
#'
#' \deqn{E_{n(t)}=\frac{S_{nn}\times A_{n(t)}}{S_{n+}}}{%
#'       E(n,t)  =[     S(n,n) x     A(n,t)] / S(n+)}
#'
#' where \eqn{E_{n(t)}}{E(n,t)} is the exposure of the network at time t,
#' \eqn{S_{nn}}{S(n,n)} is the social network, \eqn{A_{n(t)}}{A(n,t)} is the
#' cumulative adoption matrix at time t, and \eqn{S_{n+}}{S(n+)} is the row-wide
#' sum of the graph.
#'
#' If \code{wtype=1} (Structural Equivalence), exposure is now computed as:
#'
#' \deqn{E_{n(t)}=\frac{SE_{nn}^{-1}\times A_{n(t)}}{SE_{n+}^{-1}}}{%
#'       E(n,t)  =[     SE(n,n)^[-1] x     A(n,t)] / SE(n+)^[-1]}
#'
#' where SE stands for Structural Equivalence (see \code{\link{struct_equiv}}).
#' Otherwise, for any value above of \code{wtype}--2, 3 or 4, which stands for
#' indegree, outdegree and degree respectively-- is calculated accordingly to
#'
#' \deqn{E_{n(t)}=\frac{S_{nn}\times (A_{n(t)} / D_n)}{S_{n+}}}{%
#'       E(n,t)  =[     S(n,n) x     [A(n,t)/D(n)] / S(n+)}
#'
#' where \eqn{D_n}{D(n)} is a column vector of size n containing the degree of
#' each node.
#' @references
#' Burt, R. S. (1987). "Social Contagion and Innovation: Cohesion versus Structural
#' Equivalence". American Journal of Sociology, 92(6), 1287.
#' \url{http://doi.org/10.1086/228667}
#'
#' Valente, T. W. (1995). "Network models of the diffusion of innovations"
#'  (2nd ed.). Cresskill N.J.: Hampton Press.
#'
#' @backref src/stats.cpp
#' @return A matrix of size nxT with exposure for each node.
#' @export
exposure <- function(graph, cumadopt, wtype = 0, v = 1.0, undirected=TRUE)
  UseMethod('exposure')

#' @describeIn exposure Method for arrays
#' @export
exposure.array <- function(graph, cumadopt, wtype = 0, v = 1.0, undirected=TRUE) {
  exposure_cpp(graph, cumadopt, wtype, v, undirected)
}

#' Cummulative count of adopters
#'
#' Calculates the number of adopters in each period, the proportion of adopters, and
#' the adoption rate.
#'
#' @param cumadopt nxT matrix. Cumulative adoption matrix obtained from
#' \code{\link{toa_mat}}
#' @details The rate of adoption (3rd row), is calculated as
#' \deqn{\frac{q_t - q_{t-1}}{q_{t-1}}}{[q(t) - q(t-1)]/q(t-1)}
#' where \eqn{q_i}{q(i)} is the number of adopters in time i.
#' @return A 3xT matrix, where its rows contain the number of adoptes, the proportion of
#' adopters and the rate of adoption respectively for earch period of time.
#' @export
cumulative_adopt_count <- function(cumadopt) {
  x <- cumulative_adopt_count_cpp(cumadopt)
  row.names(x) <- c("num", "prop", "rate")
  return(x)
}

#' Calculates hazard rate
#' @param cumadopt nxT matrix. Cumulative adoption matrix obtained from
#' \code{\link{toa_mat}}
#' @details Hazard rate is calculated as
#' \deqn{\fraq{q_t - q_{t-1}}{n - q_{t-1}}}{[q(t) - q(t-1)]/[n - q(t-1)]}
#' where \eqn{q_i}{q(i)} is the number of adopters in time i, and \eqn{n}{n} is the number of individuals
#' in the system.
#' @return A row vector of size T with hazard rates for t>1.
#' @export
hazard_rate <- function(cumadopt) {
  x <- hazard_rate_cpp(cumadopt)
  row.names(x) <- "hazard"
  x
}

#' Calculates threshold
#'
#' Threshold as the exposure of vertex by the time of the adoption.
#'
#' @param exposure nxT matrix. Exposure to the innovation obtained from
#' \code{\link{exposure}}.
#' @param times Integer vector. Indicating the time of adoption of the innovation.
#' @param times.recode Logical. TRUE when time recoding must be done.
#' @return A vector of size \eqn{n}{n} indicating the threshold for each node.
#' @export
threshold <- function(exposure, times, times.recode=TRUE) {
  if (times.recode) times <- times - min(times) + 1L
  threshold_cpp(exposure, times)
}
