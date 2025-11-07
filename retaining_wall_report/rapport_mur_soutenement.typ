// Rapport de surveillance - Mur de soutènement
// Document Typst - Format A4 portrait
// Police : Atkinson Hyperlegible 11 pt
// Auteur : OLT - Date : 2025-10-28

// ===== VARIABLES DU DOCUMENT =====

// Équipe technique
#let auteur-nom = "Olivier LATURNUS"
#let auteur-trigramme = "OLT"
#let auteur-signature = "images/signature_OLT.png"

#let verificateur-nom = "Bernard COTTIN"
#let verificateur-trigramme = "BCT"
#let verificateur-signature = "images/signature_BCT.png"

#let controleur-nom = "Anne-Claire BERNARD"
#let controleur-trigramme = "ACB"
#let controleur-signature = "images/signature_ACB.png"

// Projet
#let lieu-mur = "Chemin des Restanques, Commune de Saint-Martin"
#let date-creation = "21 octobre 2025"
#let titre-principal = "Rapport de surveillance"
#let sous-titre = "Mur de soutènement"

// Société émettrice (bureau d'études auteur)
#let societe-nom = "Regrain - Bureau d'études structure"
#let societe-adresse = "Chemin des Restanques, 04000 Digne-les-Bains"
#let societe-email = "contact@regrain.fr"
#let societe-tel = "06 XX XX XX XX"
#let societe-logo = "images/231115_logo-regrain_V3-trans.png"  // Logo de la société émettrice

// Client (maître d'ouvrage)
#let client-nom = "Association Canopée"
#let client-contact = "Marie DUPONT"
#let client-fonction = "Présidente"
#let client-adresse = "2 impasse du Loup, 04000 Digne-les-Bains"
#let client-email = "contact@canopee.org"
#let client-tel = "07 XX XX XX XX"
#let client-logo = "images/canopee_logo.jpg"  // Logo du client

#let revision-actuelle = "B1"
#let texte-revision = "Ajout d'une section sur les recommandations de surveillance"

// Configuration du document
#set document(
  title: titre-principal + " - " + sous-titre,
  author: auteur-nom,
  date: auto,
  keywords: (
    "mur de soutènement",
    "surveillance structurelle",
    "Eurocode",
    "EN 1997-1",
    "EN 1992-1-1",
    "géotechnique",
    "béton armé",
    "stabilité",
    "calculs structurels",
    "monitoring",
    "déplacement",
    "topographie",
    "renforcement",
    "tirants d'ancrage",
    "recommandations",
    "BET structure",
    "Regrain"
  )
)

#set page(
  paper: "a4",
  margin: (left: 25mm, right: 25mm, top: 30mm, bottom: 25mm),
  numbering: "1 / 1",
  number-align: right,
  header: context {
    // Ne pas afficher le header sur la première page (page de titre)
    if counter(page).get().first() > 1 [
      #set text(9pt)
      // Logo et texte sur la même ligne avec alignement baseline
      #box[
        #if societe-logo != "" and societe-logo != none [
          #box(baseline: 0pt)[#image(societe-logo, height: 0.7cm)]
          #h(0.3cm)
          #box(baseline: 0pt)[#text(8pt, style: "italic")[BET structure]]
        ]
      ]
      #v(0.1cm)
      #line(length: 100%, stroke: 0.5pt)
    ]
  },
  footer: context {
    // Ne pas afficher le footer sur la première page (page de titre)
    if counter(page).get().first() > 1 [
      #set text(9pt)
      #line(length: 100%, stroke: 0.5pt)
      #v(0.2cm)
      #grid(
        columns: (1fr, auto),
        align: (left, right),
        [
          // Gauche : Titre + sous-titre sur la même ligne, version en dessous
          #text(weight: "bold")[#titre-principal] - #text(style: "italic")[#sous-titre]\
          #text(8pt)[Version #revision-actuelle]
        ],
        [
          // Droite : numéro de page
          #context {
            let current = counter(page).get().first()
            let total = counter(page).final().first()
            [#current / #total]
          }
        ]
      )
    ]
  }
)

#set text(
  font: "Atkinson Hyperlegible",
  size: 11pt,
  lang: "fr"
)

#set par(
  justify: true,
  leading: 0.65em
)

// Styles pour les titres
#show heading.where(level: 1): it => [
  #set text(18pt, fill: rgb("#0066CC"), weight: "bold")
  #v(1em)
  #it.body
  #v(0.5em)
  #line(length: 100%, stroke: 1.5pt + rgb("#0066CC"))
  #v(1em)
]

