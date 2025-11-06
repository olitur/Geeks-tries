// Document converti depuis DOCX avec Pandoc
// Post-traité pour Typst

// Métadonnées du document
#set document(
 title: "3671376NC001A",
 author: "EGCEM",
 date: datetime.today()
)

// Configuration de la page (A4, marges automatiques, français)
#set page(
 paper: "a4",
 margin: auto,
 header: align(right)[
 #text(size: 9pt, fill: gray)[3671376NC001A.pdf]
 ],
 footer: align(center)[
 #context [
 #text(size: 9pt)[ #counter(page).display("1/1", both: true) ]
 ]
 ]
)

// Configuration du texte (Atkinson Hyperlegible prioritaire, Arial et polices actuelles en fallback, 11pt)
#set text(
 font: ("Atkinson Hyperlegible", "Arial", "Liberation Sans", "DejaVu Sans"), size: 11pt, lang: "fr",
 region: "FR"
)

// Configuration des paragraphes
#set par(
 justify: true,
 first-line-indent: 0pt
)

// Configuration des titres
#show heading.where(level: 1): set text(size: 18pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")

// Configuration des liens
#show link: set text(fill: blue)
#show link: underline

#figure(
 align(center)[#table(
 columns: (5.59%, 1.5%, 7.09%, 5.67%, 8.01%, 5.84%, 6.5%, 16.69%, 6.55%, 16.69%, 6.5%, 12.63%, 0.73%),
 align: (center,center,center,center,center,center,center,center,center,center,center,center,center,),
 table.header(table.cell(align: center, colspan: 4)[#image("media/image1.jpg", width: 80%)], table.cell(align: center, colspan: 9)[#strong[#underline[Maître d'Ouvrage~:];]

 #strong[VILLE D'AIX EN PROVENCE]

 Département constructions neuves

 Direction Travaux spéciaux -- CS 30715 -- 13616 Aix-en-Provence CEDEX1

 Tél~: 04 42 91 91 80 -- Fax~: 04.42.91.98.11

 E-mail~:
 #link("mailto:vincentjp@mairie-aixenprovence.fr")[vincentjp\@mairie-aixenprovence.fr]

 ],),
 table.hline(),
 table.cell(align: center, colspan: 4)[#image("media/image2.png", width: 80%)], table.cell(align: center, colspan: 9)[#strong[#underline[Etudes GC~:];]

 #strong[ETUDES DE GENIE CIVIL ET D'EQUIPEMENTS MEDITERRANEE]

 19, rue Malaval -- 13002 MARSEILLE

 Tél~: 04.91.90.32.01 -- Fax~: 04.91.90.03.94 -- E-mail~: #link("mailto:contact@egcem.com")[contact\@egcem.com]

 ],
 table.cell(align: center, colspan: 13)[#smallcaps[Passerelle piétonne sur l'Arc du coton rouge]

 #smallcaps[Projet de remplacement]

 #underline[Vérification de la structure actuelle]

 Note de calculs

 ],
 [], table.cell(colspan: 3)[], table.cell(colspan: 2)[], [], [], [], [], [], table.cell(colspan: 2)[],
 [], table.cell(colspan: 3)[], table.cell(colspan: 2)[], [], [], [], [], [], table.cell(colspan: 2)[],
 [], table.cell(colspan: 3)[], table.cell(colspan: 2)[], [], [], [], [], [], table.cell(colspan: 2)[],
 [], table.cell(colspan: 3)[], table.cell(colspan: 2)[], [], [], [], [], [], table.cell(colspan: 2)[],
 [A], table.cell(align: center, colspan: 3)[07/07/2014], table.cell(align: center, colspan: 2)[GDE], [#image("media/image3.jpeg", width: 100%)], [SGE], [#image("media/image4.jpeg", width: 100%)], [RBA], [#image("media/image5.jpeg", width: 100%)], table.cell(align: center, colspan: 2)[PREL],
 [#strong[IND];], table.cell(align: center, colspan: 3)[#strong[DATE];], table.cell(align: center, colspan: 2)[#strong[REDACTEUR];], [#strong[VISA];], [#strong[VERIFICATEUR];], [#strong[VISA];], [#strong[CONTROLEUR];], [#strong[VISA];], table.cell(align: center, colspan: 2)[#strong[ETAT];],
 table.cell(colspan: 4)[CODE CLIENT], table.cell(colspan: 3)[], table.cell(colspan: 2)[NOMBRE DE PAGES~: 29], table.cell(colspan: 4)[NOMBRE D'ANNEXES~: 2],
 table.cell(colspan: 4)[CODE EGCEM], table.cell(colspan: 3)[3671376NC001A], table.cell(colspan: 6)[#emph[REF.INF.~: S:\\3671376 - MOE PASSERELLE ARC\\NOTES\\NC001\\3671376NC001A.docx];],
 table.cell(align: center, colspan: 3)[INDICE], table.cell(align: center, rowspan: 2, colspan: 2)[DATE], table.cell(align: center, rowspan: 2, colspan: 7)[ORIGINE ET DETAIL DES MODIFICATIONS], [],
 table.cell(align: center, colspan: 2)[Interne], [Client], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[A], [A], table.cell(align: center, colspan: 2)[07/07/2014], table.cell(align: center, colspan: 7)[Première diffusion], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 table.cell(align: center, colspan: 2)[], [], table.cell(align: center, colspan: 2)[], table.cell(align: center, colspan: 7)[], [],
 )]
 , kind: table
 )

#pagebreak(weak: true)
#outline(
 depth: 3,
 title: "Sommaire"
)

#pagebreak()


#strong[ANNEXE A~: Note descriptive de la modélisation 14]

#strong[ANNEXE B~: Sorties graphiques 19]

= \
Objet de la note
<objet-de-la-note>
Cette note a pour objet la vérification structurelle d'une passerelle piétonne franchissant la rivière l'Arc à Aix-en-Provence (13).

= Documents de référence
<documents-de-référence>
#block[
#set enum(numbering: "1.", start: 1)
+ NF EN 1990 Eurocode 0 (et son annexe nationale)~: base de calculs des structures + NF EN 1991 Eurocode 1 (et son annexe nationale)~: Actions sur les structures + NF EN 1992 Eurocode 2 (et son annexe nationale)~: Calcul des structures en béton + Relevé de la géométrie de la passerelle établit lors du diagnostic (pas de numéro référence)
]

