#!/usr/bin/env Rscript
# ------------------------------------------------------------------------------
# Title:        TODO: (add title)
# Filename:     family.R
# Description:  TODO: (write me)
# Version:      0.0.0.000
# Created:      2016-09-02 13:21:02
# Modified:     2016-09-06 13:44:59
# Author:       Mickael Temporão < mickael.temporao.1 at ulaval.ca >
# ------------------------------------------------------------------------------
# Copyright (C) 2016 Mickael Temporão
# Licensed under the GPL-2 < https://www.gnu.org/licenses/gpl-2.0.txt >
# ------------------------------------------------------------------------------
library(rvest)
te <- "<p>Né à Saint-Benoît (Mirabel), le 24 mars 1907, fils d'Arthur <a href='http://www.assnat.qc.ca/fr/deputes/sauve-arthur-5301/index.html'>Sauvé</a>, journaliste, et de Marie-Louise Lachaîne.</p>
<p>Fit ses études à l'école de sa paroisse natale, au Séminaire de Sainte-Thérèse, au Collège Sainte-Marie et à l'Université de Montréal. Fit sa cléricature auprès de M<sup>e </sup>Aldéric <a href='http://www.assnat.qc.ca/fr/deputes/blain-alderic-2117/index.html'>Blain</a>, puis au cabinet Chauvin, Walker, Stewart &amp; Martineau. Admis au Barreau de la province de Québec le 8 juillet 1930. Créé conseil en loi du roi le 30 décembre 1938. Reçut un doctorat en droit <em>honoris causa</em> du Collège Bishop's et de l'Université Laval en 1952.</p>
<p>S'enrôla comme lieutenant dans l'armée de réserve en 1931. Mobilisé en 1939. Promu capitaine et commandant de compagnie au Centre de Sorel en 1940. Fut l'un des organisateurs de l'École d'officiers et de sous-officiers de Saint-Hyacinthe en 1941 et du Centre d'instruction avancée de Farnham en 1942. Servit en Europe avec les Fusiliers Mont-Royal en 1943, puis participa au débarquement en Normandie à titre de commandant en second en 1944. Promu lieutenant-colonel et commandant des Fusiliers Mont-Royal en 1944. Nommé brigadier de la 10<sup>e</sup> brigade d'infanterie de réserve en 1947. Décoré de la croix de guerre française et de la médaille de l'Efficacité. Membre des Chevaliers de Colomb, du Cercle universitaire, du Club Saint-Denis, du Montreal Club, du Club de la Garnison, du Club Outremont, du Quebec Winter Club, du Seigniory Club et des clubs Addington et Hedrolar.</p>
<p>Élu député conservateur dans Deux-Montagnes à l'élection partielle du 4 novembre 1930. Réélu en 1931. Défait en 1935. Élu député de l'Union nationale dans Deux-Montagnes en 1936, en 1939, en 1944, en 1948, en 1952 et en 1956. Orateur de l'Assemblée législative du 7 octobre 1936 au 20 février 1940. Ministre du Bien-être social et de la Jeunesse dans le cabinet Duplessis du 18 septembre 1946 au 15 janvier 1959. Ministre de la Jeunesse et ministre du Bien-être social du 15 janvier au 11 septembre 1959. Choisi chef de l'Union nationale le 10 septembre 1959. Premier ministre, président du Conseil exécutif, ministre de la Jeunesse et ministre du Bien-être social du 11 septembre 1959 jusqu'à son décès.</p>
<p>Décédé en fonction à Saint-Eustache, le 2 janvier 1960, à l'âge de 52 ans et 9 mois. Inhumé dans le cimetière de cette paroisse, le 5 janvier 1960.</p>
<p>Avait épousé à Montréal, dans la paroisse Saint-Jacques-le-Majeur, le 4 juillet 1936, Luce Pelland, fille de Zéphirin Pelland, cultivateur, et d'Armina Laferrière.</p>"

mnep_name <- '.enteteFicheDepute h1'
to_test <- 'http://www.assnat.qc.ca/fr/deputes/papineau-louis-joseph-4735/biographie.html'
mnep_page <- 'http://www.assnat.qc.ca/fr/deputes/sauve-joseph-mignault-paul-5305/biographie.html'
family_node <- 'h2+ p a'

# Même phrase + lien + famille
get_family <- function (mnep_page, family_node) {
#Get link of the family member
  mnep_page   %>%
    read_html %>%
    html_nodes(family_node) %>%
    html_attr("href") %>%
    return
# Match family member row
# Extract family member name
  mnep_page %>%
    read_html %>%
    html_nodes(mnep_name) %>%
    html_text %>%
    return
}

get_family(mnep_page, family_node)