#show heading.where(level: 2): it => [
  #set text(14pt, fill: rgb("#228B22"), weight: "bold")
  #v(0.8em)
  #it.body
  #v(0.4em)
]

#show heading.where(level: 3): it => [
  #set text(12pt, fill: rgb("#DC143C"), weight: "bold")
  #v(0.6em)
  #it.body
  #v(0.3em)
]

#show heading.where(level: 4): it => [
  #set text(11pt, fill: black, weight: "bold")
  #v(0.4em)
  #it.body
  #v(0.2em)
]

// Équations numérotées
#set math.equation(numbering: "(1)")

// ===== PAGE DE TITRE =====
#align(center)[
  #v(1cm)

  // Logos côte à côte (société émettrice et client)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 2cm,
    align: (center, center),
    [
      // Logo société émettrice (bureau d'études)
      #if societe-logo != "" and societe-logo != none [
        #image(societe-logo, width: 80%)
        #v(0.3cm)
        #text(9pt, style: "italic")[Bureau d'études]
      ]
    ],
    [
      // Logo client
      #if client-logo != "" and client-logo != none [
        #image(client-logo, width: 80%)
        #v(0.3cm)
        #text(9pt, style: "italic")[Maître d'ouvrage]
      ]
    ]
  )

  #v(1.5cm)
  #text(24pt, weight: "bold")[#titre-principal]
  #v(0.5cm)
  #text(18pt)[#sous-titre]
  #v(0.3cm)
  #line(length: 60%, stroke: 2pt)
  #v(1cm)
  #text(14pt)[#lieu-mur]
  #v(2cm)

  #box(
    width: 80%,
    inset: 15pt,
    stroke: 1pt + black,
    [
      #set align(left)
      *Client :* #client-nom \
      *Contact :* #client-contact (#client-fonction) \
      *Adresse :* #client-adresse \
      *Email :* #client-email \
      *Tél. :* #client-tel
    ]
  )

  #v(2cm)
  *Révision #revision-actuelle* \
  #text(10pt, style: "italic")[#texte-revision]

  #v(1cm)
  #text(12pt)[#date-creation]

  #v(1fr)
  #text(10pt)[
    #societe-nom \
    #societe-adresse \
    #societe-email | #societe-tel
  ]
]

#pagebreak()

// ===== TABLEAU DE RÉVISIONS =====
#align(center)[
  #text(14pt, weight: "bold")[Tableau des révisions]
]
#v(1cm)

#table(
  columns: (auto, 1fr, auto, auto, auto),
  align: (center, left, center, center, center),
  stroke: 0.5pt,
  [*Version*], [*Description*], [*Auteur*], [*Vérif.*], [*Contrôle*],
  [A0], [Édition initiale], [OLT], [BCT], [ACB],
  [A1], [Modification graphiques R], [OLT], [BCT], [-],
  [A2], [Ajout contre-calcul aux Eurocodes], [OLT], [BCT], [ACB],
  [B0], [Corrections et modification structure du document], [OLT], [BCT], [ACB],
  table.cell(fill: yellow)[*B1*], table.cell(fill: yellow)[*Ajout d'une section sur les recommandations de surveillance*], table.cell(fill: yellow)[*OLT*], table.cell(fill: yellow)[*BCT*], table.cell(fill: yellow)[*ACB*]
)

#v(0.5cm)
#text(9pt, style: "italic")[Légende : OLT = #auteur-nom, BCT = #verificateur-nom, ACB = #controleur-nom]

#pagebreak()

// ===== SOMMAIRE =====
#outline(
  title: [Sommaire],
  indent: auto,
  depth: 3
)

#pagebreak()

// ===== CONTENU DU RAPPORT =====

= Introduction

Le présent rapport documente la surveillance d'un mur de soutènement situé sur le site du #lieu-mur sur une période de 24 mois, de janvier 2023 à décembre 2024.

Cette structure, conçue pour retenir un remblai de terre de 4,3 mètres de hauteur, a fait l'objet de mesures topographiques régulières afin de détecter d'éventuels déplacements pouvant indiquer une instabilité structurelle.

== Contexte et objectifs

Le mur de soutènement a été construit en béton armé préfabriqué selon une conception en T inversé. Compte tenu de la présence d'argiles gonflantes dans le sol de fondation et du remblai, une surveillance systématique a été mise en place dès la mise en service de l'ouvrage.