= LogICiels de calculs utilisés
<logiciels-de-calculs-utilisés>
#figure(
 align(center)[#table(
 columns: (45.69%, 21.46%, 32.84%),
 align: (center,center,center,),
 table.header([Logiciel], [Version], [Distributeur],),
 table.hline(),
 [ADVANCE], [2014 SP1], [Graitec],
 [], [], [],
 )]
 , kind: table
 )

= Hypothèses
<hypothèses>
== Géométrie
<géométrie>
Il s'agit d'une passerelle métallique de 1.50m de largeur supportée par deux profilés IPN200 sur chacun de ses bords. Elle est équipée d'un platelage en tôle acier de 5mm posé sur des entretoises UPN80 chaque mètre.

D'une longueur totale de 34.25m, la passerelle présente un profil en long courbe. Elle se compose de 4 travées continues sur appuis. Les appuis 2 et 4 sont des piles et seront représentés comme des appuis linéaires. Le reste des appuis sont des appuis simples.

On présente ci-après le profil en long et la coupe type de la passerelle~:

#figure(image("media/image6.jpg", width: 100%),
 caption: [ : Passerelle - Vue en élévation ]
)

#figure(image("media/image7.jpg", width: 80%),
 caption: [ : Passerelle - Coupe type ]
)

== Matériaux
<matériaux>
=== Acier de charpente
<acier-de-charpente>
La nuance de l'acier constituant la passerelle n'est pas connue. Une reconnaissance de la résistance de cet acier serait susceptible de modifier les conclusions de cette étude. Pour l'heure nous faisons les hypothèses suivantes~:

