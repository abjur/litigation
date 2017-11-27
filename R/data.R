#' Census map from Sao Paulo Municipality
#'
#' A dataset containing coordinates to make censitary regions map
#'
#' @format A data frame with 847,280 rows and 7 variables:
#' \describe{
#'   \item{lat}{latitude}
#'   \item{long}{longitude}
#'   \item{order}{maptools stuff. This is not important}
#'   \item{hole}{maptools stuff. This is not important}
#'   \item{piece}{maptools stuff. This is not important}
#'   \item{group}{maptools stuff. This is not important}
#'   \item{id}{maptools stuff. This is not important}
#' }
#' @source \url{https://www.ibge.gov.br/}
"d_sp_map"


#' Censitary literacy information
#'
#' A dataset containing censitary codes and literacy information
#'
#' @format A data frame with 18,363 rows and 6 variables:
#' \describe{
#'   \item{cod}{censitary region code}
#'   \item{situacao}{censitary code status}
#'   \item{alfab5}{literate population size (above five years old)}
#'   \item{total5}{population size (above five years old)}
#'   \item{prop}{alfab5/total5}
#'   \item{prop_cat}{maptools stuff. This is not important}
#' }
#' @source \url{https://www.ibge.gov.br/}
"educ"

#' Censitary income information
#'
#' A dataset containing censitary codes and income information
#'
#' @format A data frame with 18,363 rows and 9 variables:
#' \describe{
#'   \item{cod}{censitary code}
#'   \item{situacao}{censitary region code status}
#'   \item{sal_1}{population that earn less than one minimum salary}
#'   \item{sal_5}{population that earn between one and five minimum salaries}
#'   \item{sal_inf}{population that earn more than five minimum salaries}
#'   \item{total}{population size (above five years old)}
#'   \item{prop_1}{sal_1/total}
#'   \item{prop_5}{sal_5/total}
#'   \item{prop_inf}{sal_inf/total}
#' }
#' @source \url{https://www.ibge.gov.br/}
"renda"

#' Litigation parties
#'
#' A dataset containing information about the parties of \code{processos}
#'
#' @format A data frame with 8,584,235 rows and 4 variables:
#' \describe{
#'   \item{id}{litigation id (internal)}
#'   \item{id_pessoa}{person id}
#'   \item{tipo_parte}{person side (plaintiff = autor, defendant = reu)}
#'   \item{endereco}{person address}
#' }
#' @source \url{http://www.tjsp.jus.br/}
"partes"

#' Litigation data
#'
#' A dataset containing information about litigation received from TJSP
#'
#' @format A data frame with 227,664 rows and 12 variables:
#' \describe{
#'   \item{id}{litigation id (internal)}
#'   \item{num}{litigation id (CNJ number, external)}
#'   \item{num_dep}{cases related to the litigation}
#'   \item{vara}{name of the court}
#'   \item{juiz}{judge name}
#'   \item{classificacao}{litigation type. 0=Summary, 1=Ordinary, 2=Execution}
#'   \item{classe}{TPU Class from CNJ Res. 46}
#'   \item{assunto}{TPU Subject from CNJ Res. 46}
#'   \item{vl_causa}{case start value}
#'   \item{dt_distribuicao}{litigation start date}
#'   \item{dt_mov}{last movement date}
#'   \item{tempo}{time between start and last movement, in days. It is NA when litigation is not archived}
#' }
#' @source \url{http://www.tjsp.jus.br/}
"processos"