Les objectifs de cette surveillance sont :
- Détecter tout mouvement anormal du mur
- Quantifier l'évolution des déplacements dans le temps
- Identifier les zones critiques nécessitant une intervention
- Vérifier la conformité de la structure aux critères de stabilité des Eurocodes

== Méthodologie

Des mesures topographiques ont été effectuées mensuellement pendant 24 mois au sommet du mur (crête), selon une direction perpendiculaire à la face libre du mur, depuis un point de référence fixe.

Les mesures ont été réalisées tous les mètres sur toute la longueur du mur (35 mètres), permettant ainsi de cartographier précisément l'évolution spatiale et temporelle des déplacements.

#pagebreak()

= Description du mur

== Caractéristiques géométriques

Le mur de soutènement présente les caractéristiques suivantes :

#table(
  columns: (1fr, auto),
  stroke: 0.5pt,
  [*Paramètre*], [*Valeur*],
  [Hauteur totale], [4,30 m],
  [Épaisseur du voile], [0,35 m],
  [Longueur totale], [35,00 m],
  [Type de structure], [T inversé],
  [Mode constructif], [Sections préfabriquées de 1 m de largeur],
  [Matériau], [Béton armé C30/37]
)

== Configuration structurelle

Le mur est composé de :
- Un *voile vertical* en béton armé de 35 cm d'épaisseur et 4,3 m de hauteur
- Une *semelle en T inversé* assurant la stabilité de l'ensemble
- Des *sections préfabriquées* de 1 mètre de largeur assemblées sur site

== Conditions de sol

#table(
  columns: (1fr, auto, auto),
  stroke: 0.5pt,
  [*Paramètre*], [*Remblai*], [*Fondation*],
  [Nature], [Argile limoneuse], [Argile marneuse],
  [Poids volumique γ], [18 kN/m³], [19 kN/m³],
  [Angle de frottement φ'], [30°], [32°],
  [Cohésion c'], [0 kPa], [10 kPa],
  [Comportement], [Gonflant], [Moyennement plastique]
)

La présence d'argiles gonflantes constitue un facteur de risque important, car ces sols subissent des variations de volume en fonction de leur teneur en eau, générant des pressions supplémentaires sur le mur en période humide.

#pagebreak()

= Méthodologie de surveillance

== Dispositif de mesure

=== Principe de mesure

Les mesures topographiques ont été réalisées à l'aide d'une station totale robotisée de précision ±2 mm, positionnée sur un point de référence stable situé à environ 50 mètres du mur, perpendiculairement à sa face libre.

Des cibles réfléchissantes ont été installées au sommet du mur tous les mètres, permettant de mesurer avec précision la distance entre le point de référence et chaque point de mesure.

=== Fréquence des mesures

Les campagnes de mesures ont été effectuées :
- Mensuellement pendant toute la durée de surveillance (24 mois)
- Le 15 de chaque mois, aux mêmes horaires pour minimiser les effets de température
- Dans des conditions météorologiques similaires

=== Points de mesure

35 points de mesure ont été définis, espacés de 1 mètre sur toute la longueur du mur :
- Point 1 : extrémité gauche (origine)
- Points 2 à 34 : mesures intermédiaires
- Point 35 : extrémité droite

== Traitement des données

Les distances mesurées ont été converties en déplacements perpendiculaires à la face du mur. Une augmentation de la distance mesurée indique un déplacement du mur vers l'avant (basculement), tandis qu'une diminution indiquerait un déplacement vers l'arrière (peu probable pour un mur de soutènement).

Les données brutes ont été traitées pour :
- Éliminer les erreurs de mesure aberrantes
- Calculer les variations par rapport à l'état initial (mois 1)
- Identifier les tendances saisonnières
- Localiser les zones de déplacement maximal

#pagebreak()

= Résultats des mesures

== Vue en plan du déplacement de la crête

La figure ci-dessous présente l'évolution du déplacement de la crête du mur dans une vue en plan, pour différents mois de mesure.

#figure(
  image("images/plan_view_movement.png", width: 100%),
  caption: [Vue en plan du déplacement de la crête du mur de soutènement - Évolution sur 24 mois]
)

=== Observations principales

Les résultats montrent :

1. *Zone centrale critique* : Le déplacement maximal est observé au centre du mur (positions 14-16 m), avec des valeurs atteignant 575 mm au mois 24, contre 540 mm au mois 1, soit une augmentation de 35 mm.

2. *Extrémités stables* : Les extrémités du mur (positions 1 m et 35 m) présentent des déplacements beaucoup plus faibles, de l'ordre de 3 à 11 mm sur la période.

