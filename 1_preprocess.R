#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        TODO: (add title)
# Filename:     easy_harvest.R
# Description:  TODO: (write me)
# Version:      0.0.0.000
# Created:      2016-09-08 10:43:02
# Modified:     2016-09-09 16:53:07
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------
output <- read.csv('data/output.csv')


# NAME # Temporary mp_names to match mp descriptions
mp_names <- tolower(output$mp_name)
mp_names <- to_plain(mp_names)
mp_names <- gsub(',.', ',', mp_names)
for (i in 1:length(mp_names)) {
  mp_names[i] <- paste(unlist(str_split(mp_names[i], ","))[-1], unlist(str_split(mp_names[i], ","))[1])
}
# mp_names <- NULL
# mp_names <- character(length(output$mp_name))
# for (i in 1:length(mp_names)) {
#   if (identical(grep('patrimoine', output$mp_url[i]), integer(0))) {
#     mp_names[i] <- output$mp_url[i] %>% read_html %>%
#     html_nodes('.enteteFicheDepute h1') %>%
#     html_text
#   } else {
#     mp_names[i] <- output$mp_url[i] %>% read_html %>%
#     html_nodes('.imbGauche h1') %>%
#     html_text
#   }
# }


# FEMALE
get_gender <- function (x) {
# Returns 1 if female; 0 if male
  x <- get_desc(x)
  ifelse(identical(substr(x,1,3), 'nee'), 1, 0)
}


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


# PARTY
source("src/party.R")
for (i in 1:length(party)) {
  output[[paste0('party_', abv_party[i])]] <- as.numeric(grepl(party[i], output$mp_desc))
}
rm(party, abv_party, i)


# LINKS
source('src/links.R')
# Sentences with links
for (i in 1:length(output$mp_desc)) {
  x <- unlist(strsplit(output$mp_desc[i], ". ", fixed=T))
  sentences <- x[unlist(grep(paste(links, collapse='|'), x))]
  output[['mp_link_sent']][i] <- paste(sentences, collapse = '. ')
}
for (i in 1:length(links)) {
  output[[paste0('link_', links[i])]] <- as.numeric(grepl(links[i], output$mp_link_sent))
  # output[[paste0('link_', unlist(str_extract_all(output$mp_link_sent, paste(links, collapse='|'))))]] <- 1
}
for (i in 1:length(output$mp_id)) {
  output[[paste0('mp_', i)]] <- as.numeric(grepl(output$mp_name[i], output$mp_link_sent))
}
output <- dplyr::select(output, 1:6, mp_link_sent, mp_desc, dplyr::everything())
rm(links, x, i, sentences)


# YEAR ELECTED
for (i in 1:length(output$mp_desc)) {
  x <- unlist(strsplit(output$mp_desc[i], ". ", fixed=T))
  first_year_sent <- x[unlist(grep('elu', x))[1]]
  output$elected_year[i] <- as.numeric(str_extract(first_year_sent, '[0-9]{4}'))
}


rm(list=setdiff(ls(), 'output'))
output <- dplyr::select(output, 1:6, elected_year, mp_link_sent, mp_desc, dplyr::everything())
#write.csv(output, 'data/20160908_assnat.csv', row.names=F)