- Nuance~: S235

- Limite d'élasticité~: $f_y$ = 235MPa

- Masse volumique~: rho = 7850 kg/m^3 = 78.50 kN/m^3

- Caractéristiques des sections utilisées~:

#figure(
 align(center)[#table(
 columns: (16.01%, 13.57%, 13.88%, 15.12%, 15.18%, 13.12%, 13.12%),
 align: (center,center,center,center,center,center,center,),
 table.header([Section], [M

 \[kg/ml\]

 ], [Iy

 \[cm^4;\]

 ], [Wely

 \[cm^3;\]

 ], [Wply

 \[cm^3;\]

 ], [Av

 \[cm^2;\]

 ], [Classe],),
 table.hline(),
 [IPN 200], [26.2], [2140], [214], [250], [16.03], [I],
 [UPN 80], [8.65], [106], [26.5], [31.8], [5.10], [I],
 )]
 , kind: table
 )

#underline[NOTA~:] Il n'est pas tenu compte dans cette note de l'état de
corrosion de la passerelle et des éventuels chocs qu'elle a pu subir susceptible de modifier la résistance de la structure.

== Charges
<charges>
=== Charges permanentes (G)
<charges-permanentes-g>
- PP (INP200) = 0.262 kN/ml

- PP (UPN80) = 0.087 kN/ml (1 UPN80 par mètre)

- PP(tôle 5mm) = 0.005\*78.50 = 0.393 kN/m^2

- PP (garde-corps) = 0.35 kN/ml

La passerelle ayant une largeur de 1.50m la charge permanente uniformément répartie sur une des deux poutres porteuses vaut~:

- g = 0.262 + 0.087\*1.50/2 + 0.393\*1.50/2 + 0.35 = 0.972 kN/ml

=== Charges d'exploitation (GR) 
<charges-dexploitation-gr>
Selon l'EC1, deux modèles de charge sont à prendre en compte pour la passerelle. Un modèle de charge uniformément répartie (GR1) et un modèle de charge concentrée (GR2).

- Modèle de charge uniformément répartie (gr1)

- $q_("fk")$ = 5.0 kN/m^2

- Modèle de charge concentrée (gr2)

- $Q_("fwk")$ = 10 kN (surface d'impact 0.10m x 0.10m)

NOTA~: On ne considère pas de charge correspondant au passage d'un véhicule de service car les dimensions de la passerelle ne permettent pas le cheminement de véhicule.

== Combinaisons
<combinaisons>
On rappelle ci-après les coefficients partiels à prendre en compte pour la constitution des combinaisons~:

#figure(
  image("media/image8.png", width: 80%)
)

D'où les combinaisons suivantes~:

#figure(
  image("media/image9.png", width: 80%)
)

= \
Vérification des profilés
<vérification-des-profilés>
== Poutres porteuses IPN200
<poutres-porteuses-ipn200>
On détermine ci-après le moment de flexion résistant $M_("c, Rd")$;, ainsi que l'effort de cisaillement résistant $V_("c, Rd")$ du profilé.

- Moment de flexion résistant~: $M_("c, Rd")$ = $M_("pl, Rd")$ =
$W_("pl")$;\*$f_y$;/$gamma_("M0")$ = 250\*235/1.0 = 58.75 kN.m

- Effort de cisaillement résistant~: $V_("pl, Rd")$ =
$A_v$;\*($f_y$;/sqrt3)/$gamma_("M0")$ = 16.03\*(235e2/sqrt3)/1.0 = 217.5 kN

si $V_("Ed")$ \> $V_("pl, Rd")$;/2 alors $M_("c, Rd")$ = (1-rho)\*M_("pl, Rd") avec rho = (2\*$V_("Ed")$;/$V_("pl, Rd")$ - 1)^2 sinon M_("c, Rd") = $M_("pl, Rd")$