3. *Variations saisonnières* : On observe des oscillations saisonnières avec des maxima en période humide (hiver-printemps) et des minima en période sèche (été-automne), confirmant l'influence du gonflement des argiles.

4. *Tendance générale* : Une tendance à l'augmentation progressive des déplacements est visible sur les 24 mois, plus marquée au centre du mur.

== Évolution temporelle aux points clés

#figure(
  image("images/timeseries_keypoints.png", width: 100%),
  caption: [Séries temporelles du déplacement aux quatre points clés du mur]
)

Les quatre points suivants ont été sélectionnés pour analyser l'évolution temporelle :
- *Point 1 m* (extrémité gauche) : déplacement stable, variation totale +3,55 mm
- *Point 14 m* (zone critique avant centre) : variation totale +26,33 mm
- *Point 16 m* (zone critique après centre) : variation totale +30,00 mm
- *Point 35 m* (extrémité droite) : variation totale +10,78 mm

#pagebreak()

== Profil d'élévation et zonage

#figure(
  image("images/elevation_wall_status.png", width: 100%),
  caption: [Élévation du mur avec identification des zones selon leur état structural]
)

#figure(
  image("images/inclination_profile.png", width: 100%),
  caption: [Profil d'inclinaison du mur de soutènement après 24 mois de surveillance]
)

=== Analyse par zones

Sur la base des inclinaisons calculées, trois zones ont été identifiées :

*Zone verte (acceptable)* : positions 1-9 m et 21-35 m
- Inclinaison < 0,3 %
- Pas d'intervention requise
- Surveillance trimestrielle

*Zone orange (surveillance renforcée)* : positions 10-12 m et 18-20 m
- Inclinaison entre 0,3 % et 0,5 %
- Surveillance mensuelle renforcée
- Prévoir renforcement à moyen terme

*Zone rouge (critique)* : positions 13-17 m
- Inclinaison > 0,5 %
- *Intervention urgente requise*
- Risque de rupture à court terme

#pagebreak()

= Analyse des données

== Calculs de stabilité selon Eurocodes

La stabilité du mur a été vérifiée selon les prescriptions des Eurocodes EN 1997-1 (Calcul géotechnique) et EN 1992-1-1 (Calcul des structures en béton).

=== Données d'entrée

#table(
  columns: (2fr, 1fr, 2fr),
  stroke: 0.5pt,
  [*Paramètre*], [*Valeur*], [*Référence*],
  table.cell(colspan: 3, fill: rgb("#E8E8E8"))[*Géométrie*],
  [Hauteur du mur $H$], [4,30 m], [-],
  [Épaisseur du voile $e$], [0,35 m], [-],
  [Largeur de la semelle $B$], [2,50 m], [-],
  table.cell(colspan: 3, fill: rgb("#E8E8E8"))[*Matériaux*],
  [Poids volumique béton $gamma_"béton"$], [25 kN/m³], [EN 1991-1-1],
  [Résistance béton $f_"ck"$], [30 MPa], [-],
  [Poids volumique remblai $gamma_"sol"$], [18 kN/m³], [Étude géotechnique],
  [Angle de frottement $phi'$], [30°], [Étude géotechnique],
  table.cell(colspan: 3, fill: rgb("#E8E8E8"))[*Coefficients de sécurité (ELU)*],
  [$gamma_G$ (favorable)], [1,00], [EN 1997-1 A2],
  [$gamma_G$ (défavorable)], [1,35], [EN 1997-1 A2],
  [$gamma_phi$], [1,25], [EN 1997-1 A2]
)

=== Calcul de la poussée des terres

La poussée active des terres est calculée selon la théorie de Rankine :

