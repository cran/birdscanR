% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/computeMTR.R
\name{computeMTR}
\alias{computeMTR}
\title{computeMTR}
\usage{
computeMTR(
  dbName,
  echoes,
  classSelection,
  altitudeRange,
  altitudeBinSize,
  timeRange,
  timeBinDuration_sec,
  timeZone,
  sunriseSunset,
  sunOrCivil = "civil",
  crepuscule = "nauticalSolar",
  protocolData,
  visibilityData,
  manualBlindTimes = NULL,
  saveBlindTimes = FALSE,
  blindTimesOutputDir = getwd(),
  blindTimeAsMtrZero = NULL,
  propObsTimeCutoff = 0,
  computePerDayNight = FALSE,
  computePerDayCrepusculeNight = FALSE,
  computeAltitudeDistribution = TRUE
)
}
\arguments{
\item{dbName}{Character string, containing the name of the database you are
processing}

\item{echoes}{dataframe with the echo data from the data list created by the
function ‘extractDBData’ or a subset of it created by the function
‘filterEchoData’.}

\item{classSelection}{character string vector with all classes which should
be used to calculate the MTR. The MTR and number of Echoes will be calculated
for each class as well as for all classes together.}

\item{altitudeRange}{numeric vector of length 2 with the start and end of the
altitude range in meter a.g.l.}

\item{altitudeBinSize}{numeric, size of the altitude bins in meter.}

\item{timeRange}{Character vector of length 2, with start and end of time
range, formatted as "\%Y-\%m-\%d \%H:\%M"}

\item{timeBinDuration_sec}{duration of timeBins in seconds (numeric). for
values <= 0 a duration of 1 hour will be set}

\item{timeZone}{time zone in which the time bins should be created as string,
e.g. "Etc/GMT0"}

\item{sunriseSunset}{dataframe with sunrise/sunset, and civil and nautical
dawn/dusk. Computed with the function 'twilight'.}

\item{sunOrCivil}{sunrise/sunset or civil dawn/dusk used to split day and
night. Supported values: "sun" or "civil". Default: "civil"}

\item{crepuscule}{optional character variable, Set to “nauticalSolar” to use
the time between nautical dusk/dawn and sunrise/sunset times to define the
crepuscular period, or to "nauticalCivil" to use the time between nautical
and civil dusk/dawn to define the crepuscular period, or to "civilSolar" to use
the time between civil dusk/dawn and sunrise/sunset times to define the
crepuscular period. Default is "nauticalSolar".}

\item{protocolData}{dataframe with the protocol data from the data list
created by the function \code{extractDBData} or a subset of it created by the
function \code{filterProtocolData}.}

\item{visibilityData}{dataframe with the visibility data from the data list
created by the function ‘extractDBData’.}

\item{manualBlindTimes}{dataframe with the manual blind times created by the
function \code{loadManualBlindTimes}.}

\item{saveBlindTimes}{Logical, determines whether to save the blind times to
a file. Default: False.}

\item{blindTimesOutputDir}{Character string containing the path to save the
blind times to. Default: 'your-working-directory'}

\item{blindTimeAsMtrZero}{character string vector with the blind time types
which should be treated as observation time with MTR zero.}

\item{propObsTimeCutoff}{numeric between 0 and 1. If the MTR is computed per
day and night, time bins with a proportional observation time smaller than
propObsTimeCutoff are ignored when combining the time bins. If the MTR is
computed for each time bin, the parameter is ignored.}

\item{computePerDayNight}{logical, TRUE: MTR is computed per day and night.
The time bins of each day and night will be combined and the mean MTR is
computed for each day and night. The spread (first and third Quartile) for
each day and night are also computed. The spread is dependent on the chosen
time bin duration/amount of time bins; When FALSE: MTR is computed for each
time bin. This option computes the MTR for each time bin defined in the time
bin dataframe. The time bins that were split due to sunrise/sunset during the
time bin will be combined to one bin.}

\item{computePerDayCrepusculeNight}{logical, TRUE: MTR is computed per
crepusculeMorning, day, crepusculeEvening, and night. The time bins of each
of these diel phases will be combined and the mean MTR is computed for each
phase. The spread (first and third Quartile) for each phase is also computed.
The spread is dependent on the chosen time bin duration/amount of time bins;
When FALSE: MTR is computed for each time bin. This option computes the MTR
for each time bin defined in the time bin dataframe. The time bins that were
split due to sunrise/sunset during the time bin will be combined to one bin.
Default = FALSE.}

\item{computeAltitudeDistribution}{logical, TRUE: compute the mean height and
altitude distribution of MTR for the pre-defined quantiles 0.05, 0.25, 0.5,
0.75, 0.95}
}
\value{
Migration Traffic Rates
}
\description{
This function will estimate the Activity / Migration Traffic
Rates (MTR, expressed as #objects / km / hour) based on the observations in
your database.
}
\examples{
\dontrun{
# Set server, database, and other input settings
# ===========================================================================
  dbServer       = "MACHINE\\\\SERVERNAME"     # Set the name of your SQL server
  dbName         = "db_Name"                   # Set the name of your database
  dbDriverChar   = "SQL Server"                # Set either "SQL Server" or "PostgreSQL"
  mainOutputDir  = file.path(".", "results")
  radarTimeZone  = "Etc/GMT0"
  targetTimeZone = "Etc/GMT0"
  listOfRfFeaturesToExtract = c(167, 168)
  siteLocation   = c(47.494427, 8.716432)
  sunOrCivil     = "civil"
  crepuscule     = "nauticalSolar"
  timeRangeData  = c("2021-01-15 00:00", "2021-01-31 00:00")
 
# Get data
# ===========================================================================
  dbData = extractDbData(dbDriverChar                   = dbDriverChar,
                         dbServer                       = dbServer, 
                         dbName                         = dbName, 
                         saveDbToFile                   = TRUE,
                         dbDataDir                      = mainOutputDir,
                         radarTimeZone                  = radarTimeZone,
                         targetTimeZone                 = targetTimeZone,
                         listOfRfFeaturesToExtract      = listOfRfFeaturesToExtract,
                         siteLocation                   = siteLocation, 
                         sunOrCivil                     = sunOrCivil, 
                         crepuscule                     = crepuscule)
                         
# Get sunrise/sunset 
# ===========================================================================
  sunriseSunset = twilight(timeRange = timeRangeData,
                           latLon    = c(47.494427, 8.716432),
                           timeZone  = targetTimeZone)
                          
# Get manual blind times
# ===========================================================================
  data(manualBlindTimes)
  cManualBlindTimes = manualBlindTimes

# Compute migration traffic rate
# ===========================================================================
  classSelection.mtr = c("insect")
  mtrData = computeMTR(dbName                       = dbName, 
                       echoes                       = dbData$echoData, 
                       classSelection               = classSelection.mtr, 
                       altitudeRange                = c(25, 1025),
                       altitudeBinSize              = 50,
                       timeRange                    = timeRangeData, 
                       timeBinDuration_sec          = 1800,
                       timeZone                     = targetTimeZone,
                       sunriseSunset                = sunriseSunset,
                       sunOrCivil                   = "civil",
                       crepuscule                   = crepuscule,
                       protocolData                 = dbData$protocolData, 
                       visibilityData               = dbData$visibilityData,
                       manualBlindTimes             = cManualBlindTimes,
                       saveBlindTimes               = FALSE,
                       blindTimesOutputDir          = getwd(),
                       blindTimeAsMtrZero           = NULL,
                       propObsTimeCutoff            = 0, 
                       computePerDayNight           = FALSE,
                       computePerDayCrepusculeNight = FALSE 
                       computeAltitudeDistribution  = TRUE)   
}

}
\author{
Fabian Hertner, \email{fabian.hertner@swiss-birdradar.com};
Baptiste Schmid, \email{baptiste.schmid@vogelwarte.ch};
Birgen Haest, \email{birgen.haest@vogelwarte.ch}
}
