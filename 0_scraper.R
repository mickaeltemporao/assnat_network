#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        Assnat Scraper
# Filename:     assnat_scraper.R
# Description:  Dynasty Network Data Generator
# Version:      0.0.0.000
# Created:      2016-05-20 14:19:50
# Modified:     2016-09-21 09:38:52
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------
library(stringr)
library(rvest)


scrape <- F
# test <- read_html("http://www.assnat.qc.ca/fr/deputes/papineau-louis-joseph-4735/biographie.html")


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
  # Get MP Names & URLS --------------------------------------------------------
  temp   <- NULL
  output <- NULL
  for(i in 1:length(page_names)) {
    page_i    <- page_names[[i]]
      mp_name <- page_i %>% html_nodes('.imbGauche div a') %>% html_text
      mp_url  <- page_i %>% html_nodes('.imbGauche div a') %>% html_attr('href') %>% paste0(base, .)
    temp      <- data.frame(mp_name, mp_url, stringsAsFactors=F)
    output    <- rbind(output, temp)
  }
  # Create Unique ID -----------------------------------------------------------
  output$mp_id <- paste0('mp_', 1:length(output$mp_name))
  # Get HTML page for each MP
  source('src/funs.R')
  # You might want to run this in small batches as down pages stop the process
  mp_pages <- lapply(output$mp_url, read_html)
  # Get HTML page for each MP
  output$mp_desc <- sapply(mp_pages, get_desc)
  output$mp_desc <- to_plain(tolower(description))
  rm(list=setdiff(ls(), 'output'))
} else {
  output <- read.csv('data/output.csv', stringsAsFactors = F)
}
