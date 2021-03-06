% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/main.R
\name{ctrRerunQuery}
\alias{ctrRerunQuery}
\title{ctrRerunQuery}
\usage{
ctrRerunQuery(
  querytoupdate = querytoupdate,
  forcetoupdate = forcetoupdate,
  con = con,
  verbose = verbose,
  queryupdateterm = queryupdateterm
)
}
\arguments{
\item{querytoupdate}{Either the word "last" or the number of the
query (based on \link{dbQueryHistory}) that should be run to
retrieve any trial records that are new or have been updated
since this query was run the last time.
This parameter takes precedence over \code{queryterm}.
For EUCTR, updates are available only for the last seven days;
the query is run again if more time has passed since it was
run last.}

\item{forcetoupdate}{If \code{TRUE}, run again the query
given in \code{querytoupdate}, irrespective of when it was
run last (default is \code{FALSE}).}

\item{con}{A \link[nodbi]{src} connection object, as obtained with
nodbi::\link[nodbi]{src_mongo}() or nodbi::\link[nodbi]{src_sqlite}()}

\item{verbose}{Printing additional information if set to
\code{TRUE}; default is \code{FALSE}.}
}
\description{
ctrRerunQuery
}
\keyword{internal}