A l'aide d'un modèle élément fini on détermine les sollicitations du profilé IPN200 pour les combinaisons d'état limite ultime. La combinaison où la charge uniformément répartie est disposée en damier est la plus pénalisante COMB111 \[1.35 G + 1.50 GR1\]. On obtient~:

- $M_("Ed")$ = 55.59 kN.m (sur appui)

- $V_("Ed")$ = 77.75 kN (sur appui)

#figure(image("media/image10.jpeg", width: 80%),
 caption: [ : COMB111 - Effort de cisaillement Fz - ELU ]
)

On note que $V_("Ed")$ = 77.75 kN \< $V_("pl, Rd")$ = 217.5 kN.
#strong[#underline[Vérifié~!];]

#figure(image("media/image11.jpeg", width: 80%),
 caption: [ : COMB111 - Moment de flexion My -- ELU ]
)

$V_("Ed")$ \< $V_("pl, Rd")$;/2, ainsi $M_("c, Rd")$ = $M_("pl, Rd")$ = 58.75 kN.m

On constate que $M_("Ed")$ = 55.59 kN.m \< $M_("c, Rd")$ = 58.75 kN.m
#strong[#underline[Vérifié~!];]

On présente ci-après la distribution des contraintes le long de la poutre pour la combinaison ELU 111~:

#figure(image("media/image12.jpeg", width: 80%),
 caption: [ : COMB 111 - Distribution des contraintes - Sv ]
)

On constate que $sigma_("Ed")$ /($f_y$;/ $gamma_("M0")$) = 273/(235/1.0) = 1.16 \> 1.00 #strong[#underline[Non vérifié~!];]

On présente ci-après la déformée d'une poutre porteuse pour la combinaison ELS la plus pénalisante COMB107 \[1.00 G +1.00 GR1\] avec $q_("fk")$ (5.00 kN/m^2;) répartit en damier.

#figure(image("media/image13.jpeg", width: 80%),
 caption: [ : COMB107 - Déformée D -- ELS ]
)

On obtient une flèche de 41.05 mm dans la travée n°2 d'une portée de 9.85m.

Ainsi, la flèche obtenue vaut #strong[L/239]

== Entretoises UPN80
<entretoises-upn80>
On détermine ci-après le moment de flexion résistant $M_("c, Rd")$;, ainsi que l'effort de cisaillement résistant $V_("c, Rd")$ du profilé.

- Moment de flexion résistant~: $M_("c, Rd")$ = $M_("pl, Rd")$ =
$W_("pl")$;\*$f_y$;/$gamma_("M0")$ = 26.5\*235/1.0 = 6.23 kN.m

- Effort de cisaillement résistant~: $V_("pl, Rd")$ =
$A_v$;\*($f_y$;/sqrt3)/$gamma_("M0")$ = 5.10\*(235e2/sqrt3)/1.0 = 69.20 kN

si $V_("Ed")$ \> $V_("pl, Rd")$;/2 alors $M_("c, Rd")$ = (1-rho)\*M_("pl, Rd") avec rho = (2\*$V_("Ed")$;/$V_("pl, Rd")$ - 1)^2 sinon M_("c, Rd") = $M_("pl, Rd")$

On détermine ci-après les sollicitations du profilé UPN80 pour les combinaisons d'état limite ultime.

Entre deux entretoises la répartition des charges est la suivantes~:

Chaque entretoise reprend les charges appliquées à la surface dessinée en rouge sur le dessin ci-dessus.

Ainsi, le chargement d'une entretoise a le profil trapézoïdal suivant~:

Avec q la charge uniformément répartie sur le platelage en kN/m^2;.

Pour la combinaison \[1.35 G + 1.50 GR1\]~:

- $p_("0_ELU")$ = 1.35 \*(0.0865+78.50\*0.005) + 1.50\*5.00 = 8.15 kN/ml

- $M_("Ed")$ = $p_("0_ELU")$\*(3\*$L^2$-4\*$a^2$)/24 = 8.15\*(3\*1.50^2-4\*0.50^2)/24 = 1.95 kN.m

