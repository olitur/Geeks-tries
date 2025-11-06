// Document converti depuis DOCX avec Pandoc
// Post-traité pour Typst

// Métadonnées du document
#set document(
  title: "24Mauzac Diag Pile Rg",
  author: "Auteur",
  date: datetime.today()
)

// Configuration de la page (A4, marges automatiques, français)
#set page(
  paper: "a4",
  margin: auto,
  header: align(right)[
    #text(size: 9pt, fill: gray)[24Mauzac_DIAG_Pile-RG.pdf]
  ],
  footer: align(center)[
    #context [
      #text(size: 9pt)[
        #counter(page).display("1/1", both: true)
      ]
    ]
  ]
)

// Configuration du texte (Atkinson Hyperlegible prioritaire, Arial et polices actuelles en fallback, 11pt)
#set text(
  font: ("Atkinson Hyperlegible", "Arial", "Liberation Sans", "DejaVu Sans"),
  size: 11pt,
  lang: "fr",
  region: "FR"
)

// Configuration des paragraphes
#set par(
  justify: true,
  first-line-indent: 0pt
)

// Configuration de la numérotation des sections (1, 1.1, 1.1.1, 1.1.1.a)
#set heading(numbering: "1.1.1.a")

// Configuration des titres
#show heading.where(level: 1): set text(size: 18pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 12pt, weight: "bold")

// Configuration des liens
#show link: set text(fill: blue)
#show link: underline

EDF PETITE HYDRO

GEH DORDOGNE

MAUZAC

\24. Barrage de Mauzac \
Pile RG transbordeur à batardeaux

#strong[DIAGNOSTIC GÉNIE-CIVIL]

#figure(image("media/image1.jpeg", width: 80%),
  caption: [Pile RG vue depuis la berge, en amont de l'ouvrage]
)

#figure(
  align(center)[#table(
    columns: (55.53%, 22.21%, 22.26%),
    align: (auto,auto,auto,),
    table.header([N° rapport], [Indice], [Date],),
    table.hline(),
    [], [A0-PREL], [Juin 2021],
  )]
  , kind: table
  )

Ce document est la seule propriété d'HYDROSTADIUM, il ne peut être
modifié ou diffusé à des tiers sans autorisation écrite préalable.

/ Define globally (in your style.typ)
#let th(content) = table.cell(
  fill: gray.lighten(80%),
  align: center + horizon,
  [#strong[#content]]
)

#show table: it => {
  set text(hyphenate: false)
  it
}


#strong[Tableau de suivi de révision :]
// #table(
//     columns: (10.89%, 26.02%, 13.36%, 16.58%, 16.58%, 16.58%),
//     align: (auto,auto,auto,auto,auto,auto,),
//     table.header([Indice], [Objet succinct de la
//       révision], [Date], [Rédacteur], [Vérificateur], [Approbateur],),
//     table.hline(),
//     [A0-PREL], [Édition initiale], [28/06/2021], [Olivier
//     TURLIER], [Cécile POULY], [Vincent LABETOULE],
//     table.cell(align: right, colspan: 3)[Signatures], [], [], [],
// )
#table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: left,
    stroke: 1pt + luma(50%),
    inset: .5em,
    table.header(
      [#th[Indice]],
      [#th[Objet succinct de la révision]],
      [#th[Date]],
      [#th[Rédacteur]],
      [#th[Vérificateur]],
      [#th[Approbateur]]),
    table.cell(align: center + horizon, [*A0-PREL*]),
    [Édition initiale], [28/06/2021], [Olivier
    TURLIER], [Cécile POULY], [Vincent LABETOULE],
    table.cell(align: right, colspan: 3)[Signatures], [], [], [],
    table.cell(align: left, colspan: 2)[Objet de la révision], table.cell(align: left, colspan: 4)[Sans objet à ce stade de l'étude _édition initiale_],
)

// Section: = Généralités
#pagebreak(weak: true)
#outline(
  depth: 2,
  title: "Sommaire"
)

#pagebreak()


#pagebreak(weak: true)
= Généralités
<généralités>
== Type de Mission confiée
<type-de-mission-confiée>
La mission confiée est une expertise de type DIAG+PRECOS.

Cette expertise inclut les éléments suivants~:

- DIAG~:

  - Analyse du besoin

  - Analyse des données d'entrée

  - Visite sur site~:

    - Inspection visuelle détaillée

    - Auscultations~: tests de fissuration et de carbonatation

    - Mesures dimensionnelles

    - Photographies

    - Repérage pour carottages

  - Prestation externe~:

    - Carottages~: 3 emplacements x 8 unités = 24 carottes

    - Suspicion RGI#footnote[RGI~: Réaction de Gonflement Interne];~(=
      suspicion RAG#footnote[RAG~: Réaction Alcali-Granulat] ou
      RSI#footnote[RSI~: Réaction Sulfatique Interne];) :

      - Analyse minéralogique

      - Analyse pétrographique

      - Détection des gels d'alcali-réaction

    - Mesure de la classe de résistance à la compression

    - Mesure de la porosité

  - Rapport de diagnostic, incluant les conclusions de la recherche de
    RGI

    - Constats

    - Avis (suspicion RGI oui/non, état général)

    - Pronostic

  - Dossier photos

  - Plan, coupes et façades

- PRECOS

  - Préconisations surs les actions à mener à court, moyen et long terme
    (maintenance corrective)

    - Surveillance de l'ouvrage~: périodicité

    - Travaux de réfection à minima (maintien en conditions
      opérationnelles)

  - Maintenance préventive~:

    - Besoin oui/non fonction avis de diag

    - Travaux extensifs (rénovation importante)

== Objet de la mission
<objet-de-la-mission>
- Investiguer la possibilité d'une réaction type «~RGI^1;~»
  (Réaction de Gonflement Interne du béton) pour donner suite au constat
  d'une fissuration assez prononcée, constat réalisé lors de la dernière
  VTA (2018).

- Évaluer l'impact de ces altérations sur la tenue structurelle de
  l'ouvrage

== Données d'entrée
<données-dentrée>
=== Documents EDF/HSM
<documents-edfhsm>
#block[
#set enum(numbering: "1.", start: 1)
+ Expression des besoins (= lettre accompagnement VTA)~: \
  Pile RG : suspicion RGI =\> carottage analyse labo \
  #emph[HSM-24-MAUZAC VTA GC BARRAGE 2018-Lettre d\'envoi-A-]

+ VTA 2018 : \
  #emph[HSM-24-MAUZAC VTA GC BARRAGE 2018-A]

+ VTA 2014 : \
  #emph[IH\_TA-COBA\_VTAGC-MAUZAH\_00001\_A]

+ Inspection-diagnostic DTG 2012 : \
  #emph[2012\_DIAG AUSCULTATION\_D4179RAP2012-10315-A]
]

=== Normes, règlements & guides
<normes-règlements-guides>
- Méthode LCPC mesure indice de fissuration

  #block[
  #set enum(numbering: "1.", start: 5)
  + LCPC : Méthode d'essai N°47 (1997) -- #emph[indice de fissuration
    --]
  ]

  #block[
  #set enum(numbering: "1.", start: 5)
  + LCPC : Méthode suivi dimensionnel et de suivi de la fissuration des
    structures -- application aux structures atteintes de réaction de
    gonflement interne du béton (2009)
  ]

- Méthode mesure profondeur carbonatation

  #block[
  #set enum(numbering: "1.", start: 5)
  + IFFSTAR (nouveau LCPC) : fiche B2-2 (2015)

  + NF EN 14630

  + XP 18-458
  ]

- Méthodes auscultations et analyses du béton durci

  #block[
  #set enum(numbering: "1.", start: 5)
  + Carottage béton~: fiche A1-1 (IFFSTAR)

  + Diagnostic d'une RGI~: fiche D1-3 (IFFSTAR)

  + Détection RAG~: fiche A1-4 (IFFSTAR)

  + Analyse minéralogique du béton~: fiche A1-2 (IFSTAR)

  + Analyse pétrographique du béton~: fiche A1-3 (IFSTAR)

  + Détection des gels d'alcali-réaction par Fluorescence des ions
    uranyl~: fiche A1-4 (IFSTAR)

  + Recommandations pour la prévention des désordres dus à la réaction
    sulfatique interne~: IFFSTAR (2017)
  ]

