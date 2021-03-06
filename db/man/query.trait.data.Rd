\name{query.trait.data}
\alias{query.trait.data}
\title{Extract trait data from database
Extracts data from database for a given trait and set of species,
converts all statistics to summary statistics, and prepares a dataframe for use in meta-analysis.
For Vcmax and SLA data, only data collected between  April and July are queried, and only data collected from the top of the canopy (canopy height > 0.66).
For Vcmax and root_respiration_rate, data are scaled
converted from measurement temperature to \eqn{25^oC} via the arrhenius equation.}
\usage{
  query.trait.data(trait, spstr,
    con = query.base.con(settings), ...)
}
\arguments{
  \item{trait}{is the trait name used in the database,
  stored in variables.name}

  \item{spstr}{is the species.id integer or string of
  integers associated with the species}
}
\value{
  dataframe ready for use in meta-analysis
}
\description{
  Extract trait data from database
}
\examples{
\dontrun{
settings <- read.settings()
query.trait.data("Vcmax", "938", con = query.base.con(settings))
}
}
\author{
  David LeBauer, Carl Davidson, Shawn Serbin
}

