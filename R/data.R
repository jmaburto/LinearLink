# Data in the package

#' Death rates for female populations in US, France and Sweden 
#'
#' A list containing 3 matrices with death rates for female populations in 
#' US, France, Sweden between 1965 and 2014.
#' @usage HMD_mx
#' @format A wide matrix with 101 rows and 49 columns:
#' \tabular{rl}{
#' Columns \tab -- Years (from 1965 to 2014)\cr
#' Rows \tab -- Ages (from 0 to 100)
#' }
#' @examples HMD_mx
#' @source Human Mortality Database, \url{http://www.mortality.org}
#' @seealso \code{\link{HMD_LT}}
'HMD_mx'

#' Life tables
#' 
#' A data.frame with life tables for female populations in USA, France, Sweden, 
#' computed based on \code{\link{HMD_mx}}. The example below is the code to generate 
#' HMD_LT.
#' @usage HMD_LT
#' @format A data.frame with 18150 rows and 11 columns
#' @source Human Mortality Database, \url{http://www.mortality.org}
#' @seealso \code{\link{HMD_mx}} \code{\link{Kannisto}} \code{\link{life.table}}
#' @examples
#' rm(list = ls())
#' library(LinearLink)
#' library(dplyr)
#' 
#' # fit Kannisto model
#' ages <- 80:100
#' kan_USA <- HMD_mx$USA[paste(ages), ] %>% Kannisto(., x = ages) 
#' kan_FRA <- HMD_mx$FRATNP[paste(ages), ] %>% Kannisto(., x = ages) 
#' kan_SWE <- HMD_mx$SWE[paste(ages), ] %>% Kannisto(., x = ages) 
#' summary(kan_SWE)
#' 
#' # extend mortality curve up to 120
#' pred.kan_USA  <- predict(kan_USA, 101:120) 
#' pred.kan_FRA  <- predict(kan_FRA, 101:120) 
#' pred.kan_SWE  <- predict(kan_SWE, 101:120) 
#' 
#' # All data up to age 120 for the 3 countries
#' USA_mx120 <- rbind(HMD_mx$USA, pred.kan_USA)
#' FRA_mx120 <- rbind(HMD_mx$FRATNP, pred.kan_FRA)
#' SWE_mx120 <- rbind(HMD_mx$SWE, pred.kan_SWE)
#' 
#' Countries <- c('USA', 'FRANCE', 'SWEDEN')
#' years <- 1965:2014
#' runs <- expand.grid(country = Countries, year = years, 
#'                     stringsAsFactors = FALSE) %>% arrange(country)
#' 
#' LTs <- NULL 
#' for(j in 1:nrow(runs)){
#'      country_j <- runs[j, 1]
#'      year_j    <- runs[j, 2]
#'      if(country_j == 'USA') dta <- USA_mx120
#'      if(country_j == 'FRANCE') dta <- FRA_mx120
#'      if(country_j == 'SWEDEN') dta <- SWE_mx120
#'      mx_j <- dta[, paste0('mx.', year_j)]
#'      LT_j <- life.table(x = 0:120, mx = mx_j)$lt.exact
#'      LT_j <- data.frame(country = country_j, year = year_j, LT_j)
#'      LTs <- rbind(LTs, LT_j)
#' }
#' 
#' head(LTs)
#' tail(LTs)
'HMD_LT'