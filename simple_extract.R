#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        TODO: (add title)
# Filename:     simple_extract.R
# Description:  TODO: (write me)
# Version:      0.0.0.000
# Created:      2016-09-07 06:32:53
# Modified:     2016-09-07 08:34:24
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------
library(quanteda)
library(rvest)
library(stringr)

test <- read_html("http://www.assnat.qc.ca/fr/deputes/papineau-louis-joseph-4735/biographie.html")

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
  x <- get_desc(test)
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
  yod_sent <- sentences[grep('Décédé', sentences)]
  yod <- as.numeric(
    grep('[0-9]{4}',
      gsub(',','',
        unlist(
          strsplit(yod_sent, split=' '))),
      value=T))
  return(yod)
  } else {
  print(paste0('Choose between: 1 = Year of Birth; 2 = Year of Death'))
  }
}

get_year(test, 2)

#TODO: get year for similars to output[2540,]

# PARTY

# LINKS