== Contenu de la mission
<contenu-de-la-mission>
=== Analyse du dossier de l'ouvrage
<analyse-du-dossier-de-louvrage>
Recherche de tous indices pouvant amener à la suspicion de RGI

=== Visite sur site
<visite-sur-site>
#strong[Prestations];~:

- Visite sur site de l'ouvrage, inspection visuelle détaillée

- Auscultations~:

  - Martelage

  - Profondeur de carbonatation

  - Indice de fissuration

- Photographies

- Mesures et contrôles dimensionnels

=== Rapport de diagnostic et préconisations
<rapport-de-diagnostic-et-préconisations>
#strong[Livrables];~:

- Rapport (DIAG+PRECOS)

- Dossier photo

// Section: = Présentation de l'ouvrage
#pagebreak(weak: true)
= Présentation de l'ouvrage
<présentation-de-louvrage>
== Aménagement
<aménagement>
L'aménagement de Mauzac est situé sur la Dordogne à 30 km à l'amont de
la ville de Bergerac (24). Il a été mis en service en 1924. Cette
centrale dépend du Groupe d'Exploitation Hydraulique Dordogne situé sur
le territoire de l'Unité de Production Centre.

#figure(
  align(center)[#table(
    columns: (100%),
    align: (auto,),
    table.header([#image("media/image3.jpg", width: 80%)

      Figure 2 : Implantation de l\'aménagement de Mauzac

      ],),
    table.hline(),
  )]
  , kind: table
  )

L'aménagement comporte un barrage mobile de 300 m de longueur et 6,07 m
de hauteur (classe C), un canal d'amenée et une usine hydroélectrique.
Le canal et l'usine sont implantés sur la rive gauche de la Dordogne. Le
barrage de Mauzac est de classe C

#figure(
  align(center)[#table(
    columns: (100%),
    align: (auto,),
    table.header([#image("media/image4.jpg", width: 80%)

      Figure 3 : Barrage et usine de Mauzac, vue aérienne

      ],),
    table.hline(),
  )]
  , kind: table
  )

== Ouvrage diagnostiqué
<ouvrage-diagnostiqué>
=== Localisation
<localisation>
La pile RG est située 20 m en retrait du plan d'eau sur la berge RG.

Elle constitue l'extrémité du pont transbordeur, ouvrage métallique de
type treillis servant à manipuler les batardeaux d'obturation du canal
usinier.

#figure(
  align(center)[#table(
    columns: (100%),
    align: (auto,),
    table.header([#image("media/image5.jpg", width: 80%)

      Figure 4 : localisation de la Pile RG et visualisation des
      batardeaux -- sur la droite de l'image

      ],),
    table.hline(),
  )]
  , kind: table
  )

