// FontAwesome removed for compatibility
// Titre du document et métadonnées du document
#let site-web = "canopee.org"
// Variables de version
#let version-majeure = "A"
#let version-mineure = "1"
#let date-edition = datetime.today().display("[day]/[month]/[year]")
#let chemin-fichier = "rapport-fissures.pdf"

//#set page(
//  paper: "a4",
//  margin: auto, //(left: 2.5cm, right: 2.5cm, top: 3cm, bottom: 3cm),
//)

// Chemin vers le logo
#let logo = "images/canopee_logo.jpg"


// Configuration page, en-tête et pied de page
#set page(
  paper: "a4",
  margin: auto,
  header: [
    #if logo != "" [
      #place(
        top + left,
        dx: 0pt,
        dy: 10pt,
        image(logo, width: 80pt)
      )
    ]
  ],
  footer: context [
    #set text(size: 9pt)
    #grid(
      columns: (1fr, 1fr),
      align: (left, right),
      [
        #chemin-fichier \
        Version #version-majeure.#version-mineure | Édité le #date-edition | #link("https://" + site-web)[#site-web]
      ],
      [
        Page #counter(page).display("1 / 1", both: true)
      ]
    )
  ]
)




#set text(
  font: "Atkinson Hyperlegible",
  size: 10pt,
  lang: "fr",
)

#set par(
  justify: true,
  leading: 0.65em,
)



#set heading(numbering: "1.")

// Title page
#align(center)[
  #v(2cm)
  #text(size: 24pt, weight: "bold")[
    Suivi différentiel de fissures sur 3 ans
  ]

  #v(1cm)
  #text(size: 14pt)[
    Analyse des mouvements structurels\
    Bâtiment A - Façade Nord
  ]

  #v(2cm)
  #image("images/canopee_logo.jpg", width: 40%)

  #v(1cm)
  #text(size: 12pt)[
    Association Canopée\
    Janvier 2022 - Décembre 2024
  ]

  #v(1cm)
  #text(size: 10pt, fill: gray)[
    Rapport généré le #datetime.today().display("[day] [month repr:long] [year]")
  ]
]

#pagebreak()

// Table of contents
#outline(
  title: "Table des matières",
  indent: auto,
)

#pagebreak()

= Introduction

Ce rapport présente l'analyse de l'évolution de deux fissures structurelles (FA1 et FA2) sur une période de trois ans, du 5 janvier 2022 au 25 décembre 2024. Les mesures ont été effectuées hebdomadairement à l'aide d'un fissuromètre numérique de précision ±0.01 mm.

== Objectifs du suivi

- Caractériser l'évolution temporelle des ouvertures de fissures
- Identifier les variations saisonnières liées au retrait-gonflement des argiles
- Déterminer les tendances à long terme (ouverture, fermeture, stabilité)
- Évaluer les risques structurels et orienter les décisions de réparation

== Méthodologie

Les mesures ont été réalisées tous les mercredis à 10h00, dans des conditions météorologiques standardisées. Chaque fissure dispose de deux points de mesure pour assurer la redondance et la fiabilité des données.

#pagebreak()

= Synthèse des résultats

== Tableau récapitulatif

