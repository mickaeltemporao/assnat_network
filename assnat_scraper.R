#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        Assnat Dynasty
# Filename:     assnat_scraper.R
# Description:  Dynasty Network Scraper
# Version:      0.0.0.000
# Created:      2016-05-20 14:19:50
# Modified:     2016-09-07 06:43:45
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------
#TODO: extract family nodes  -> test sur papineau
#TODO: clean dfm ok
#TODO: extract party
#TODO: fille / fils au lieu de 0/1
#TODO: extract 1st elected year
#TODO: remove diacritics + lowercase


library(quanteda)
library(rvest)

scrape <- F

if (scrape == T) {
  base <- 'http://www.assnat.qc.ca'
  url  <- read_html('http://www.assnat.qc.ca/fr/membres/notices/index.html')
  #
  az_urls <- url %>%
    html_nodes("p a") %>%
    html_attr('href') %>%
    paste0(base, .) %>%
    .[-1]
  page_names <- lapply(az_urls, read_html)
  # Get MP Names & URLS -----------------------------------------------------
  temp   <- NULL
  output <- NULL
  for(i in 1:length(page_names)) {
    page_i    <- page_names[[i]]
      mp_name <- page_i %>% html_nodes('.imbGauche div a') %>% html_text
      mp_url  <- page_i %>% html_nodes('.imbGauche div a') %>% html_attr('href') %>% paste0(base, .)
    temp      <- data.frame(mp_name, mp_url, stringsAsFactors=F)
    output    <- rbind(output, temp)
  }
  # Create Unique ID
  output$ID <- 1:length(output$mp_name)
  # Extract HTML Content for each MP Personal Page
  # test <- read_html("http://www.assnat.qc.ca/fr/deputes/papineau-louis-joseph-4735/biographie.html")
  mp_pages <- lapply(output$mp_url, read_html)
# Extracting Year Variables -----------------------------------------------
#TODO: rename funs
year   <- NULL
foo    <- function (x, search_str) {
  temp <- x %>% html_nodes(search_str) %>%
  html_text
  return(temp)
}
substr_r <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
bar <- function (x) {
ifelse(identical(x, character(0)), NA, x)
}
year_str   <- '.sansMarge'
year       <- sapply(mp_pages, foo, year_str)
year       <- sapply(year, bar)
year       <- iconv(year, to="ASCII//TRANSLIT")
year       <- chartr("`'", "  ", year)
year       <- gsub('[a-zA-Z]', '', year)
year       <- gsub(' ', '', year)
yob        <- as.numeric(substr(year, 2,5))
yod        <- ifelse(substr_r(year, 2)=='.)', NA, substr_r(year, 5))
yod        <- gsub(')', '', yod)
yod        <- as.numeric(yod)
output$yob <- yob
output$yod <- yod
rm(year,   year_str, yob, yod)
#TODO: get year for similars to output[2540,]
# Extraction of Gender Variable -------------------------------------------
bar <- function (x) {
ifelse(identical(substr(x,1,3), 'Née'), 1, 0)
}
gender_str    <- 'h2+ p'
gender        <- sapply(mp_pages,foo,gender_str)
gender        <- sapply(gender, bar)
output$female <- gender
rm(gender,gender_str,temp)
# Extract description paragraphs ------------------------------------------
desc_str           <- '.imbGauche'
desc               <- sapply(mp_pages, foo, desc_str)
desc               <- gsub("[\t\r\n]", "", desc)
desc               <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", desc, perl=TRUE)
# Remove all before and up to ":":
output$description <- gsub(".*Projets de loi Biographie ","",desc)
rm(list=setdiff(ls(), 'output'))
} else {
    output <- read.csv('data/output.csv', stringsAsFactors = F)
}

# Extract DFM -------------------------------------------------------------
# Prepare features dictionnary
source("data/assnat.dict")

temp <- corpus(output$desc)
tm <- dfm(temp, ignoredFeatures=stopwords("french"), stem=F,
            language='french', dictionary = assnat)

topfeatures(tm, 50)

feats <- as.data.frame(tm)
mean(feats[,2])
output$child <- ifelse(feats[1] == 0, 0, 1)

# Extract families --------------------------------------------------------
fam_str <- 'p a'
# Extract Parties ---------------------------------------------------------