=== Fonction
<fonction>
Culée d'appui d'un ouvrage métallique servant à gruter les batardeaux de
leurs positions de stockage (éléments linéaires gris foncé visibles à
droite sur la Figure 4) sur la berge jusque dans leurs rainures pour
isoler la tête du canal d'amenée.

=== Description & repérage des faces
<description-repérage-des-faces>
Ouvrage en béton armé enduit et peint constitué de 2 pieds-droits
surmontés d'un chevêtre massif. Une ouverture centrale laisse passer les
batardeaux. La terrasse sommitale, en forme de fer à cheval, n'est pas
protégée contre les venues d'eau (absence d'étanchéité).

C'est le chevêtre qui fait office de culée car il reçoit les appuis des
poutres métalliques (appui sans glissement et scellement en plein)

Les dimensions approximatives de l'ouvrage, issues du relevé
dimensionnel sur site, sont les suivantes~:

#figure(
  align(center)[#table(
    columns: (50.01%, 49.99%),
    align: (center,auto,),
    table.header([#figure(
  #image("media/image6.jpg", width: 80%),
  caption: [perspective amont côté berge RG]
)

      ], [#figure(
  #image("media/image7.jpg", width: 80%),
  caption: [perspective aval côté Dordogne, \]
)
      appuis de la culée du pont transbordeur visibles

      ],),
    table.hline(),
    [#figure(
  #image("media/image8.png", width: 80%),
  caption: [plan-coupe des pied-droits \@+1m/TN]
)

    ], table.cell(rowspan: 2)[#figure(
  #image("media/image9.png", width: 80%),
  caption: [coupe axiale sur chevêtre]
)

    ],
    [#figure(
  #image("media/image10.png", width: 80%),
  caption: [plan terrasse supérieure, avec trace des pied-droits.]
)

    ],
  )]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: (50.01%, 49.99%),
    align: (center,center,),
    table.header([#image("media/image11.jpeg", width: 80%)

      Figure 10 : Pile RG → élévation coté Dordogne/retenue du plan
      d'eau, vue depuis l'amont

      ], [#image("media/image12.jpeg", width: 80%)

      Figure 11 : Pile RG → élévation coté Dordogne/retenue du plan
      d'eau, vue depuis l'aval

      ],),
    table.hline(),
    [#image("media/image13.jpeg", width: 80%)

    Figure 12 : scellement de la structure métallique dans le
    chevêtre/culée de la pile RG. Vue depuis l'amont, coté Dordogne

    ], [#image("media/image14.jpeg", width: 80%)

    Figure 13 : scellement de la structure métallique dans le
    chevêtre/culée de la pile RG. Vue depuis l'aval, coté Dordogne

    ],
  )]
  , kind: table
  )

// Section: = Diagnostic
#pagebreak(weak: true)
= Diagnostic
<diagnostic>
== Analyse du dossier de l'ouvrage
<analyse-du-dossier-de-louvrage-1>
#strong[Période de réalisation];~: \
Construction dans les années 1920 -- maîtrise technique avérée de
construction d'ouvrages en béton armé, même sans l'application
systématique de normes, encore balbutiantes à l'époque :

- 1914~: béton armé (Le Corbusier)

- 1920~: poutres BA «~minces~» en arcs (Ateliers confection Esders --
  Paris)

- Etc.

- L'ouvrage a donc $approx$ 100 ans

- Le REX que l'on possède sur ces ouvrages construits à ces périodes est
  que le béton est généralement de très bonne qualité (il est courant de
  rencontrer des résistances en compression de l'ordre de 50 Mpa)

- La RSI n'apparaît que plus tard, lorsque les moyens de bétonnage en
  grande quantités apparaissent

#strong[Règles pour éviter la formation de RSI dans le béton];~neuf : \
Selon la publication \[REF 16\], pour déterminer le niveau de prévention
nécessaire vis-à-vis de la RSI pour un ouvrage neuf est un indicateur de
ce qu'il ne faut pas faire si l'on cherche à éviter ce phénomène. Dans
notre cas (ouvrage existant ancien, cela sert de guide pour vérifier si
les situations à risque pouvant provoquer la RSI ont été rencontrées)~:

- #underline[Catégorie ouvrage] -- 3 catégories représentatives du
  niveau de risque vis-à-vis de la RSI que l'on est prêt à accepter pour
  un ouvrage~: \
  ⇒ #strong[catégorie II] (Conséquences peu tolérables)

- #underline[Classe d'exposition vis-à-vis de la RSI];~: 3 classes
  complémentaires XH1, XH2 et XH3 tiennent compte du fait que l'eau ou
  une hygrométrie ambiante élevée sont des facteurs nécessaires au
  développement de la RSI. Ces classes viennent en complément des 18
  classes d\'exposition définies dans la norme NF EN 206/CN. \
  ⇒ #strong[Classe XH2] (Alternance d'humidité et de séchage, humidité
  élevée)

- #underline[Niveaux de prévention] -- Il est fixé 4 niveaux de
  prévention désignés par les lettres As, Bs, Cs et Ds. La détermination
  du niveau de prévention se fait en fonction d'une part de la catégorie
  de l'ouvrage, et d'autre part de la classe d'exposition XH à laquelle
  est soumise la partie d'ouvrage considérée --

