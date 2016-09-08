#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        TODO: (add title)
# Filename:     simple_extract.R
# Description:  TODO: (write me)
# Version:      0.0.0.000
# Created:      2016-09-07 06:32:53
# Modified:     2016-09-08 09:09:16
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------
library(quanteda)
library(rvest)
library(stringr)
library(pbapply)
# ID
# NAME
# URL
test <- read_html("http://www.assnat.qc.ca/fr/deputes/papineau-louis-joseph-4735/biographie.html")
output <- read.csv('data/output.csv', stringsAsFactors=F)

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
   return(s2)
}

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
# Returns 1 if female; 0 if male
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
get_year(test, 1)

# PARTY
source("src/party.R")
for (i in 1:length(party)) {
output[[paste0('party_', abv_party[i])]] <- as.numeric(grepl(party[1], output$mp_desc))
}

# Temporary mp_names and id creation
output <- read.csv('data/output.csv', stringsAsFactors=F)
mp_id <- paste0('mp_', 1:length(output$mp_name))
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

# LINKS
source('src/links.R')
get_links <- function (x) {
#  x <- test
#  x <- read_html(output$mp_url[23])
  x1 <- tolower(get_desc(x))
  x1 <- to_plain(x1)
  x1 <- unlist(strsplit(x1, ". ", fixed=T))
  sentences <- unlist(grep(paste(links, collapse='|'), x1))
  urls <- x %>%
    html_nodes("p a") %>%
    html_attr('href') %>%
    .[-1]
  mps <- as.data.frame(setNames(replicate(length(mp_names),numeric(0), simplify = F), mp_id), stringsAsFactors=F)
  for (i in 1:length(urls)) {
    which_mp <- mp_id[which(urls[i] == output$mp_url)]
    mps[1,which_mp] <- 1
  }
  return(mps)
}
get_links(test)

# for (i in sentences) {
#   link <- unlist(str_extract_all(x[i], paste(links, collapse='|')))

########

########
mp_parties <- as.data.frame(setNames(replicate(length(party),numeric(0), simplify = F), abv_party))
output <- dplyr::bind_rows(output, mp_parties)
out <- as.data.frame(setNames(replicate(length(mp_names),character(0), simplify = F), output$mp_id), stringsAsFactors=F)
output <- dplyr::bind_rows(output, out)