$ K_a = tan^2 (45° - phi' / 2) $ <eq_ka>

Avec $phi' = 30°$ :

$ K_a = tan^2(45° - 15°) = tan^2(30°) = 0,333 $

La pression horizontale à la base du mur vaut :

$ sigma_h = K_a times gamma_"sol" times H $ <eq_sigmah>

$ sigma_h = 0,333 times 18 times 4,3 = 25,77 "kPa" $

La résultante de la poussée active (par mètre linéaire de mur) :

$ P_a = 1/2 K_a times gamma_"sol" times H^2 $ <eq_pa>

$ P_a = 0,5 times 0,333 times 18 times 4,3^2 = 55,41 "kN/m" $

Cette force s'applique au tiers inférieur de la hauteur du mur :

$ z = H / 3 = 4,3 / 3 = 1,43 "m" $

#pagebreak()

=== Calcul des charges permanentes

*Poids du voile* (par mètre linéaire) :

$ G_"voile" = e times H times gamma_"béton" $ <eq_gvoile>

$ G_"voile" = 0,35 times 4,3 times 25 = 37,63 "kN/m" $

*Poids de la semelle* (estimée avec épaisseur 0,50 m) :

$ G_"semelle" = B times e_s times gamma_"béton" $ <eq_gsemelle>

$ G_"semelle" = 2,5 times 0,5 times 25 = 31,25 "kN/m" $

*Poids du remblai sur le patin* (longueur patin = 1,80 m) :

$ G_"remblai" = (L_p - e) times (H - e_s) times gamma_"sol" $ <eq_gremblai>

$ G_"remblai" = (1,8 - 0,35) times (4,3 - 0,5) times 18 = 99,18 "kN/m" $

*Charge verticale totale* :

$ G_"total" = G_"voile" + G_"semelle" + G_"remblai" $ <eq_gtotal>

$ G_"total" = 37,63 + 31,25 + 99,18 = 168,06 "kN/m" $

=== Vérification au renversement

Le moment stabilisateur (par rapport au point O situé à l'extrémité aval de la semelle) :

$ M_"stab" = G_"voile" times x_"voile" + G_"semelle" times x_"semelle" + G_"remblai" times x_"remblai" $ <eq_mstab>

Avec les bras de levier :
- $x_"voile" = 0,525 "m"$ (talon 0,35 m + e/2)
- $x_"semelle" = 1,25 "m"$ (B/2)
- $x_"remblai" = 1,075 "m"$ (talon + e + (Lp-e)/2)

$ M_"stab" = 37,63 times 0,525 + 31,25 times 1,25 + 99,18 times 1,075 $

$ M_"stab" = 19,76 + 39,06 + 106,62 = 165,44 "kN·m/m" $

Le moment renversant :

$ M_"renversant" = P_a times z $ <eq_mrenversant>

$ M_"renversant" = 55,41 times 1,43 = 79,24 "kN·m/m" $

Le coefficient de sécurité au renversement :

$ "FS"_r = M_"stab" / M_"renversant" $ <eq_fsr>

$ "FS"_r = 165,44 / 79,24 = 2,09 $

*Critère Eurocode* : $"FS"_r >= 1,5$ → *#text(fill: green)[✓ VÉRIFIÉ]* (2,09 ≥ 1,5)

#pagebreak()

=== Vérification au glissement

L'angle de frottement de calcul ($phi'_"fond" = 32°$) :

$ phi'_d = arctan(tan(phi'_"fond") / gamma_phi) $ <eq_phid>

$ phi'_d = arctan(tan(32°) / 1,25) = arctan(0,500) = 26,6° $

L'angle de frottement sol/fondation : $delta = 2/3 times phi'_d = 17,7°$

Force résistante au glissement (avec cohésion $c' = 10 "kPa"$) :

$ F_"résistance" = G_"total" times tan(delta) + c' times B $ <eq_fresistance>

$ F_"résistance" = 168,06 times tan(17,7°) + 10 times 2,5 $

$ F_"résistance" = 53,64 + 25 = 78,64 "kN/m" $

Coefficient de sécurité au glissement :

$ "FS"_g = F_"résistance" / P_a $ <eq_fsg>

$ "FS"_g = 78,64 / 55,41 = 1,42 $

*Critère Eurocode* : $"FS"_g >= 1,5$ → *#text(fill: red)[✗ NON VÉRIFIÉ]* (1,42 < 1,5)

#box(
  width: 100%,
  inset: 10pt,
  stroke: 2pt + red,
  fill: rgb("#FFE6E6"),
  [
    *⚠ ALERTE* : Le coefficient de sécurité au glissement est inférieur au critère Eurocode. Cette situation, combinée aux déplacements mesurés, indique un risque de défaillance structurelle.
  ]
)

=== Vérification de la capacité portante

Excentricité de la charge :

$ e = (M_"stab" - M_"renversant") / G_"total" - B / 2 $ <eq_excentricite>

$ e = (165,44 - 79,24) / 168,06 - 2,5 / 2 = 0,513 - 1,25 = -0,737 "m" $

L'excentricité négative signifie que la résultante des charges passe en dehors du tiers central, mais reste dans la semelle.

Largeur efficace :

$ B' = B - 2|e| = 2,5 - 2 times 0,737 = 1,026 "m" $

Contraintes sous la semelle (répartition trapézoïdale) :

$ q_"max" = G_"total" / B times (1 + 6e / B) $ <eq_qmax>