#figure(
  align(center)[#table(
    columns: (25.53%, 25.79%, 24.34%, 24.34%),
    align: (center,center,center,center,),
    table.header(table.cell(align: center, rowspan: 2)[#strong[Catégorie
      d'ouvrage];], table.cell(align: center, colspan: 3)[#strong[Classe
      d'exposition de la partie d'ouvrage];],
      [#strong[XH1];], [#strong[XH2];], [#strong[XH3];],),
    table.hline(),
    [I], [As], [As], [As],
    [II], [As], [#strong[Bs];], [Cs],
    [III], [As], [Cs], [Ds],
  )]
  , kind: table
  )

Le niveau de prévention vis-à-vis de la RSI est #strong[Bs];. \
⇒ le risque de désordre est atteint si~:

- La température maximale lors de la prise du béton doit rester
  inférieure à 75°C (la prise du béton est exothermique -- dégage de la
  chaleur -- surtout si le coulage est réalisé en grande quantités)

- Si la température ne peut pas rester inférieure à 75 °C, elle doit
  rester inférieure à 85°C et respecter 1 sur 6 conditions d'exécutions
  (détails~: voir doc. \[REF 16\])

Ne connaissant ni les détails d'exécution (coulage en grandes
quantités~? ni les caractéristiques des composants du béton (nature du
ciment, des agrégats, etc.) il n'est pas possible d'établir une
comparaison entre cet ouvrage d'antan et les prérequis modernes visant à
éviter la RSI.

== Inspection Détaillée
<inspection-détaillée>
=== Inspection visuelle sur site
<inspection-visuelle-sur-site>
==== Constats généraux
<constats-généraux>
#strong[Volumes/Équarrissage];~: \
L'ouvrage est de dimensions très généreuses pour sa fonction de
«~Culée~» d'un ouvrage métallique reprenant peu de charges (batardeaux
principalement, CMU 12 t). Une modélisation moderne -- respectueuse des
principes constructifs de l'ouvrage «~transbordeur~» dans son ensemble
-- réduirait certainement les dimensions du chevêtre et des pied-droits.
Cela indique -- au premier abord -- que les efforts encaissés par
l'ouvrage ont largement assez de matière pour transiter aux appuis sans
dépasser les contraintes admissibles du matériau béton armé
(caractérisation en prestation externe, voir le § 3.2.3.1)

#strong[Déformations];~: \
L'ouvrage ne souffre d'aucune déformation en plan (torsion, gonflement,
…) ou de déformations d'aplomb (absence de dévers, dans les directions
«~Y~» aval/amont et «~X~» berge/Dordogne#footnote[Mesure au fil à plomb
pour la verticalité];).

#strong[Parement];~: \
L'enduit de surface est plan et ne présente pas de gonflements. Il est
très compact (raide, voir le § 3.2.2.1) et ne présente aucun
décollement, du moins dans la superficie investiguée (pourtour de
l'ensemble des parements jusqu'à 2 m de hauteur)

#strong[Partie sommitale];~:

- La terrasse exposée aux aléas climatique est simplement revêtue d'un
  enduit béton nu. Elle comporte quelques fissures principalement
  causées par l'insertion d'éléments métalliques. Ces fissures
  n'intéressent que la couche superficielle (1 à 2 cm de profondeur
  maxi). Elles sont sans gravité pour la tenue mécanique.

- La corniche offrant une fonction décorative et de de rejet d'eau pour
  les parements verticaux est en moins bon état général. On constate des
  fissures et des éclats de béton intéressant en profondeur l'élément
  corniche. C'est la partie d'ouvrage la plus dégradée de l'ouvrage pile
  RG.

==== Faciès d'altération principaux
<faciès-daltération-principaux>
#strong[Fissuration];~: \
La dégradation principale est constituée par un empilement de fissures
sur toute la hauteur de l'ouvrage et l'ensemble des parements. Les
fissures les plus basses sont les plus remplies de calcite. Ces fissures
naissent (ouverture maximale) aux angles façade/pignon des pied-droits
et à la jonction avec le placage en pierre de taille. Elles ont une
direction proche de l'horizontale puis se propagent et divaguent vers le
centre de l'ouvrage. Il y a quelques fissures verticales qui collectent
préférentiellement l'eau de pluie et accumulent la calcite dans les
fissures horizontales qu'elles traversent. Leur profondeur n'intéresse
qu'une partie du parement~: sur les fissures d'ouverture maximale (1,2
mm), la profondeur n'était que de 16 mm, alors que l'épaisseur du
parement (enduit $eq.not$ béton) est estimée à 5 cm d'après les 2 sondages S1
et S2 réalisés sur site.

Ces fissures ne sont pas liées à des mouvements structurels de
l'ouvrage~(flexion à mi-portée, cisaillement aux appuis ou tassements
différentiels) :

- Absence d'implantation~:

  - Au droit des angles pied-droit / chevêtre

  - Au milieu du chevêtre

  - Vers les appuis du chevêtre

- Orientation~:

  - Non biaise (pas de fissure à 45°) aux angles pied-droit / chevêtre
    et vers les appuis du chevêtre (pas de cisaillement excessif)

  - Pas en «~X~» (pas de tassements différentiels)

  - Non verticale (pas de flexion excessive)

#figure(
  align(center)[#table(
    columns: (100%),
    align: (auto,),
    table.header([#image("media/image15.jpg", width: 80%)

      Figure 14 : pied-droit amont, façade F1 coté berge -\>
      soulignement (par croquis) de la fissuration principale. \
      Les bords externes de l'ouverture centrale sont habillés avec un
      placage en pierre de taille, plus tendre que l'enduit béton qui
      est très raide.

      ],),
    table.hline(),
  )]
  , kind: table
  )

