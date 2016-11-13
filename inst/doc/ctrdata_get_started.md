---
title: "ctrdata getting started"
author: "Ralf Herold"
date: "2016-11-13"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{ctrdata getting started}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

# Getting started with R package `ctrdata` for clinical trial protocol-related information



## Install package `ctrdata` on a R system

The R Project website ([https://www.r-project.org/](https://www.r-project.org/)) provides installers for the R system. 

Alternatively, the R system can be used from software products such as R Studio ([https://www.rstudio.com/products/RStudio/](https://www.rstudio.com/products/RStudio/)), which includes an open source integrated development environment (IDE), or Microsoft R Open ([https://mran.microsoft.com/open/](https://mran.microsoft.com/open/)). 

General information on the `ctrdata` package is available here: [https://github.com/rfhb/ctrdata](https://github.com/rfhb/ctrdata). 


```r
# 
# install preparatory package
install.packages(c("devtools", "httr"))
#
# set proxy, if needed
library(httr)
set_config(use_proxy("proxy.server.domain", 8080))
#
# on windows: change library path to *not* use an 
# UNC notation (\\server\directory) for the library
.libPaths("D:/my/directory/")
#
# first install rmongodb (see README.md)
devtools::install_github("mongosoup/rmongodb")
#
# now install this package
devtools::install_github("rfhb/ctrdata")
#
# note: on Windows, cygwin has to be installed
# to provide php, bash, perl, cat and sed programs.
# this can be done like this: 
installCygwinWindowsDoInstall(proxy = "proxy.server.domain:8080") 
#
```


## Attach package `ctrdata`

```r
#
library(ctrdata)
#
```

## Open register's advanced search page in browser

```r
#
ctrOpenSearchPagesInBrowser()
#
# Please review and respect register copyrights:
#
ctrOpenSearchPagesInBrowser(copyright = TRUE)
#
# Open browser with example search:
#
ctrOpenSearchPagesInBrowser(register = "EUCTR", queryterm = "cancer&age=under-18")
#
```

## Click search parameters and execute search in browser 

## Copy address from browser address bar to clipboard

## Get address from clipboard

```r
#
q <- ctrGetQueryUrlFromBrowser()
#
# Found search query from EUCTR.
# [1] "cancer&age=under-18"
#
```

## Retrieve protocol-related information, transform, save to database, check

```r
#
# Use search q that was defined in previous step: 
#
ctrLoadQueryIntoDb(q)
#
# Alternatively, use the following to retrieve a couple of trials: 
#
ctrLoadQueryIntoDb(queryterm = "2010-024264-18", register = "EUCTR")
#
# If no parameters are given for a database connection: uses mongodb
# on localhost, port 27017, database "users", collection "ctrdata"
# note: when run for first time, may download variety.js
#
# Show which queries have been downloaded into the database so far
#
dbQueryHistory()
#
# Using Mongo DB (collections "ctrdata" and "ctrdataKeys" in database "users" on "localhost").
# Number of queries in history of "users.tmp": 2
#       query-timestamp query-register query-records                  query-term
# 1 2016-01-13-10-51-56          CTGOV          5233 type=Intr&cond=cancer&age=0
# 2 2016-01-13-10-40-16          EUCTR           910         cancer&age=under-18
#
```

## Analyse database contents

```r
#
# find names of fields of interest in database:
#
dbFindVariable("status", allmatches = TRUE)
#
# [1] "overall_status"  "b1_sponsor.XX.b31_and_b32_status_of_the_sponsor" "p_end_of_trial_status"                          
# [4] "x5_trial_status" "location.status"                                 "location.XX.status"
#
# Get all records that have values in all specified fields.
# Note that b31_... is a field within the array b1_...
#
result <- dbGetVariablesIntoDf(c("b1_sponsor.b31_and_b32_status_of_the_sponsor", 
                                 "x5_trial_status"), debug = TRUE)
#
# Tabulate the status of the clinical trial on the date of information retrieval
#
with (result, table ("Status" = x5_trial_status, 
                     "Sponsor type" = b1_sponsor.b31_and_b32_status_of_the_sponsor))
#
#                     b31_and_b32_status_of_the_sponsor
# x5_trial_status      Commercial Non-Commercial
#   Completed                 138             30
#   Not Authorised              3              0
#   Ongoing                   339            290
#   Prematurely Ended          35              4
#   Restarted                   8              0
#   Temporarily Halted         14              4
#
```