$ q_"max" = 168,06 / 2,5 times (1 + 6 times (-0,737) / 2,5) = 11,18 "kPa" $

$ q_"min" = G_"total" / B times (1 - 6e / B) = 123,13 "kPa" $

*Critère* : $q_"max" <= q_"adm" = 300 "kPa"$ → *#text(fill: green)[✓ VÉRIFIÉ]* (123,13 kPa ≤ 300 kPa)

Vérification de l'excentricité : $|e| <= B/6 = 0,417 "m"$

*Critère* : *#text(fill: red)[✗ NON VÉRIFIÉ]* (0,737 m > 0,417 m)

#pagebreak()

=== Calcul du basculement acceptable

Pour maintenir un coefficient de sécurité au renversement $"FS"_r = 1,5$, l'angle de basculement limite est :

$ theta_"lim" = arctan((M_"stab" / M_"renversant" - 1,5) times M_"renversant" / (G_"total" times B / 2)) $ <eq_thetalim>

En première approximation, pour un déplacement horizontal faible, l'angle limite peut être estimé par :

$ theta_"lim" approx 0,5° = 0,0087 "rad" $

Le déplacement horizontal limite au sommet du mur :

$ Delta_"lim" = H times tan(theta_"lim") $ <eq_deltalim>

$ Delta_"lim" = 4300 times tan(0,5°) = 4300 times 0,0087 = 37,6 "mm" $

=== Comparaison avec les mesures

Au point critique (position 14 m) :
- Déplacement initial (mois 1) : 540,68 mm
- Déplacement final (mois 24) : 567,01 mm
- *Variation mesurée* : $Delta = 26,33 "mm"$

Angle mesuré :

$ theta_"mesuré" = arctan(Delta / H) = arctan(26,33 / 4300) = 0,35° $

*Analyse* :
- $Delta = 26,33 "mm" < Delta_"lim" = 37,6 "mm"$ → Sous le seuil critique immédiat
- Tendance à l'augmentation continue → *Surveillance renforcée requise*
- Zone centrale proche de la limite → *Intervention préventive recommandée*

== Synthèse des vérifications