L'origine de ces fissures semble plus provenir d'un phénomène mécanique
que d'un phénomène de RGI. En effet, la grande raideur de l'enduit ainsi
que sa forte cohésion avec le béton sous-jacent amènent à penser à des
fissures type retrait/dilatation contraint, soit au jeune âge (défaut de
cure juste après la réalisation) ou durant les 100 ans d'exposition aux
aléas. L'action des extrema climatiques (différentiels de température
$Delta$$theta$, gel/dégel) provoque à coup sûr des fissurations dans les enduits
très riches en liants.

La Figure 15 ci-dessous pourrait (au conditionnel car cela peut être un
autre facteur ou un ensemble d'autres facteurs) illustrer le processus
mécanique de dilatation/retrait amenant à la création d'une fissure, ce
processus perdurant au-delà de la création de la fissure en épaufrant
les bords à 45°.

#figure(
  align(center)[#table(
    columns: (100%),
    align: (auto,),
    table.header([#image("media/image16.jpeg", width: 80%)

      Figure 15 : focus sur une fissure aux bords chanfreinés (angle
      supérieur gauche du quadrillage réalisé pour mesurer l'indice de
      fissuration IF\#2 sur le parement F5 côté berge du pied-droit
      aval)

      ],),
    table.hline(),
  )]
  , kind: table
  )

#emph[NB~: ce constat préalable (fissuration par retrait gêné) sera
amendé à la lecture des conclusions de la recherche en laboratoire
prouvant ou non la présence d'un phénomène type RGI dans l'ouvrage.]

==== Faciès d'altération secondaires
<faciès-daltération-secondaires>
Les défauts mineurs sont associés aux fissures~: coulures de calcite,
éclats de béton ou épaufrures, salissures de façade~:

+ #strong[Calcite];~: \
  résulte d'un phénomène de création par la migration d'eau entraînant
  la chaux libre du béton qui elle-même précipite à l'extérieur du
  parement. Elle s'accumule en partie basse (plus de calcite en bas
  qu'en haut de l'ouvrage) car l'eau qui a pénétré en partie haute de
  l'ouvrage et qui migre par gravité vers le bas sans ressortir à
  l'extérieur peut dissoudre une plus grande quantité de chaux libre,
  celle-ci précipite donc en plus grande quantité en partie basse. Si la
  présence de calcite révèle la migration d'eau à l'intérieur de
  l'ouvrage et suppose une fissuration associée, elle n'augure en rien
  de la qualité intrinsèque de celui-ci, c'est un épiphénomène. La
  calcite peut simplement «~stocker~» de l'humidité à l'interface
  enduit/calcite.

+ #strong[Éclats de béton];~: \
  la corniche haute est fissurée. Ces fissures ont augmenté de volume,
  sans doute sous l'effet du gel. Cela a fini par créer des éclats, dont
  certains sont sévères. Ceux-ci sont localisés en face opposée au plan
  d'eau amont~: faut-il en déduire que le gel y a été plus intense~? La
  réalisation a pu souffrir d'une baisse de qualité à cet endroit ou le
  plan d'eau jouer un rôle de volant thermique diminuant les contrastes
  de température par rapport aux parements situés du côté berge RG.

+ #strong[Épaufrures];~: \
  2 épaufrures sont présentes en sous-face du chevêtre, laissant
  apparaître 2 armatures de forte section.

+ #strong[Salissures de façade];~: \
  des coulures noires sont axées au droit des irrégularités de la
  corniche, évacuant les matériaux recueillis par la terrasse sommitale.
  Il y en plus du côté de la Dordogne.

La peinture des parements verticaux est en fin de vie, ne serait-ce que
parce qu'elle est entaillée par les nombreuses fissures et recouverte
partiellement soit par de la calcite, soit par des salissures.

#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (center,center,),
    table.header([#image("media/image17.jpeg", width: 80%)

      Figure 16 : corniche côté berge/aval : éclats sévères de béton

      ], [#image("media/image18.jpeg", width: 80%)

      Figure 17 : épaufrure en sous-face du chevêtre, côté amont/berge

      ],),
    table.hline(),
    [#image("media/image19.jpeg", width: 80%)

    Figure 18 : pied-droit aval, angle coté berge : accumulation de
    calcite sur l\'arête et de salissures sur le parement le plus en
    aval.

    ], [#image("media/image20.jpeg", width: 80%)

    Figure 19 : pied-droit amont, angle coté berge : accumulation de
    calcite dans les fissures

    ],
  )]
  , kind: table
  )

=== Auscultations
<auscultations>
S'agissant de faciès d'altération intéressant le parement, il a été
décidé de déterminer la profondeur de carbonatation de l'enduit et de
caractériser l'importance de la fissuration.

==== Martelage dynamique
<martelage-dynamique>
Avant cela, toutes les surfaces accessibles de plain-pied (de $plus.minus$ 0,0 m /
TN à $plus.minus$ 2 m^h;) ont été martelées pour détecter d'éventuelles
zones décollées ou de compacité différente~: le rebond est important et
le son très clair partout. Encore une fois, cela indique un enduit de
grande compacité et parfaitement liaisonné au béton sous-jacent, sans
variation de qualité.

#emph[NB];~: #emph[cette auscultation n'a pas suivi la méthode utilisant
un scléromètre à rebond type marteau Schmidt ou un marteau d'impact
dynamique à capteur de force. Cela aurait permis de déterminer l'indice
I_sm et donc d'approcher la résistance en compression f_c du
béton.]

