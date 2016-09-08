# Members of the National Assembly
[AssNat ](http://www.assnat.qc.ca) project - MNA since 1972.

## Fields in output

- mp_id:        Unique Member of the National Assembly (MNA) ID
- mp_name:      First Name Last Name of MNA
- mp_female:    Gender variables coded 1 for female 0 for male
- mp_yob:       Year of Birth
- mp_yod:       Year of Death
- mp_url:       Url from where the data is harvested
- elected_year: First year in sentence that matches with "elu"
- mp_link_sent: Sentences containing references to [Familiy Ties](https://github.com/mickaeltemporao/assnat_network/blob/master/src/links.R)
- mp_desc:      Description contained in the personal pages of the MNA
- party_i:      Political parties [Political Parties](https://github.com/mickaeltemporao/assnat_network/blob/master/src/party.R) that match in the description of the MNA
- link_j:       Family ties that match in the description of sentences with references to other MNA
- mp_n:         MNA names that match in sentences containing references to [Familiy Ties](https://github.com/mickaeltemporao/assnat_network/blob/master/src/links.R)

## [Elected Parties](https://fr.wikipedia.org/wiki/Parti_politique_du_Qu%C3%A9bec)

    - pq   = 'Parti québécois',
    - plq  = 'Parti libéral du Québec',
    - caq  = 'Coalition Avenir Québec',
    - qs   = 'Québec Solidaire',
    - adq  = 'Action démocratique du Québec',
    - aln  = 'Action libérale nationale',
    - bpc  = 'Bloc populaire canadien',
    - fcc  = 'Fédération du Commonwealth Coopératif',
    - pcdq = 'Parti social démocratique du Québec',
    - dem  = 'Les démocrates',
    - pdc  = 'Parti démocrate créditiste',
    - lnc  = 'Ligue nationaliste canadienne',
    - pe   = 'Parti égalité',
    - po   = 'Parti ouvrier',
    - pcq  = 'Parti conservateur du Québec',
    - pnp  = 'Parti national populaire',
    - rcq  = 'Ralliement créditiste du Québec',
    - pc   = 'Parti créditiste',
    - un   = 'Union nationale',
    - uq   = 'Unité-Québec'

TODO : fix non extracted YOB & YOD

TODO : replace mp_n by family ties