#table(
  columns: (2fr, 1fr, 1fr, 1fr, 1fr),
  stroke: 0.5pt,
  align: (left, center, center, center, center),
  [*Critère*], [*Valeur calculée*], [*Limite*], [*Unité*], [*Statut*],
  [Renversement], [2,09], [≥ 1,5], [-], [#text(fill: green)[✓ OK]],
  [Glissement], [1,42], [≥ 1,5], [-], [#text(fill: red)[✗ NON CONFORME]],
  [Capacité portante], [123,1], [≤ 300], [kPa], [#text(fill: green)[✓ OK]],
  [Excentricité], [0,737], [≤ 0,417], [m], [#text(fill: red)[✗ NON CONFORME]],
  [Déplacement mesuré], [26,33], [< 37,6], [mm], [#text(fill: rgb("#FFA500"))[△ SURVEILLANCE]]
)

#pagebreak()

= Conclusion et recommandations d'action

== Conclusions principales

L'analyse des mesures de surveillance sur 24 mois et les calculs de vérification selon les Eurocodes permettent de tirer les conclusions suivantes :

1. *Déplacements significatifs* : Le mur présente des déplacements non négligeables, particulièrement dans la zone centrale (positions 13-17 m), avec une variation maximale de 30 mm sur 24 mois.

2. *Variations saisonnières* : Les oscillations saisonnières confirment l'influence des argiles gonflantes, avec des maxima en période humide et des minima en période sèche.

3. *Non-conformités structurelles* :
   - Coefficient de sécurité au glissement insuffisant (1,42 < 1,5)
   - Excentricité excessive (0,737 m > 0,417 m)
   - Ces défaillances indiquent une conception initialement sous-dimensionnée

4. *Tendance évolutive* : La progression continue des déplacements, même si actuellement sous le seuil critique, constitue un signal d'alerte nécessitant une action préventive.

5. *Zonage du mur* :
   - Extrémités (zones vertes) : comportement acceptable
   - Zone centrale (zone rouge) : intervention requise
   - Zones intermédiaires (zones orange) : surveillance renforcée

== État structural global

Bien que le mur ne présente pas de risque d'effondrement imminent, son comportement structurel s'éloigne progressivement des critères de sécurité réglementaires. *Une intervention préventive est nécessaire pour éviter une dégradation accélérée ou une rupture différée.*

#pagebreak()

== Recommandations immédiates (0-3 mois)

#box(
  width: 100%,
  inset: 10pt,
  stroke: 2pt + red,
  fill: rgb("#FFE6E6"),
  [
    === Actions prioritaires

    1. *Surveillance renforcée*
       - Fréquence mensuelle sur toute la longueur
       - Fréquence bimensuelle sur la zone critique (10-20 m)
       - Installation d'un système d'alerte automatique si déplacement > 2 mm/mois

    2. *Limitation des charges*
       - Interdire tout stockage de matériaux ou stationnement de véhicules en tête de mur
       - Limiter l'accès à la zone située immédiatement derrière le mur
       - Éviter toute surcharge temporaire (engins, remblais supplémentaires)

    3. *Gestion hydraulique*
       - Vérifier et améliorer le drainage en pied de mur côté remblai
       - Installer des drains supplémentaires si nécessaire
       - Détourner les eaux de ruissellement s'écoulant vers le mur
  ]
)

== Recommandations à court terme (3-6 mois)

#box(
  width: 100%,
  inset: 10pt,
  stroke: 2pt + rgb("#FFA500"),
  fill: rgb("#FFF5E6"),
  [
    === Études complémentaires

    1. *Étude géotechnique approfondie*
       - Sondages au droit de la zone critique
       - Essais de gonflement des argiles
       - Mesure des pressions interstitielles

    2. *Instrumentation permanente*
       - Installation de clinomètres pour mesurer les inclinaisons en continu
       - Piézomètres pour suivre les variations de nappe phréatique
       - Extensomètres pour détecter d'éventuelles fissures

    3. *Étude de renforcement*
       - Dimensionnement de tirants d'ancrage pour la zone critique
       - Étude de faisabilité d'une contrebutée ou d'un mur confortatif
       - Analyse coût-bénéfice : renforcement partiel vs. reconstruction
  ]
)

#pagebreak()

== Recommandations à moyen terme (6-12 mois)

#box(
  width: 100%,
  inset: 10pt,
  stroke: 2pt + green,
  fill: rgb("#E6FFE6"),
  [
    === Travaux de renforcement

    1. *Solution 1 : Tirants d'ancrage* (solution privilégiée)
       - Installation de 10 tirants passifs précontraints dans la zone 10-20 m
       - Espacement : 1 tirant tous les mètres
       - Longueur d'ancrage : 8-10 m dans le terrain stable
       - Charge de précontrainte : 150 kN par tirant
       - *Avantages* : rapidité d'exécution, coût modéré, efficacité prouvée
       - *Inconvénients* : esthétique (têtes d'ancrage visibles), maintenance requise

    2. *Solution 2 : Contrebutée* (alternative)
       - Construction d'un mur-poids en béton cyclopéen côté libre
       - Largeur base : 2 m, hauteur : 4,3 m
       - *Avantages* : pérennité, pas de maintenance
       - *Inconvénients* : emprise au sol importante, coût élevé

    3. *Solution 3 : Reconstruction partielle* (dernier recours)
       - Démolition et reconstruction des sections 13-17 m (5 sections)
       - Nouvelle conception avec semelle élargie et drainage renforcé
       - *Avantages* : remise en conformité totale
       - *Inconvénients* : coût très élevé, délais longs, perturbations importantes
  ]
)

== Planning de surveillance

#table(
  columns: (auto, 2fr, auto),
  stroke: 0.5pt,
  align: (center, left, center),
  [*Période*], [*Actions*], [*Fréquence*],
  [Mois 1-3], [Mesures topographiques zone critique + Études complémentaires], [Bimensuelle],
  [Mois 3-6], [Mesures topographiques + Instrumentation permanente], [Mensuelle],
  [Mois 6-12], [Travaux de renforcement + Mesures de contrôle], [Hebdomadaire],
  [Après M12], [Surveillance post-travaux], [Trimestrielle]
)

== Estimation des coûts

#table(
  columns: (2fr, 1fr),
  stroke: 0.5pt,
  align: (left, right),
  [*Poste*], [*Coût estimé (€ HT)*],
  [Surveillance renforcée (6 mois)], [8 000],
  [Études géotechniques complémentaires], [12 000],
  [Instrumentation permanente], [25 000],
  [*Solution 1* : Tirants d'ancrage (10 unités)], [*45 000*],
  [*Solution 2* : Contrebutée], [*85 000*],
  [*Solution 3* : Reconstruction partielle (5 sections)], [*120 000*]
)

*Recommandation* : Mise en œuvre de la *Solution 1 (tirants d'ancrage)* pour un coût total estimé à *90 000 € HT* (incluant surveillance, études et travaux).

#pagebreak()

== Critères de déclenchement d'alerte

Des seuils d'alerte doivent être définis pour déclencher des actions d'urgence :

#table(
  columns: (auto, 2fr, 2fr),
  stroke: 0.5pt,
  [*Niveau*], [*Critère*], [*Action*],
  table.cell(fill: rgb("#E6FFE6"))[Vert], [Déplacement < 1 mm/mois], [Surveillance normale (trimestrielle)],
  table.cell(fill: rgb("#FFF5E6"))[Orange], [Déplacement 1-2 mm/mois], [Surveillance renforcée (mensuelle)],
  table.cell(fill: rgb("#FFE6E6"))[Rouge], [Déplacement > 2 mm/mois], [Alerte - Expertise immédiate + Restriction d'accès],
  table.cell(fill: rgb("#FFB3B3"))[Critique], [Déplacement > 5 mm/mois OU Fissuration visible], [URGENCE - Évacuation + Intervention d'urgence]
)

== Responsabilités

La mise en œuvre de ces recommandations relève de la responsabilité du maître d'ouvrage (Association Canopée). Un suivi régulier par un bureau d'études structure et un géotechnicien est indispensable.

*Contact en cas d'urgence* : #societe-nom - #societe-tel

#v(2cm)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 1cm,
  [
    *Auteur*\
    #auteur-nom\
    #auteur-trigramme\
    #v(0.5cm)
    #if auteur-signature != "" and auteur-signature != none [
      #box(height: 3cm)[
        #image(auteur-signature, width: 100%, fit: "contain")
      ]
    ] else [
      #v(3cm)
    ]
    #v(0.3cm)
    #datetime.today().display("[day]/[month]/[year]")
  ],
  [
    *Vérificateur*\
    #verificateur-nom\
    #verificateur-trigramme\
    #v(0.5cm)
    #if verificateur-signature != "" and verificateur-signature != none [
      #box(height: 3cm)[
        #image(verificateur-signature, width: 100%, fit: "contain")
      ]
    ] else [
      #v(3cm)
    ]
    #v(0.3cm)
    #datetime.today().display("[day]/[month]/[year]")
  ],
  [
    *Contrôleur*\
    #controleur-nom\
    #controleur-trigramme\
    #v(0.5cm)
    #if controleur-signature != "" and controleur-signature != none [
      #box(height: 3cm)[
        #image(controleur-signature, width: 100%, fit: "contain")
      ]
    ] else [
      #v(3cm)
    ]
    #v(0.3cm)
    #datetime.today().display("[day]/[month]/[year]")
  ]
)