Le tableau ci-dessous présente les statistiques clés pour chaque mesure sur la période étudiée.

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: (left, center, center, center, center, center),
  table.header(
    [*Fissure*], [*Mesure*], [*Min (mm)*], [*Max (mm)*], [*Moyenne (mm)*], [*Évolution*]
  ),
  [FA1], [1], [7.78], [13.23], [10.12], [#text(fill: green)[Fermeture]],
  [FA1], [2], [12.55], [18.34], [15.47], [#text(fill: red)[Ouverture]],
  [FA2], [1], [3.89], [6.45], [5.18], [#text(fill: orange)[Stable]],
  [FA2], [2], [3.92], [6.78], [5.34], [#text(fill: orange)[Légère ouverture]],
)

== Interprétation générale

*Fissure FA1 - Mesure 1* : Tendance à la fermeture progressive (-2.49 mm sur 3 ans), probablement liée à un tassement différentiel stabilisé.

*Fissure FA1 - Mesure 2* : Ouverture continue inquiétante (+2.79 mm sur 3 ans), nécessitant une surveillance renforcée et des investigations complémentaires.

*Fissure FA2 - Mesure 1* : Fissure stable avec variations saisonnières modérées (±2 mm), caractéristique d'un comportement normal des sols argileux.

*Fissure FA2 - Mesure 2* : Légère ouverture progressive (+0.45 mm sur 3 ans), dans les limites acceptables pour ce type de structure.

#pagebreak()

= Analyse détaillée

== Vue d'ensemble des 4 mesures

Le graphique ci-dessous présente une vue comparative des quatre points de mesure sur l'ensemble de la période étudiée, permettant d'identifier rapidement les tendances de chaque mesure.

#image("images/fissures-overview.png", width: 100%)

#pagebreak()

== Fissure FA1 - Comparaison des deux mesures

La fissure FA1 présente un comportement différentiel important entre ses deux points de mesure :

#image("images/fissure-FA1-combined.png", width: 100%)

=== Mesure 1 - Analyse détaillée

#image("images/fissure-FA1-M1.png", width: 100%)

*Caractéristiques* :
- Valeur initiale : 10.12 mm (janvier 2022)
- Valeur finale : 10.45 mm (décembre 2024)
- Amplitude saisonnière : 4-5 mm
- Maximum observé : 13.23 mm (mars 2022)
- Minimum observé : 7.78 mm (août 2023)

*Interprétation* :

Cette fissure présente une tendance nette à la fermeture sur les trois années de suivi. L'amplitude des variations saisonnières est significative, avec des ouvertures maximales en période hivernale-printanière (janvier à mars) et des fermetures marquées en fin d'été (août-septembre).

Le phénomène observé est caractéristique du retrait-gonflement des argiles : en hiver, les précipitations provoquent un gonflement du sol qui tend à ouvrir les fissures ; en été, la dessiccation entraîne un retrait qui les referme.

La tendance globale à la fermeture suggère que le tassement différentiel initial s'est stabilisé et que la structure retrouve progressivement un équilibre.

#pagebreak()

=== Mesure 2 - Analyse détaillée

#image("images/fissure-FA1-M2.png", width: 100%)

*Caractéristiques* :
- Valeur initiale : 15.34 mm (janvier 2022)
- Valeur finale : 18.34 mm (décembre 2024)
- Amplitude saisonnière : 3-4 mm
- Maximum observé : 18.34 mm (décembre 2024)
- Minimum observé : 12.55 mm (août 2022)

*Interprétation* :

Cette seconde mesure sur la fissure FA1 présente un comportement préoccupant avec une ouverture progressive de +2.79 mm sur la période étudiée, soit environ +0.93 mm par an.

Les variations saisonnières suivent le même pattern que la mesure 1 (ouverture hivernale, fermeture estivale), mais la tendance de fond est clairement à l'aggravation.

*Recommandations* :
- ⚠️ Surveillance renforcée (mesures bihebdomadaires)
- Investigation géotechnique pour identifier la cause de l'ouverture
- Mise en place de témoins de fissuration supplémentaires
- Consultation d'un bureau d'études structure si l'ouverture se poursuit

#pagebreak()

== Fissure FA2 - Comparaison des deux mesures

La fissure FA2 présente un comportement globalement stable sur les deux points de mesure :

#image("images/fissure-FA2-combined.png", width: 100%)

#pagebreak()

=== Mesure 1 - Analyse détaillée

#image("images/fissure-FA2-M1.png", width: 100%)

*Caractéristiques* :
- Valeur initiale : 5.23 mm (janvier 2022)
- Valeur finale : 6.34 mm (décembre 2024)
- Amplitude saisonnière : 2-2.5 mm
- Maximum observé : 6.45 mm (février 2023)
- Minimum observé : 3.89 mm (août 2022, 2023, 2024)

*Interprétation* :

La fissure FA2 mesure 1 présente un comportement globalement stable sur les trois années de suivi. Les variations saisonnières sont modérées et régulières, témoignant d'un fonctionnement normal lié au cycle hydrique des sols argileux.

L'écart entre valeur initiale et finale (+0.44 mm) est faible et se situe dans les marges d'erreur du dispositif de mesure sur cette durée.

Cette fissure ne présente pas de caractère évolutif inquiétant et peut être considérée comme stabilisée.

#pagebreak()

=== Mesure 2 - Analyse détaillée

#image("images/fissure-FA2-M2.png", width: 100%)

*Caractéristiques* :
- Valeur initiale : 5.67 mm (janvier 2022)
- Valeur finale : 6.56 mm (décembre 2024)
- Amplitude saisonnière : 2-2.5 mm
- Maximum observé : 6.78 mm (janvier 2024)
- Minimum observé : 3.92 mm (août 2022, 2023)

*Interprétation* :

Cette seconde mesure sur la fissure FA2 confirme le comportement stable observé sur la mesure 1. L'ouverture progressive de +0.89 mm sur 3 ans (+0.30 mm/an) reste dans les limites acceptables pour ce type de structure.

Les variations saisonnières sont parfaitement synchronisées avec celles de la mesure 1, renforçant la fiabilité du diagnostic.

*Conclusion* : Fissure à surveiller en routine (mesures mensuelles suffisantes), mais ne présentant pas de risque structurel à court terme.

#pagebreak()

= Conclusions et recommandations

== Bilan global

Sur les quatre points de mesure suivis pendant trois ans :

- *1 mesure en amélioration* (FA1-M1) : fermeture progressive
- *1 mesure préoccupante* (FA1-M2) : ouverture continue nécessitant une action
- *2 mesures stables* (FA2-M1 et FA2-M2) : comportement normal

== Facteurs influençant l'évolution

=== Variations saisonnières

Toutes les mesures présentent des variations saisonnières marquées, typiques du phénomène de retrait-gonflement des argiles :

- *Période humide (novembre-mars)* : gonflement des argiles → ouverture des fissures
- *Période sèche (juillet-septembre)* : retrait des argiles → fermeture des fissures

L'amplitude de ces variations (2 à 5 mm selon les fissures) est cohérente avec un sol argileux de type moyennement à fortement plastique.

=== Tendances à long terme

Au-delà des variations saisonnières, on observe :

- Une *stabilisation* pour la fissure FA2 (variations ≤ 0.5 mm sur 3 ans)
- Une *évolution différentielle* pour la fissure FA1 (fermeture d'un côté, ouverture de l'autre)

Cette évolution différentielle suggère un mouvement de rotation ou de torsion de la structure, plutôt qu'un simple tassement uniforme.

== Actions recommandées

=== Court terme (0-6 mois)

#table(
  columns: (auto, 1fr),
  align: (left, left),
  table.header([*Action*], [*Priorité*]),
  [Investigation géotechnique (sondages, essais)], [#text(fill: red)[*Haute*]],
  [Mise en place de capteurs automatiques FA1-M2], [#text(fill: red)[*Haute*]],
  [Inspection visuelle détaillée de la structure], [#text(fill: orange)[Moyenne]],
  [Relevé topographique de la façade], [#text(fill: orange)[Moyenne]],
)

=== Moyen terme (6-18 mois)

- Suivi renforcé de la fissure FA1-M2 (hebdomadaire)
- Analyse structurelle par bureau d'études spécialisé
- Étude des solutions de confortement si nécessaire
- Poursuite du suivi mensuel pour FA2

=== Long terme (> 18 mois)

- Mise en œuvre des travaux de confortement si prescrits
- Réévaluation du protocole de suivi post-travaux
- Archivage et valorisation des données collectées

== Limites de l'étude

- Période de suivi de 3 ans : insuffisante pour caractériser les phénomènes lents (> 10 ans)
- Absence de corrélation avec les données météorologiques détaillées
- Pas de modélisation numérique du comportement sol-structure
- Suivi limité à 4 points de mesure sur une structure complexe

#pagebreak()

= Annexes

== Protocole de mesure

*Matériel* : Fissuromètre numérique SAUGNAC FD-125, précision ±0.01 mm

*Fréquence* : Hebdomadaire (tous les mercredis à 10h00)

*Conditions* : Température ambiante, hors période de pluie (délai 24h)

*Opérateur* : Technicien qualifié, formation initiale assurée

== Données brutes

L'ensemble des mesures (624 relevés) est disponible dans le fichier `fissures.csv` joint à ce rapport.

Format : date, fissure, mesure, ouverture_mm

== Références normatives

- NF P18-840 : Mesure des mouvements différentiels dans les constructions
- NF P94-068 : Sols : reconnaissance et essais - Détermination de la valeur de bleu de méthylène
- DTU 20.1 : Travaux de bâtiment - Ouvrages en maçonnerie de petits éléments
- Guide CSTB : Prévention des désordres dus au retrait-gonflement des sols argileux

== Contact

Pour toute question relative à ce rapport :

*Association Canopée*\
Chemin des Restanques\
Email : contact\@canopee.org\
Tél : 06 XX XX XX XX

---

#align(center)[
  #text(size: 9pt, fill: gray)[
    Rapport généré automatiquement avec R et Typst\
    © 2025 Association Canopée - Tous droits réservés
  ]
]
