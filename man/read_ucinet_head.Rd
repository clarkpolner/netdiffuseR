% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_write_foreign.R
\name{read_ucinet_head}
\alias{UCINET}
\alias{read_ucinet}
\alias{read_ucinet_head}
\alias{ucinet}
\title{Reads UCINET files}
\usage{
read_ucinet_head(f)

read_ucinet(f, echo = FALSE)
}
\arguments{
\item{f}{Character scalar. Name of the header file. e.g. \code{mydata.##h}.}

\item{echo}{Logical scalar. When \code{TRUE} shows a message.}
}
\value{
An array including dimnames (if there are) and the following attributes:
\item{headerversion}{Character scalar}
\item{year}{Integer. Year the file was created}
\item{month}{Integer. Month of the year the file was created.}
\item{day}{Integer. Day of the month the file was created.}
\item{dow}{Integer. Day of the week the file was created.}
\item{labtype}{}
\item{infile.dt}{Character scalar. Type of data of the array.}
\item{dim}{Integer vector. Dimmensions of the array.}
\item{tit}{Character scalar. Title of the file.}
\item{haslab}{Logical vector. Whether  each dim has a label.}
}
\description{
Reads UCINET files

Read UCINET files (binary)
}
\seealso{
Other graph formats: \code{\link{diffnet_to_igraph}},
  \code{\link{netdiffuseR-graphs}},
  \code{\link{read_pajek}}
}

