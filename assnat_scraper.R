#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        Assnat Dynasty
# Filename:     assnat_scraper.R
# Description:  Dynasty Network Scraper
# Version:      0.0.0.000
# Created:      2016-05-20 14:19:50
# Modified:     2016-08-11 22:43:22
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------
library(rvest)

scrape <- T

if (scrape == T) {
base <- 'http://www.assnat.qc.ca'
url <- read_html('http://www.assnat.qc.ca/fr/membres/notices/index.html')

az_urls <- url %>%
  html_nodes("p a") %>%
  html_attr('href') %>%
  paste0(base, .) %>%
  .[-1]

page_names <- lapply(az_urls, read_html)

# Get MP Names & URLS
temp <- NULL
output <- NULL
for (i in 1:length(page_names)) {
  page_i <- page_names[[i]]
  mp_name <- page_i %>% html_nodes('.imbGauche div a') %>% html_text
  mp_url <- page_i %>% html_nodes('.imbGauche div a') %>% html_attr('href') %>% paste0(base, .)
  temp <- data.frame(mp_name, mp_url, stringsAsFactors=F)
  output <- rbind(output, temp)
}
# Extract HTML Content for each MP Personal Page
mp_pages <- lapply(output$mp_url, read_html)
# Save mp_pages
save(mp_pages, file="mp_pages.RData")
}

#load("data/mp_pages.RData")

#TODO: rename funs
# Extract YOB & YOD
year <- NULL
foo <- function (x, search_str) {
  temp <- x %>% html_nodes(search_str) %>%
  html_text
  return(temp)
}
substr_r<- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}
bar <- function (x) {
ifelse(identical(x, character(0)), NA, x)
}

# Extracting Year Variables
year_str <- '.sansMarge'
year <- sapply(mp_pages, foo, year_str)
year <- sapply(year, bar)
year <- iconv(year, to="ASCII//TRANSLIT")
year <- chartr("`'", "  ", year)
year <- gsub('[a-zA-Z]', '', year)
year <- gsub(' ', '', year)
yob <- as.numeric(substr(year, 2,5))
yod <- ifelse(substr_r(year, 2)=='.)', NA, substr_r(year, 5))
yod <- gsub(')', '', yod)
yod <- as.numeric(yod)
output$yob <- yob
output$yod <- yod
rm(yob, yod)



gender_str <- 'h2+ p'
gender <- sapply(mp_pages, foo, gender_str) %>% unlist()

#TODO: extract descriptions
#TODO: extract DTMs
