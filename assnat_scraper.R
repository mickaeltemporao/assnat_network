#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        Assnat Dynasty
# Filename:     assnat_scraper.R
# Description:  Dynasty Network Scraper
# Version:      0.0.0.000
# Created:      2016-05-20 14:19:50
# Modified:     2016-06-15 10:05:13
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------

library(rvest)
base <- 'http://www.assnat.qc.ca'
url <- read_html('http://www.assnat.qc.ca/fr/membres/notices/index.html')
letters <- url %>%
  html_nodes("p a") %>%
  html_attr('href')
letters <- letters[2:length(letters)]

pages <- data.frame()
#i <- letters[1]
for (i in letters) {
  pages[i,] <- read_html(paste0(base,i))
}

test <- url %>%
  html_nodes('//*[@id="Wrap"]/div[8]')
