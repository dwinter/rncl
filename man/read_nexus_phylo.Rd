% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/rncl.R
\name{make_phylo}
\alias{make_phylo}
\alias{read_newick_phylo}
\alias{read_nexus_phylo}
\title{Read phylogenetic trees from files}
\usage{
make_phylo(file, simplify = FALSE, missing_edge_length = NA, ...)

read_nexus_phylo(file, simplify = FALSE, missing_edge_length = NA, ...)

read_newick_phylo(file, simplify = FALSE, missing_edge_length = NA, ...)
}
\arguments{
\item{file}{Path of NEXUS or Newick file}

\item{simplify}{If the file includes more than one tree, returns
only the first tree; otherwise, returns a multiPhylo object}

\item{missing_edge_length}{If the tree contains missing edge
lengths, the value to be attributed to these edge lengths. By
default, (\code{missing_edge_length = NA}) if at least edge
length is missing, they are all removed. Otherwise, the value
must be a single numeric value. In any case, a warning will
be generated if the tree contains missing edge lengths.}

\item{...}{additional parameters to be passed to the rncl function}
}
\value{
A phylo or a multiPhylo object
}
\description{
Create phylo objects from NEXUS or Newick files
}
\details{
These functions read NEXUS or Newick files and return an object of
class phylo/multiPhylo.
}
\note{
\code{make_phylo} may become deprecated in the future, use
    \code{read_nexus_phylo} or \code{read_newick_phylo} instead.
}
\author{
Francois Michonneau
}
\seealso{
rncl-package
}