==== Carbonatation
<carbonatation>
2 tests de carbonatation du béton ont été effectués, suivant le
protocole décrit dans la fiche IFFSTAR \[REF 7\] (phénolphtaléine). \
#emph[NB~: La réalisation du trou au burin n'a pas été aisée car
l'enduit de parement est très compact.]

#figure(
  align(center)[#table(
    columns: (50.01%, 49.99%),
    align: (auto,auto,),
    table.header([#image("media/image21.jpeg", width: 80%)

      Figure 20 : test de carbonatation #strong[S1] sur la façade F1 : \
      #strong[5mm] max de carbonatation

      ], [#image("media/image22.jpeg", width: 80%)

      Figure 21 : test de carbonatation #strong[S2] sur la façade F5 : \
      #strong[10mm] max de carbonatation

      ],),
    table.hline(),
  )]
  , kind: table
  )

Les profondeurs de carbonatation obtenues sont très faibles pour cet
ouvrage de 100 ans~: 5mm et 10mm respectivement pour S1 et S2 (sur la
face f1 et f5 respectivement, voir le croquis Figure 7 pour le repérage
des faces).

==== Fissuration
<fissuration>
2 mesures de la fissuration ont été effectuées en appliquant la méthode
développée par le LCPC (IFFSTAR, voir \[REF 5\]). La mesure de
l'ouverture des fissures le long d'intervalles tracés sur des axes en
croix puis différentes sommes et moyennes amènent à déterminer la valeur
d'un indice de fissuration IF.

#figure(
  align(center)[#table(
    columns: (50%, 50%),
    align: (auto,auto,),
    table.header([#image("media/image23.jpeg", width: 80%)

      Figure 22 : IF\#2 sur pied-droit aval

      ], [#image("media/image24.jpeg", width: 80%)

      Figure 23 : IF\#1 sur pied-droit amont

      ],),
    table.hline(),
  )]
  , kind: table
  )

Les valeurs d'IF permettent de catégoriser la fissuration, de
négligeable à considérable (6 catégories^6;) et de décider ainsi
de la gravité et de l'urgence des réfections à effectuer.

Cette méthode statistique n'a de valeur que si elle est appliquée de
plusieurs fois et à intervalle réguliers pour estimer la cinétique
d'altération. Ici, comme il n'y a que 2 mesures d'IF, les valeurs
obtenues seront à prendre avec un recul inversement proportionnel à la
quantité d'échantillonnage.

Voir les détails des relevés et valeurs d'IF au § 5.1,
p.#link(<indice-de-fissuration-photos-feuilles-de-relevé-sur-site>)[23]

=== Recherche RGI (prestation externe)
<recherche-rgi-prestation-externe>
La preuve de l'existence d'alcali-réaction ou réaction sulfatique
interne ne peut être apportée que par une analyse en laboratoire sur
échantillons prélevés par carottage. Outre la recherche pure de présence
d'éléments concourant à l'expansion de la matrice cimentaire, il s'agit
de déterminer la nature des composants du béton comme de sa capacité de
résistance à la compression et de porosité.

En possession des conclusions de laboratoire statuant sur la suspicion
de présence de RGI, il sera alors possible de quantifier l'importance du
phénomène et de son impact sur la stabilité à court et à moyen terme sur
celui-ci.

==== Carottages
<carottages>
#strong[Il y a 2 types d'échantillons];~:

+ Les carottes destinées à la recherche de RGI → carottes $phi$ 100 x $ell$ 500
  mm (profondeur importante permettant de s'approcher du cœur de
  l'ouvrage)

+ Les carottes destinées à caractériser le béton → carottes $phi$ 100 x $ell$
  200 mm (élancement = 2)

#strong[Le nombre de carottes est déterminé comme suit];~:

- Détection de RGI : #underline[5 échantillons]

  - 2 échantillons pour analyses en laboratoire

  - 3 échantillons pour l'essai d'expansion résiduelle

- Détermination des caractéristiques mécaniques du béton~: #underline[3
  échantillons]

  - 2 échantillons pour test de compression (f_c;)

  - 1 échantillon pour détermination porosité

- Quantité totale~: 8 échantillons x 3 localisations = 24 carottes

  - 5 x 3 = #strong[15 carottes $phi$ 100 x $ell$ 500 mm]

  - 3 x 3 = #strong[9 carottes $phi$ 100 x $ell$ 200 mm]

#strong[La réalisation des carottages doit suivre ces principes];~:

- Détection des armatures (pachomètre, ferroscan, géoradar, …) pour
  éviter de carotter au droit des barres d'armature

- Marquage des carottages sur la paroi et photographie des marquages

- Confinement des carottages contre les attaques de l'air ambiant et de
  l'humidité, immédiatement après carottage, par enrubannage dans du
  cellophane et enfermement dans des sacs plastiques étanches, carotte
  par carotte.

- Identification reprenant la localisation et l'ordre. Comme il y 8
  carottages par face, cela donne pour la paroi F1 et la localisation C1
  : C1F1.01, C1F1.02, C1F1.03, …

- Rebouchage soigné au mortier à retrait compensé et lissage à l'arase
  du nu existant

==== Analyses en laboratoire
<analyses-en-laboratoire>
#strong[Pour chacun des 3 lots d'échantillons, il s'agira d'effectuer];~:

- Analyse minéralogique complète (voir fiche A1-2 / IFFSTAR)

- Analyse pétrographique (voir fiche A1-2 / IFFSTAR)

- Détection des gels d'alcali-réaction (voir fiche A1-4 / IFFSTAR --
  RAG) et d'ettringite (RSI)

