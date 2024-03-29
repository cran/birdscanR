% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createTimeBins.R
\name{createTimeBins}
\alias{createTimeBins}
\title{createTimeBins}
\usage{
createTimeBins(
  timeRange,
  timeBinDuration_sec,
  timeZone,
  sunriseSunset,
  dnBins = TRUE,
  crepBins = FALSE,
  sunOrCivil = "civil",
  crepuscule = "nauticalSolar"
)
}
\arguments{
\item{timeRange}{vector of length 2, with start and end of time range as
POSIXct}

\item{timeBinDuration_sec}{duration of timeBins in seconds (numeric). for
values <= 0 a duration of 1 hour will be set}

\item{timeZone}{time zone in which the time bins should be created as string,
e.g. "Etc/GMT0"}

\item{sunriseSunset}{dataframe with sunrise/sunset, civil dawn/dusk. computed
with function 'twilight'}

\item{dnBins}{Logical. Default TRUE. Determines whether timebins based on
day/night values (determined by the parameter 'sunOrCivil') are created.}

\item{crepBins}{Logical. Default FALSE. Determines whether timebins with
crepuscular time phases are created (determined by the parameter 'crepuscule').}

\item{sunOrCivil}{sunrise/sunset or civil dawn/dusk used to split day and
night. Supported values: "sun" or "civil", default: "civil"}

\item{crepuscule}{Used to split into crepusculeMorning, day, crepusculeEvening,
and night. Set to “nauticalSolar” to use the time between nautical dusk/dawn
and sunrise/sunset times to define the crepuscular period, or to
"nauticalCivil" to use the time between nautical and civil dusk/dawn to define
the crepuscular period, or to "civilSolar" to use the time between civil
dusk/dawn and sunrise/sunset times to define the crepuscular period. Default
is "nauticalSolar".}
}
\value{
returns a dataframe with the time bins information
}
\description{
Create time bins with a given duration. Time bins expanding over
a day/night change will be split in two time bins.
}
\author{
Fabian Hertner, \email{fabian.hertner@swiss-birdradar.com};
Birgen Haest, \email{birgen.haest@vogelwarte.ch}
}
