% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{renda}
\alias{renda}
\title{Censitary income information}
\format{A data frame with 18,363 rows and 9 variables:
\describe{
  \item{cod}{censitary code}
  \item{situacao}{censitary region code status}
  \item{sal_1}{population that earn less than one minimum salary}
  \item{sal_5}{population that earn between one and five minimum salaries}
  \item{sal_inf}{population that earn more than five minimum salaries}
  \item{total}{population size (above five years old)}
  \item{prop_1}{sal_1/total}
  \item{prop_5}{sal_5/total}
  \item{prop_inf}{sal_inf/total}
}}
\source{
\url{https://www.ibge.gov.br/}
}
\usage{
renda
}
\description{
A dataset containing censitary codes and income information
}
\keyword{datasets}
