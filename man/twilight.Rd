% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/twilight.R
\name{twilight}
\alias{twilight}
\title{Calculate the twilight hours for given locations}
\usage{
twilight(timeRange, latLon, crs_datum = "WGS84", timeZone)
}
\arguments{
\item{timeRange}{The range of dates in which to calculate the twilight}

\item{latLon}{A list of X, Y coordinates}

\item{crs_datum}{The coordinate reference system and datum of the X, Y
coordinates}

\item{timeZone}{The time zone of the area of interest}
}
\value{
A data frame with the results
}
\description{
Calculate the  duration of night in hours and seconds. It
calculate also the time of both solar and civil start of the day and end of
the day.
}
\examples{
\dontrun{
sunrisesunset = twilight(timeRange = c("2021-01-15 00:00", 
                                       "2021-01-31 00:00"),
                         latLon    = c(47.494427, 8.716432),
                         timeZone  = "Etc/GMT0")
}
}
\author{
Fabian Hertner, \email{fabian.hertner@swiss-birdradar.com};
Birgen Haest, \email{birgen.haest@vogelwarte.ch}
}