- $V_("Ed")$ = $p_("0_ELU")$/2\*(L-a) = 8.15/2\*(1.50-0.50) = 4.08 kN

On constate que~:

- $V_("Ed")$ = 4.08 kN \< $V_("pl, Rd")$;/2 \< $V_("pl, Rd")$ = 69.20 kN
ainsi, $M_("c, Rd")$ #strong[\=] $M_("pl, Rd")$
#strong[#underline[Vérifié~!];]

- $M_("Ed")$ = 1.95 kN.m \< $M_("c, Rd")$ = 6.23 kN.m
#strong[#underline[Vérifié~!];]

On calcule ci-après les contraintes dans l'entretoise à l'état limite ultime~:

- $sigma_("x, Ed")$ = $M_("Ed")$;/$W_("pl")$ = 1.95e3/250e-6 = 7.8 MPa

- $tau_("Ed")$ = sqrt3\*($V_("Ed")$;/$A_v$;) = sqrt3\*4.08e3/5.1e-4 = 13.9 MPa

- $sigma_("Ed")$ = sqrt($sigma_("x, Ed")$;^2 + 3\* $tau_("Ed")$;^2;) =
sqrt(7.8^2 + 3\*13.9^2) = 25.3 MPa

- $sigma_("Ed")$;/$f_y$;/$gamma_("M0")$ = 25.3/235/1.0 = 0.11 \< 1.0
#strong[#underline[Vérifié !];]

On calcule ci-après la flèche d'une entretoise pour la combinaison ELS \[1.00 G +1.00 GR1\]~:

- $p_("ELS")$ = 1.00\*(0.0865+78.50\*0.005) + 1.00\*5.00 = 5.48 kN/ml

- $f_("ELS")$ = $p_("ELS")$;/(1920\*E\*I)\*(5\*$L^2$-4\*$a^2$)^2 =
5.48e3/(1920\*210e9\*106e-8)\*(5\*1.50^2- 4\*0.50^2)^2

\= 0.13 mm = #strong[L/11539]

== Platelage tôle 5mm
<platelage-tôle-5mm>
Pour ces vérifications, la tôle est considérée comme une appuyée simplement sur quatre appuis entre les entretoises et les poutres porteuses. On détermine ci-après les caractéristiques mécaniques de la tôle pour cette géométrie.

I = b\*$e^3$/12 = 100\*0.5^3/12 = 1.04 cm^4

$W_("el")$ = I/v = b\*$e^2$/6 = 100\*0.5^2/6 = 4.17 cm^3

$A_v$ = b\*e = 100\*0.5 = 50 cm^2

On détermine ci-après le moment de flexion résistant $M_("c, Rd")$;, ainsi que l'effort de cisaillement résistant $V_("c, Rd")$ de la tôle.

- Moment de flexion résistant~: $M_("c, Rd")$ = $M_("el, Rd")$ =
$W_("el")$;\*$f_y$;/$gamma_("M0")$ = 4.17\*235/1.0 = 0.98 kN.m

- Effort de cisaillement résistant~: $V_("pl, Rd")$ =
$A_v$;\*($f_y$;/sqrt3)/$gamma_("M0")$ = 50\*(235e2/sqrt3)/1.0 = 678.4 kN

si $V_("Ed")$ \> $V_("pl, Rd")$;/2 alors $M_("c, Rd")$ = (1-rho)\*M_("pl, Rd") avec rho = (2\*$V_("Ed")$;/$V_("pl, Rd")$ - 1)^2 sinon M_("c, Rd") = $M_("pl, Rd")$

Pour la combinaison \[1.35 G + 1.50 GR1\]~:

- $p_("ELU")$ = 1.35 \*(78.50\*0.005) + 1.50\*5.00 = 8.03 kN/ml

- $M_("Ed, x")$ = beta\*$p_("ELU")$;\*a^2 = 0.0812\*8.03\*1.00^2 =
0.65 kN.m

\_$V_("Ed, x")$ = gamma\*$p_("ELU")$;\*a = 0.424\*0.65\*1.00 = 0.28 kN