- Mesure de la classe de résistance à la compression

- Mesure de la porosité

== Synthèse du diagnostic
<synthèse-du-diagnostic>
=== Fissuration
<fissuration-1>
Nous évoquons ci-dessous la fissuration du parement, origine du CEB
ayant abouti à cette expertise.

#strong[Causes];~: \
Elles peuvent être diverses, citons les principales causes possibles~:

- Retrait au jeune âge (dessication du béton)

- Retrait gêné (dilatation/retrait) d'origine thermique ($Delta$ $theta$)

- … éventuellement

- RAG ou RSI

#strong[Conséquences];~: \
Ce sont des conséquences sans gravité~pour le maintien en conditions
opérationnelles de l'ouvrage. Le réseau de fissures collecte les eaux
météoriques qui en migrant à l'intérieur dissolvent la chaux libre
contenue dans le béton ou le corps d'enduit puis en s'évaporant à
l'extérieur la font précipiter sous forme de calcite.

=== Suspicion de Réaction de Gonflement Interne~: principes
<suspicion-de-réaction-de-gonflement-interne-principes>
#strong[Principes];~: \
La RGI prend 2 formes différentes~: RSI ou RAG (Réaction Sulfatique
Interne ou Réaction Alcali-Granulat, respectivement). La distinction est
visuelle en première approche (faciès d'altération différents) mais
nécessite une analyse en laboratoire sur éprouvettes collectées sur site
pour établir la présence et la distinction entre ces 2 phénomènes de
gonflement du béton.

#strong[Manifestations];~: \
Sans rentrer dans le détail de ces 2 types de réaction, le gonflement
interne peut provoquer des sinistres importants à un ouvrage, lorsqu'il
est qualifié de sévère~: déstructuration interne, perte d'adhérence
béton-armatures, perte de portance …

- Pour la RSI (expansion gel d'ettringite), la réaction est augmentée en
  présence d'humidité.

- Pour la RAG (alcali réaction), c'est la nature chimique entre la pâte
  cimentaire et les granulats qui provoque un gonflement.

#strong[Détection];~: \
Seule l'approche pétrographique et microstructurale#footnote[Examens
morphologique 2D/3D au Microscope Électronique à Balayage +
Fluorescence, ou méthode LCPC 36] peut déterminer avec certitude la
présence de gels d'alcali-réaction (RAG) ou d'ettringite (RSI) ainsi que
l'évolutivité du phénomène qui peut être schématisée selon une courbe de
Gauss (temps en abscisse et intensité en ordonnée), l'inspection
visuelle des faciès d'altération (rag~: pustules et taches sur le
parement, RSI~: fissures maillées) n'est pas sûre.

#strong[Traitements];~: \
Aucun~! s'agissant d'une réaction interne, il est impossible d'y
remédier. Seules des mesures de diminution du phénomène existent~:

- Protection contre les venues d'eau~: étanchéité terrasse supérieure,
  ravalement de façade avec un produit consolidant type
  Mineralchoc/Technique béton.

- Sciage de libération des contraintes

- Suivi dimensionnel périodique pour décision de maintien ou de
  remplacement de l'ouvrage

=== État général ouvrage
<état-général-ouvrage>
L'état général de l'ouvrage est jugé #strong[bon] malgré d'inévitables
dégradations liées à son grand âge~:

- #strong[Parement];~:

  - Hormis la fissuration modéré, d'origine probablement liée à du
    retrait gêné (#strong[Fissuration~selon IF] : valeurs médianes
    (modérée à forte, sur une échelle de 6 valeurs#footnote[Fissuration
    négligeable, faible, modérée, forte, très forte, considérable];))

  - Absence de fissures liées à des dépassements de contraintes (pas de
    fissures de flexion, cisaillement ou tassements différentiels)

  - Absence de déformations en plan ou de décollements

  - #strong[Protection contre les venues d'eau~];: à réaliser (enduit
    imperméable et perspirant, type traitement de
    consolidation/reminéralisation)

- #strong[Terrasse~];:

  - #strong[Fissures terrasse~];: à traiter

  - #strong[Corniche~];: à reprendre (fissuration importante + éclats)

  - #strong[Protection contre les venues d'eau~];: à réaliser
    (étanchéité circulable, la terrasse constituant le palier supérieur
    de l'escalier menant à la passerelle régnant en partie supérieure du
    pont transbordeur)

- #strong[Escalier d'accès];~: bon état

== Pronostic
<pronostic>
En fonction des observations effectuées précédemment, le pronostic
suivant est établi, à court/moyen/long terme.

=== Cinétique dégradations
<cinétique-dégradations>
Pour un ouvrage de 100 d'âge, la quantité des dégradations est faible.
En conséquence, nous estimons que la cinétique des dégradations est
faible, que cela soit à court, moyen ou long terme.

=== Avis gravité/urgence
<avis-gravitéurgence>
#strong[Gravité faible];~: \
Les dégradations constatées n'affectent que le parement, en superficie.
L'ouvrage étant surdimensionné en termes de volumes de béton, ces
dégradations ne menacent pas l'intégrité structurale de celui-ci ni ses
fonctions d'appui du pont transbordeur.

#strong[Urgence de réfections];~: \
Devant la faible gravité des dégradations, nous serions amenés à
conseiller de n'intervenir qu'à moyen ou long terme. Nous proposons au
contraire d'effectuer des réfections de faible ampleur, mais à court
terme, dans l'esprit de la maintenance préventive, voir le §4.2.

