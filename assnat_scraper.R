#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        Assnat Dynasty
# Filename:     assnat_scraper.R
# Description:  Dynasty Network Scraper
# Version:      0.0.0.000
# Created:      2016-05-20 14:19:50
# Modified:     2016-07-06 22:23:46
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------

library(rvest)

base <- 'http://www.assnat.qc.ca'
url <- read_html('http://www.assnat.qc.ca/fr/membres/notices/index.html')

az_urls <- url %>%
  html_nodes("p a") %>%
  html_attr('href') %>%
  paste0(base, .) %>%
  .[-1]

page_names <- lapply(az_urls, read_html)
test <-

output <- NULL
for (i in 1:length(page_names)) {
  page_i <- page_names[[i]]
  mp_names <- page_i %>% html_nodes('.imbGauche div a') %>% html_text
  mp_urls <- page_i %>% html_nodes('.imbGauche div a') %>% html_attr('href') %>% paste0(base, .)
  temp <- data.frame(mp_names, mp_urls)
  output <- rbind(output, temp)
}
