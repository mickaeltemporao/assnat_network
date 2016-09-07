#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        TODO: (add title)
# Filename:     simple_extract.R
# Description:  TODO: (write me)
# Version:      0.0.0.000
# Created:      2016-09-07 06:32:53
# Modified:     2016-09-07 10:00:34
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------
library(quanteda)
library(rvest)
library(stringr)

test <- read_html("http://www.assnat.qc.ca/fr/deputes/papineau-louis-joseph-4735/biographie.html")
test <- read_html(output$mp_url[2540])

to_plain <- function(s) {
# Converts all accented characters to plain text
# http://stackoverflow.com/questions/17517319/r-replacing-foreign-characters-in-a-string
   # 1 character substitutions
   old1 <- "šžþàáâãäåçèéêëìíîïðñòóôõöùúûüý"
   new1 <- "szyaaaaaaceeeeiiiidnooooouuuuy"
   s1 <- chartr(old1, new1, s)
   # 2 character substitutions
   old2 <- c("œ", "ß", "æ", "ø")
   new2 <- c("oe", "ss", "ae", "oe")
   s2 <- s1
   for(i in seq_along(old2)) s2 <- gsub(old2[i], new2[i], s2, fixed = TRUE)
   s2
}

# ID
# NAME
# URL
# DESCRIPTION
get_desc <- function (x) {
  desc_str <- '.imbGauche'
  temp <- x %>% html_nodes(desc_str) %>% html_text
  temp <- gsub("[\t\r\n]", " ", temp)
  temp <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", temp, perl=TRUE)
  temp <- gsub(".*Projets de loi Biographie ","",temp)
  return(temp)
}
get_desc(test)

# FEMALE
get_gender <- function (x) {
  x <- get_desc(x)
  ifelse(identical(substr(x,1,3), 'Née'), 1, 0)
}
get_gender(test)

# YOB & YOD
get_year <- function (x, type) {
# Returns a dataframe with yob & yod of selected mep
  x <- get_desc(x)
  sentences <- unlist(strsplit(x, ". ", fixed=T))
  if (type == 1){
  yob_sent <- sentences[grep('Né', sentences)]
  yob <- as.numeric(
    grep('[0-9]{4}',
      gsub(',','',
        unlist(
          strsplit(yob_sent, split=' '))),
      value=T))
  return(yob)
  }
  if (type == 2) {
    if (identical(sentences[grep('Décédé', sentences)], character(0))) {
      yod <- NA
      return(yod)
    } else {
      yod_sent <- sentences[grep('Décédé', sentences)]
      yod <- as.numeric(
        grep('[0-9]{4}',
          gsub(',','',
            unlist(
              strsplit(yod_sent, split=' '))),
          value=T))
      return(yod)
    }
  } else {
  print(paste0('Choose between: 1 = Year of Birth; 2 = Year of Death'))
  }
}
get_year(test, 2)

# PARTY
source("src/party.R")
get_party <- function (x) {
  x <- test
  x <- tolower(get_desc(x))
  x <- to_plain(x)
  x <- sentences <- unlist(strsplit(x, ". ", fixed=T))
  for (i in party) {
    if (grep(i, x, fixed=TRUE)>=0) {
      grep(i, x, fixed=TRUE

yod_sent <- sentences[grep('Décédé', sentences)]
      yod <- as.numeric(
        grep('[0-9]{4}',
          gsub(',','',
            unlist(
              strsplit(yod_sent, split=' '))),
          value=T))
    }
    else (identical(grep(i, x, fixed=TRUE), integer(0))) {
    0
    }


  }
}

# LINKS
