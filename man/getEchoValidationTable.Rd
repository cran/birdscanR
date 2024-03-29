% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getEchoValidationTable.R
\name{getEchoValidationTable}
\alias{getEchoValidationTable}
\title{Get a BirdScan echo validation table}
\usage{
getEchoValidationTable(dbConnection, dbDriverChar)
}
\arguments{
\item{dbConnection}{a valid  database connection}

\item{dbDriverChar}{dbDriverChar 'SQL Server' The name of the driver. Should
be either 'SQL Server' or 'PostgreSQL'. If 'PostgreSQL', it connects to cloud.birdradar.com}
}
\value{
A dataframe called echovalidationTable
}
\description{
gets the echoValidationTable from an already connected database
}
\examples{
\dontrun{
# Set server and database settings
# ===========================================================================
  dbServer       = "MACHINE\\\\SERVERNAME"     # Set the name of your SQL server
  dbName         = "db_Name"                   # Set the name of your database
  dbDriverChar   = "SQL Server"                # Set either "SQL Server" or "PostgreSQL"

# Open the connection with the database
# ===========================================================================
  dsn = paste0("driver=", dbDriverChar, ";server=", dbServer,
               ";database=", dbName,
               ";uid=", rstudioapi::askForPassword("Database user"),
               ";pwd=", rstudioapi::askForPassword("Database password"))
  dbConnection = RODBC::odbcDriverConnect(dsn)

echovalidationTable = getEchoValidationTable(dbConnection, dbDriverChar)
}

}
\author{
Fabian Hertner, \email{fabian.hertner@swiss-birdradar.com};
Birgen Haest, \email{birgen.haest@vogelwarte.ch}
}
