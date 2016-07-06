#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        Assnat Dynasty
# Filename:     assnat_scraper.R
# Description:  Dynasty Network Scraper
# Version:      0.0.0.000
# Created:      2016-05-20 14:19:50
# Modified:     2016-07-05 20:37:37
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

letters <- lapply(az_urls, read_html)

url %>%
  html_nodes('//*[@id="Wrap"]/div[8]')