// Section: = Préconisations
#pagebreak(weak: true)
= Préconisations
<préconisations>
== Complément d'analyse (suspicion RGI)
<complément-danalyse-suspicion-rgi>
Carottages + analyses labo, à réaliser par une entité spécialisée (Lerm,
Cerib, etc.).

Repérés sur site par marquage à la peinture fluo sur 3 faces/parement
distincts.

#figure(
  align(center)[#table(
    columns: (50.01%, 49.99%),
    align: (center,center,),
    table.header([#image("media/image25.jpeg", width: 80%)

      Figure 24 : localisation des carottages C1 (pied-droit amont, face
      F1 coté berge) → 8 carottes à réaliser

      ], [#image("media/image26.jpeg", width: 80%)

      Figure 25 : localisation des carottages C2 (pied-droit amont, face
      F2 coté amont) → 8 carottes à réaliser

      ],),
    table.hline(),
    [#image("media/image27.jpeg", width: 80%)

    Figure 26 : localisation des carottages C3 (pied-droit aval, face F1
    coté berge) → 8 carottes à réaliser

    ], [],
  )]
  , kind: table
  )

== Travaux de réfection à courte échéance
<travaux-de-réfection-à-courte-échéance>
=== Réfection éclats béton
<réfection-éclats-béton>
- Corniche supérieure~: réfection des éclats et fissures (avant
  l'étanchéité qui la recouvrira)

- Épaufrures en sous-face du chevêtre~: traitement

=== Étanchéité terrasse de la Pile RG
<étanchéité-terrasse-de-la-pile-rg>
- Étanchéité en partie courante et retombées~:

  - Étanchéité circulable~car cette terrasse constitue une partie de
    l'accès à la passerelle régnant au-dessus du pont transbordeur

  - Étanchéité sur les retombées latérales (face verticale de la
    corniche) pour assurer la fonction de rejingot

- Difficultés~: nombreux ouvrages (pieds potelets GC, candélabre, pied
  grue potence et en partie courante de la plateforme

=== Parements
<parements>
Ravalement de façade~:

- Échafaudage

- Protection des équipements EDF fixés en paroi

- Nettoyage des coulures de calcite

- Application d'un produit de consolidation/reminéralisation (type
  Mineralchoc/Technique béton)

- Application éventuelle d'une peinture de façade reprenant les tons
  (beige/jaune/ocre clair) d'origine.

// Section: = Annexes
#pagebreak(weak: true)
= Annexes
<annexes>
== Indice de fissuration~: photos & feuilles de relevé sur site
<indice-de-fissuration-photos-feuilles-de-relevé-sur-site>
#figure(
  align(center)[#table(
    columns: (100%),
    align: (center,),
    table.header([#image("media/image28.jpeg", width: 80%)

      Figure 27 : photo IF\#1 sur la face F1 (pied-droit amont, face
      côté berge)

      ],),
    table.hline(),
    [#image("media/image29.png", width: 80%)

    Figure 28 : Indice de fissuration IF\#1 sur la face F1 : valeur
    #strong[I_f = 1.58] -\> fissuration #strong[modérée]

    ],
  )]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: (100%),
    align: (center,),
    table.header([#image("media/image30.jpeg", width: 80%)

      Figure 29 : photo IF\#2 sur la face F5 (pied-droit aval, face côté
      berge)

      ],),
    table.hline(),
    [#image("media/image31.png", width: 80%)

    Figure 30 : Indice de fissuration IF\#2 sur la face F5 #strong[:]
    valeur #strong[I_f = 2.05] -\> fissuration #strong[forte]

    ],
  )]
  , kind: table
  )

== Logigramme de détection de RGI (fiche D1-3)
<logigramme-de-détection-de-rgi-fiche-d1-3>
#figure(
  align(center)[#table(
    columns: (100%),
    align: (auto,),
    table.header([#image("media/image32.png", width: 80%)],),
    table.hline(),
  )]
  , kind: table
  )

== Dossier photo
<dossier-photo>
#figure(
  align(center)[#table(
    columns: (100%),
    align: (center,),
    table.header([#figure(
  #image("media/image33.jpeg", width: 80%),
  caption: [Perspective depuis la berge RG]
)

      ],),
    table.hline(),
    [#figure(
  #image("media/image34.jpeg", width: 80%),
  caption: [élévation côté berge RG]
)

    ],
  )]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: (100%),
    align: (center,),
    table.header([#figure(
  #image("media/image35.jpeg", width: 80%),
  caption: [perspective aval depuis le côté donnant sur la Dordogne]
)

      ],),
    table.hline(),
    [#figure(
  #image("media/image36.jpeg", width: 80%),
  caption: [face \"f1\" du pied-droit amont, côté berge RG]
)

    ],
    [#figure(
  #image("media/image37.jpeg", width: 80%),
  caption: [focus sur la fissuration de la face f1]
)

    ],
    [#figure(
  #image("media/image38.jpeg", width: 80%),
  caption: [fissurations et éclats de la corniche]
)

    ],
    [#figure(
  #image("media/image39.jpeg", width: 80%),
  caption: [épaufrures en sous-face du chevêtre]
)

    ],
    [#figure(
  #image("media/image40.jpeg", width: 80%),
  caption: [correspondance des fissures en \"façade-pignon\" : elles se]
)
    rejoignent en cueillie

    ],
    [#figure(
  #image("media/image41.jpeg", width: 80%),
  caption: [accumulation de calcite en cueillie]
)

    ],
  )]
  , kind: table
  )