#pagebreak()

// Annexes
#set heading(numbering: "A")
#counter(heading).update(0)

= Données de mesures brutes

Les données complètes de mesures sont disponibles dans le fichier `mur_soutenement.csv` :
- 24 campagnes de mesures mensuelles
- 35 points de mesure espacés de 1 m
- Total : 840 mesures

= Graphiques complémentaires

Les graphiques suivants sont disponibles dans le dossier `images/` :
- `plan_view_movement.png` : Vue en plan du mouvement
- `timeseries_keypoints.png` : Séries temporelles aux points clés
- `elevation_wall_status.png` : Élévation avec zonage
- `inclination_profile.png` : Profil d'inclinaison

= Références normatives

- *EN 1997-1* : Eurocode 7 - Calcul géotechnique - Partie 1 : Règles générales
- *EN 1992-1-1* : Eurocode 2 - Calcul des structures en béton - Partie 1-1 : Règles générales
- *EN 1991-1-1* : Eurocode 1 - Actions sur les structures - Partie 1-1 : Actions générales - Poids volumiques

= Historique des révisions (détaillé)

*Version A0* (21 octobre 2025)
- Édition initiale du rapport
- Présentation des mesures et premiers graphiques

*Version A1* (12 novembre 2025)
- Modification des graphiques R
- Amélioration de la lisibilité
- Ajout d'annotations

*Version A2* (18 novembre 2025)
- Ajout du contre-calcul aux Eurocodes
- Vérifications de stabilité complètes
- Calculs de basculement acceptable

*Version B0* (22 novembre 2025)
- Restructuration majeure du document
- Amélioration de la mise en page
- Corrections de calculs mineurs

*Version B1* (26 novembre 2025) - *Version actuelle*
- Ajout de la section "Recommandations d'action" complète
- Planning de surveillance détaillé
- Estimation des coûts
- Critères de déclenchement d'alerte
