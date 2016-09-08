#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        TODO: (add title)
# Filename:     descriptions.R
# Description:  TODO: (write me)
# Version:      0.0.0.000
# Created:      2016-09-08 07:17:56
# Modified:     2016-09-08 08:11:41
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------
library(rvest)
library(pbapply)
# WARNING MP 1295 page down
rang <- 1:200
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
get_desc <- function (x) {
  desc_str <- '.imbGauche'
  temp <- x %>% html_nodes(desc_str) %>% html_text
  temp <- gsub("[\t\r\n]", " ", temp)
  temp <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", temp, perl=TRUE)
  temp <- gsub(".*Projets de loi Biographie ","",temp)
  return(temp)
}

output <- read.csv('data/output.csv', stringsAsFactors=F)
pages <- pblapply(output$mp_url[rang],read_html)
description <- sapply(pages, get_desc)
description <- to_plain(tolower(description))
mp_id <- paste0('mp_', rang)
dat <- data.frame(mp_id, description)
write.csv(dat, paste0('data/desc_', rang[1],'to',rang[length(rang)], '.csv'), row.names=F)