Les coefficients beta et gamma sont extraits d'un formulaire de RDM pour une plaque dont le ration longueur largeur vaut 1.5, simplement appuyées sur ses quatre bords et soumise à une charge uniformément répartie.

- $V_("Ed")$ = 0.28 kN \< $V_("pl, Rd")$;/2 \< $V_("pl~,Rd")$ = 678.4 kN
ainsi, $M_("c, Rd")$ #strong[\=] $M_("pl, Rd")$
#strong[#underline[Vérifié~!];]

- $M_("Ed")$ = 0.65 kN.m \< $M_("c, Rd")$ = 0.98 kN.m
#strong[#underline[Vérifié~!];]

On calcule ci-après les contraintes dans la tôle à l'état limite ultime~:

- $sigma_("x, Ed")$ = $M_("Ed")$;/$W_("el")$ = 0.65e3/4.17e-6 = 155.9 MPa

- $tau_("Ed")$ = sqrt3\*($V_("Ed")$;/$A_v$;) = sqrt3\*0.28e3/50e-4 = 0.1 MPa

- $sigma_("Ed")$ = sqrt($sigma_("x, Ed")$;^2 + 3\* $tau_("Ed")$;^2;) =
sqrt(155.9^2 + 3\*0.1^2) = 155.9 MPa

- $sigma_("Ed")$;/$f_y$;/$gamma_("M0")$ = 155.9/235/1.0 = 0.66 \< 1.0
#strong[#underline[Vérifié !];]

On calcule ci-après la flèche de la tôle pour la combinaison ELS \[1.00 G +1.00 GR1\]~:

On considère la tôle comme une plaque (1.50m\*1.00m~; b/a=1.50) articulée sur quatre côtés pour le calcul de la flèche.

- $p_("ELS")$ = 1.00\*(78.50\*0.005) + 1.00\*5.00 = 5.39 kN/ml

- $f_("ELS")$ = -alpha\*$p_("ELS")$;\*$a^4$/(E\*$e^3$) =
0.0843\*5.39e3\*1.0^4/(200e9\*0.005^3)

\= 17mm = L/59

= Conclusion
<conclusion>
Il apparaît que les poutres porteuses de la passerelle sont légèrement sous dimensionnées par rapport aux hypothèses retenues sur la qualité de l'acier.

On rappelle les principaux résultats dans le tableau suivant~:

#figure(
 align(center)[#table(
 columns: (12.66%, 13.4%, 10.9%, 13.84%, 12.2%, 15.32%, 10.22%, 11.46%),
 align: (center,center,center,center,center,center,center,center,),
 table.header([], table.cell(align: center, colspan: 2)[Flexion], table.cell(align: center, colspan: 2)[Cisaillement], table.cell(align: center, colspan: 2)[Contraintes], table.cell(align: center, rowspan: 2)[Taux de travail],
 [], [$M_("Ed")$
 \[kN.m\]], [$M_("c, Rd")$

 \[kN.m\]

 ], [$V_("Ed")$

 \[kN\]

 ], [$V_("c, Rd")$

 \[kN\]

 ], [$sigma_("x, Ed")$

 \[MPa\]

 ], [$tau_("Ed")$

 \[MPa\]

 ],),
 table.hline(),
 [Poutres porteuses IPN 200], [55.6], [58.8], [77.8], [217.5], [259.8], [48.5], [116%],
 [Entretoises UPN 80 ], [1.95], [6.23], [4.08], [69.2], [7.8], [13.9], [11%],
 [Platelage Tôle 5mm ], [0.65], [0.98], [0.28], [678.4], [155.9], [0.1], [66%],
 )]
 , kind: table
 )

Bien que les poutres porteuses soient suffisamment résistantes pour reprendre les efforts appliqués aux ELU, la vérification en contrainte n'est pas satisfaisante au droit de l'appui n°2.

Les vérifications des entretoises et du platelage quant à elles sont satisfaisantes.$ $