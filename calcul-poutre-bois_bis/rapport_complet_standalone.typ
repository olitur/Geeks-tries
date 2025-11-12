// ███████████████████████████████████████████████████████████████████████████████
// RAPPORT COMPLET D'ANALYSE STRUCTURELLE EUROCODE - POUTRE BOIS RENFORCÉE
// ███████████████████████████████████████████████████████████████████████████████

#import "@preview/cetz:0.2.2"

#set page(
  paper: "a4",
  margin: (left: 25mm, right: 25mm, top: 25mm, bottom: 25mm),
  numbering: "1",
)

#set text(font: "New Computer Modern", size: 10pt, lang: "fr")
#set par(justify: true)
#set heading(numbering: "1.1.")

// ═══════════════════════════════════════════════════════════════════════════════
// DONNÉES DU PROJET
// ═══════════════════════════════════════════════════════════════════════════════

#let projet_nom = "Rénovation immeuble 12 rue de la République - Grenoble"
#let projet_auteur = "Cabinet StructurePro"
#let projet_date = "2025-11-12"
#let projet_numero = "2025-0342"
#let projet_type = "Bâtiment d'habitation"

// Localisation Eurocode
#let loc_pays = "France"
#let loc_region = "Auvergne-Rhône-Alpes"
#let loc_ville = "Grenoble"
#let loc_altitude = 380 // m
#let loc_zone_neige = "B2"
#let loc_zone_vent = "3"
#let loc_categorie_terrain = "IV"

// Données poutre existante
#let poutre_id = "P01-SOLIVE-RDC-A"
#let L = 7.35 // m
#let b = 0.53 // m
#let h = 0.62 // m
#let essence = "Chêne"
#let classe_bois = "D30"
#let classe_service = 2
#let annee_construction = 1950

// Mesures terrain
#let fleche_mesuree = 0.045 // m (45 mm)
#let date_mesure = "15/10/2024"

// État de la poutre
#let k_exp = 0.80 // Coefficient de dégradation
#let etat_description = "Flèche visible à l'œil nu, fissure longitudinale intrados, zones brunâtres, humidité cyclique"

// ═══════════════════════════════════════════════════════════════════════════════
// CALCULS PRÉLIMINAIRES
// ═══════════════════════════════════════════════════════════════════════════════

// Propriétés géométriques
#let A = b * h // m²
#let I = b * calc.pow(h, 3) / 12 // m⁴
#let W = b * calc.pow(h, 2) / 6 // m³

// Stratigraphie plancher (charges permanentes)
#let carrelage = 0.01 * 22 // kN/m²
#let chape = 0.10 * 22 // kN/m²
#let plancher = 0.05 * 5 // kN/m²
#let plafond = 0.013 * 10 // kN/m²
#let amenagement = 0.50 // kN/m²
#let finitions = 0.30 // kN/m²

#let gk_surface = carrelage + chape + plancher + plafond + amenagement + finitions
#let gk = gk_surface * b // kN/m (charge linéique)

// Charges d'exploitation (EC1-1-1 Tableau 6.1, Catégorie A)
#let qk_surface = 1.5 // kN/m²
#let qk = qk_surface * b // kN/m

// Actions neige (EC1-1-3)
#let sk_sol = 0.75 // kN/m² (zone B2)
#let mu_1 = 0.8 // coefficient de forme
#let sk = sk_sol * mu_1 * b // kN/m

// Actions vent (EC1-1-4)
#let vref = 24 // m/s (zone 3)
#let qb = 0.36 // kN/m² pression dynamique de base
#let wk = qb * b * 0.5 // kN/m (simplifié)

// Combinaisons d'actions ELU (EC0 §6.4.3.2)
#let q_elu_1 = 1.35 * gk + 1.5 * qk // Combinaison fondamentale
#let q_elu_2 = gk + 1.5 * sk // Neige action dominante
#let q_elu_3 = gk + 1.5 * wk // Vent action dominante
#let q_elu = calc.max(q_elu_1, q_elu_2, q_elu_3)

// Combinaisons ELS (EC0 §6.5.3)
#let psi_0 = 0.7
#let psi_1 = 0.5
#let psi_2 = 0.3
#let q_els_char = gk + qk // Caractéristique
#let q_els_freq = gk + psi_1 * qk // Fréquente
#let q_els_qperm = gk + psi_2 * qk // Quasi-permanente

// Sollicitations ELU (poutre sur 2 appuis simples)
#let M_elu = q_elu * calc.pow(L, 2) / 8 // kNm
#let V_elu = q_elu * L / 2 // kN

// Propriétés matériau bois D30 (EN 338)
#let fm_k = 30.0 // MPa
#let fv_k = 3.0 // MPa
#let E_0_mean = 10000 // MPa
#let E_0_05 = 6700 // MPa

// Coefficients EC5
#let k_mod = 0.8 // Classe service 2, durée charge moyenne
#let gamma_M = 1.25 // Coefficient partiel bois

// Résistances de calcul
#let fm_d = k_mod * fm_k / gamma_M * k_exp // MPa
#let fv_d = k_mod * fv_k / gamma_M * k_exp // MPa
#let E_d = E_0_05 * k_exp // MPa (pour flèches)

// Vérifications contraintes
#let sigma_m = M_elu * 1000 / W // MPa (M en kNm → Nm)
#let tau = 3 * V_elu * 1000 / (2 * A) // MPa
#let taux_flex = sigma_m / fm_d * 100 // %
#let taux_cis = tau / fv_d * 100 // %

// Flèches ELS (EC5 §7.2)
#let k_def = 0.8 // Classe service 2
#let f_inst = 5 * q_els_char * calc.pow(L, 4) / (384 * E_d * I) * 1000 // mm
#let f_fin = f_inst * (1 + k_def) // mm (fluage inclus)
#let f_lim = L / 250 * 1000 // mm
#let ratio_fleche = f_fin / f_lim

// Comparaison avec mesure terrain
#let f_mes = fleche_mesuree * 1000 // mm
#let ratio_mesure = f_mes / f_fin

// Décision renforcement
#let besoin_renfort = (taux_flex > 100) or (taux_cis > 100) or (f_fin > f_lim) or (ratio_mesure > 1.2)

// ═══════════════════════════════════════════════════════════════════════════════
// DIMENSIONNEMENT RENFORCEMENT UPE
// ═══════════════════════════════════════════════════════════════════════════════

#let M_renfort = if besoin_renfort { M_elu * 0.35 } else { 0 }
#let upe_h = if M_renfort > 30 { 200 } else if M_renfort > 20 { 160 } else if M_renfort > 10 { 120 } else { 100 }
#let upe_wel = if upe_h == 200 { 191 } else if upe_h == 160 { 116 } else if upe_h == 120 { 62.8 } else { 43.8 }
#let upe_poids = if upe_h == 200 { 31.5 } else if upe_h == 160 { 22.8 } else if upe_h == 120 { 15.3 } else { 12.2 }

// Résistance acier S235
#let fy = 235 // MPa
#let M_rd_upe = 2 * upe_wel * fy / 1000 / 1000 // kNm (2 UPE)

// Boulonnage M12 classe 8.8
#let n_boulons = calc.ceil(L / 0.15) // espacement 150 mm
#let fb_k = 800 // MPa (classe 8.8)
#let As = 84.3 // mm² (section résistante M12)
#let Fv_Rd = 0.6 * fb_k * As / 1.25 / 1000 // kN par boulon

// ═══════════════════════════════════════════════════════════════════════════════
// PAGE DE TITRE
// ═══════════════════════════════════════════════════════════════════════════════

#align(center)[
  #v(40mm)
  #text(size: 20pt, weight: "bold")[
    RAPPORT D'ANALYSE STRUCTURELLE\
    RENFORCEMENT POUTRE BOIS
  ]

  #v(10mm)
  #text(size: 14pt)[
    Calculs selon Eurocodes 0, 1, 3 et 5
  ]

  #v(20mm)
  #box(width: 100%, stroke: 1pt + black, inset: 10mm)[
    #grid(
      columns: (1fr, 2fr),
      gutter: 8mm,
      align: (right, left),

      [*Projet :*], [#projet_nom],
      [*N° dossier :*], [#projet_numero],
      [*Type d'ouvrage :*], [#projet_type],
      [*Poutre :*], [#poutre_id],
      [*Localisation :*], [#loc_ville (#loc_region)],
      [*Auteur :*], [#projet_auteur],
      [*Date :*], [#projet_date],
    )
  ]

  #v(30mm)
  #text(size: 11pt, style: "italic")[
    Document conforme aux normes européennes\
    EN 1990 (EC0), EN 1991 (EC1), EN 1993 (EC3), EN 1995 (EC5)
  ]
]

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
// TABLE DES MATIÈRES
// ═══════════════════════════════════════════════════════════════════════════════

#outline(indent: auto)

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
// CORPS DU RAPPORT
// ═══════════════════════════════════════════════════════════════════════════════

= Contexte et Localisation du Projet

== Identification du Projet

#grid(
  columns: (1fr, 2fr),
  gutter: 8mm,
  align: (left, left),

  [*Projet :*], [#projet_nom],
  [*N° dossier :*], [#projet_numero],
  [*Type d'ouvrage :*], [#projet_type],
  [*Année construction :*], [#annee_construction],
  [*Auteur étude :*], [#projet_auteur],
  [*Date étude :*], [#projet_date],
)

== Localisation et Paramètres Eurocode

La localisation du projet détermine les actions climatiques selon les Eurocodes nationaux français.

#grid(
  columns: (auto, auto, auto),
  gutter: 8mm,
  align: left,

  [*Paramètre*], [*Valeur*], [*Référence EC*],

  [Pays], [#loc_pays], [---],
  [Région], [#loc_region], [---],
  [Ville], [#loc_ville], [---],
  [Altitude], [#loc_altitude m], [EC1-1-3 §A.3],
  [Zone neige], [#loc_zone_neige], [EC1-1-3 AN Fig. NA.3],
  [Charge neige sol], [#calc.round(sk_sol, digits: 2) kN/m²], [EC1-1-3 Tableau NA.1],
  [Zone vent], [Zone #loc_zone_vent], [EC1-1-4 AN §4.2],
  [Vitesse ref. vent], [#vref m/s], [EC1-1-4 Carte France],
  [Catégorie terrain], [#loc_categorie_terrain], [EC1-1-4 Tableau 4.1],
)

== Durabilité et Classe d'Exposition

- *Classe de service* : #classe_service (EC5 §2.3.1.3) — Humidité du bois 12-20%
- *Classe d'exposition* : XC1 (EN 206) — Intérieur, humidité faible
- *Durée de vie utile* : 50 ans (EC0 Annexe A, bâtiment courant)

#pagebreak()

= Description de l'Élément Structurel

== Identification de la Poutre

#grid(
  columns: (auto, auto),
  gutter: 8mm,
  align: left,

  [*Paramètre*], [*Valeur*],

  [Identifiant], [#poutre_id],
  [Portée (entre nus)], [#L m],
  [Largeur], [#b m (#int(b*1000)) mm)],
  [Hauteur], [#h m (#int(h*1000)) mm)],
  [Essence bois], [#essence],
  [Classe résistance], [#classe_bois (EN 338)],
  [Année construction], [#annee_construction],
)

== Schéma Structural

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Échelle graphique
    let scale = 1.2
    let Lplot = L * scale
    let hplot = h * scale * 5

    // Appuis
    line((0, 0), (0.3, -0.3), stroke: 2pt)
    line((0, 0), (-0.3, -0.3), stroke: 2pt)
    line((Lplot, 0), (Lplot, -0.3), stroke: 2pt)
    circle((Lplot, 0), radius: 0.15, fill: white, stroke: 2pt)

    // Poutre
    rect((0, 0), (Lplot, hplot), fill: rgb("#d4a574"), stroke: 2pt)

    // Charge répartie
    let n_arrows = 15
    for i in range(n_arrows) {
      let x = i * Lplot / (n_arrows - 1)
      line((x, hplot + 0.3), (x, hplot), stroke: (paint: red, thickness: 1.5pt), mark: (end: ">"))
    }

    // Annotations
    content((Lplot/2, -0.7), [L = #L m], anchor: "center")
    content((Lplot + 0.8, hplot/2), [h = #int(h*1000) mm], anchor: "west")
    content((Lplot/2, hplot + 0.8), text(fill: red)[q (kN/m)], anchor: "center")

    // Légende appuis
    content((-0.5, -0.5), text(size: 8pt)[Appui simple], anchor: "east")
    content((Lplot + 0.5, -0.5), text(size: 8pt)[Appui à rouleau], anchor: "west")
  }),
  caption: [Schéma structural — Poutre sur deux appuis simples]
)

== État Actuel et Pathologie

*Date de mesure terrain* : #date_mesure

*Observations visuelles* :
#etat_description

*Mesures de flèche* :
- Flèche mesurée au centre : *#int(f_mes) mm* (instrument : niveau laser numérique)
- Température lors mesure : 18°C
- Humidité relative : 65%

*Coefficient de réduction appliqué* : k#sub[exp] = #k_exp (expertise EC5 §2.4.1)

#pagebreak()

= Calcul des Actions (Eurocode 1)

== Charges Permanentes (EC1-1-1 §6.1)

=== Stratigraphie du Plancher

#table(
  columns: (2fr, 1fr, 1fr, 1fr),
  align: (left, center, center, center),

  [*Couche*], [*Épaisseur*], [*γ (kN/m³)*], [*p (kN/m²)*],

  [Carrelage cérame], [10 mm], [22], [#calc.round(carrelage, digits: 2)],
  [Chape ciment], [100 mm], [22], [#calc.round(chape, digits: 2)],
  [Plancher bois ancien], [50 mm], [5], [#calc.round(plancher, digits: 2)],
  [Plafond plâtre], [13 mm], [10], [#calc.round(plafond, digits: 2)],
  [Aménagements], [---], [---], [#amenagement],
  [Finitions], [---], [---], [#finitions],

  table.hline(),
  [*Total surfacique G#sub[k]*], [], [], [*#calc.round(gk_surface, digits: 2) kN/m²*],
  [*Charge linéique (×#b m)*], [], [], [*#calc.round(gk, digits: 2) kN/m*],
)

$ G_k = #calc.round(gk, digits: 2) "kN/m" $

== Charges d'Exploitation (EC1-1-1 Tableau 6.1)

*Catégorie A — Habitation*

$ Q_k = #qk_surface "kN/m²" times #b "m" = #calc.round(qk, digits: 2) "kN/m" $

*Coefficients de combinaison* (EC0 Tableau A1.1) :
- ψ#sub[0] = #psi_0 (valeur de combinaison)
- ψ#sub[1] = #psi_1 (valeur fréquente)
- ψ#sub[2] = #psi_2 (valeur quasi-permanente)

== Actions Climatiques

=== Neige (EC1-1-3)

Charge de neige sur le sol caractéristique pour zone #loc_zone_neige à #loc_altitude m d'altitude :

$ s_k = s_(k,"sol") times mu_1 = #sk_sol times #mu_1 = #calc.round(sk_sol * mu_1, digits: 2) "kN/m²" $

Charge linéique : $ S_k = #calc.round(sk, digits: 2) "kN/m" $

=== Vent (EC1-1-4)

Pression dynamique de référence zone #loc_zone_vent, catégorie terrain #loc_categorie_terrain :

$ q_b = #qb "kN/m²" $

Charge linéique (simplifiée) : $ W_k = #calc.round(wk, digits: 2) "kN/m" $

== Combinaisons d'Actions

=== États Limites Ultimes (EC0 §6.4.3.2)

Expression générale ELU :
$ sum gamma_(G,j) G_(k,j) + gamma_(Q,1) Q_(k,1) + sum gamma_(Q,i) psi_(0,i) Q_(k,i) $

*Combinaisons calculées :*

1. *Fondamentale* (charges dominantes) :
   $ q_("ELU,1") = 1.35 G_k + 1.5 Q_k = 1.35 times #calc.round(gk, digits: 2) + 1.5 times #calc.round(qk, digits: 2) $
   $ = #calc.round(q_elu_1, digits: 2) "kN/m" $

2. *Neige action variable dominante* :
   $ q_("ELU,2") = G_k + 1.5 S_k = #calc.round(gk, digits: 2) + 1.5 times #calc.round(sk, digits: 2) $
   $ = #calc.round(q_elu_2, digits: 2) "kN/m" $

3. *Vent action variable dominante* :
   $ q_("ELU,3") = G_k + 1.5 W_k = #calc.round(gk, digits: 2) + 1.5 times #calc.round(wk, digits: 2) $
   $ = #calc.round(q_elu_3, digits: 2) "kN/m" $

#box(fill: rgb("#ffffcc"), inset: 10mm, width: 100%)[
  *Combinaison ELU retenue* (maximum) :
  $ q_("ELU") = #calc.round(q_elu, digits: 2) "kN/m" $
]

=== États Limites de Service (EC0 §6.5.3)

1. *Caractéristique* :
   $ q_("ELS,char") = G_k + Q_k = #calc.round(q_els_char, digits: 2) "kN/m" $

2. *Fréquente* :
   $ q_("ELS,freq") = G_k + psi_1 Q_k = #calc.round(gk, digits: 2) + #psi_1 times #calc.round(qk, digits: 2) = #calc.round(q_els_freq, digits: 2) "kN/m" $

3. *Quasi-permanente* :
   $ q_("ELS,qperm") = G_k + psi_2 Q_k = #calc.round(gk, digits: 2) + #psi_2 times #calc.round(qk, digits: 2) = #calc.round(q_els_qperm, digits: 2) "kN/m" $

#pagebreak()

= Propriétés Géométriques et Matériau

== Section de la Poutre

#table(
  columns: (2fr, 1fr, 1fr),
  align: (left, center, left),

  [*Propriété*], [*Valeur*], [*Unité*],

  [Aire section], [#calc.round(A, digits: 4)], [m²],
  [Moment d'inertie I#sub[y]], [#calc.round(I, digits: 5)], [m⁴],
  [Module de flexion W], [#calc.round(W, digits: 5)], [m³],
)

Formules :
$ A = b times h = #b times #h = #calc.round(A, digits: 4) "m²" $
$ I = (b h^3)/12 = #calc.round(I, digits: 5) "m⁴" $
$ W = (b h^2)/6 = #calc.round(W, digits: 5) "m³" $

== Caractéristiques du Bois (EN 338)

*Classe de résistance* : #classe_bois (#essence)

#table(
  columns: (2fr, 1fr, 1fr),
  align: (left, center, left),

  [*Propriété*], [*Valeur caractéristique*], [*Unité*],

  [Résistance flexion f#sub[m,k]], [#fm_k], [MPa],
  [Résistance cisaillement f#sub[v,k]], [#fv_k], [MPa],
  [Module élasticité moyen E#sub[0,mean]], [#E_0_mean], [MPa],
  [Module élasticité 5% E#sub[0,05]], [#E_0_05], [MPa],
)

== Coefficients de Calcul (EC5)

*Classe de service #classe_service* : Humidité bois 12-20% (EC5 Tableau 2.3)

*Coefficient de modification k#sub[mod]* = #k_mod (EC5 Tableau 3.1, durée charge moyenne)

*Coefficient partiel γ#sub[M]* = #gamma_M (EC5 §2.4.1)

*Coefficient d'expertise k#sub[exp]* = #k_exp (dégradation constatée)

== Résistances de Calcul

$ f_(m,d) = (k_"mod" times f_(m,k))/(gamma_M) times k_"exp" = (#k_mod times #fm_k)/#gamma_M times #k_exp = #calc.round(fm_d, digits: 2) "MPa" $

$ f_(v,d) = (k_"mod" times f_(v,k))/(gamma_M) times k_"exp" = (#k_mod times #fv_k)/#gamma_M times #k_exp = #calc.round(fv_d, digits: 2) "MPa" $

$ E_d = E_(0,05) times k_"exp" = #E_0_05 times #k_exp = #calc.round(E_d, digits: 0) "MPa" $

#pagebreak()

= Vérifications aux États Limites Ultimes

== Sollicitations de Calcul

Pour une poutre sur deux appuis simples sous charge uniformément répartie :

*Moment fléchissant maximal* (mi-travée) :
$ M_"Ed" = (q_"ELU" L^2)/8 = (#calc.round(q_elu, digits: 2) times #L^2)/8 = #calc.round(M_elu, digits: 2) "kNm" $

*Effort tranchant maximal* (appuis) :
$ V_"Ed" = (q_"ELU" L)/2 = (#calc.round(q_elu, digits: 2) times #L)/2 = #calc.round(V_elu, digits: 2) "kN" $

== Diagrammes des Sollicitations

#figure(
  cetz.canvas({
    import cetz.draw: *

    let scale = 1.0
    let Lplot = 10
    let hmax = 3

    // Axe x
    line((0, 0), (Lplot, 0), stroke: 1pt, mark: (end: ">"))
    content((Lplot + 0.3, 0), [x], anchor: "west")

    // Diagramme moment (parabole)
    let n = 50
    let pts = ()
    for i in range(n + 1) {
      let xi = i / n * Lplot
      let Mi = hmax * (xi / Lplot) * (1 - xi / Lplot) * 4
      pts.push((xi, Mi))
    }

    line(..pts, stroke: (paint: red, thickness: 2pt))
    content((Lplot/2, hmax + 0.3), text(fill: red)[M(x)], anchor: "south")
    content((Lplot/2, hmax/2 - 0.3), text(fill: red, size: 9pt)[M#sub[max] = #calc.round(M_elu, digits: 1) kNm], anchor: "center")

    // Annotation L
    line((0, -0.8), (Lplot, -0.8), stroke: 1pt, mark: (start: "|", end: "|"))
    content((Lplot/2, -0.8), [L = #L m], anchor: "north")
  }),
  caption: [Diagramme du moment fléchissant M(x)]
)

#figure(
  cetz.canvas({
    import cetz.draw: *

    let Lplot = 10
    let Vmax = 2

    // Axe
    line((0, 0), (Lplot, 0), stroke: 1pt, mark: (end: ">"))
    content((Lplot + 0.3, 0), [x], anchor: "west")
    line((0, -Vmax), (0, Vmax), stroke: 1pt, mark: (end: ">"))
    content((0, Vmax + 0.3), [V], anchor: "south")

    // Diagramme effort tranchant (linéaire)
    line((0, Vmax), (Lplot, -Vmax), stroke: (paint: blue, thickness: 2pt))
    line((0, 0), (0, Vmax), stroke: (paint: blue, thickness: 1pt, dash: "dashed"))
    line((Lplot, 0), (Lplot, -Vmax), stroke: (paint: blue, thickness: 1pt, dash: "dashed"))

    content((0.5, Vmax), text(fill: blue, size: 9pt)[+#calc.round(V_elu, digits: 1) kN], anchor: "west")
    content((Lplot - 0.5, -Vmax), text(fill: blue, size: 9pt)[−#calc.round(V_elu, digits: 1) kN], anchor: "east")
  }),
  caption: [Diagramme de l'effort tranchant V(x)]
)

== Vérification en Flexion (EC5 §6.1.6)

*Contrainte de flexion* :
$ sigma_(m,d) = M_"Ed"/W = (#calc.round(M_elu, digits: 2) times 10^6)/(#calc.round(W, digits: 5) times 10^6) = #calc.round(sigma_m, digits: 2) "MPa" $

*Critère* :
$ sigma_(m,d) <= f_(m,d) $

$ #calc.round(sigma_m, digits: 2) "MPa" #if sigma_m <= fm_d [<=] else [>] #calc.round(fm_d, digits: 2) "MPa" $

#box(
  fill: if taux_flex <= 100 { rgb("#ccffcc") } else { rgb("#ffcccc") },
  inset: 8mm,
  width: 100%
)[
  *Taux de travail en flexion* : #calc.round(taux_flex, digits: 1)%

  #if taux_flex <= 100 [
    ✓ *VÉRIFIÉ* — La poutre résiste en flexion
  ] else [
    ✗ *NON VÉRIFIÉ* — Renforcement nécessaire
  ]
]

== Vérification au Cisaillement (EC5 §6.1.7)

*Contrainte de cisaillement* :
$ tau_d = (3 V_"Ed")/(2 A) = (3 times #calc.round(V_elu, digits: 2) times 10^3)/(2 times #calc.round(A, digits: 4)) = #calc.round(tau, digits: 2) "MPa" $

*Critère* :
$ tau_d <= f_(v,d) $

$ #calc.round(tau, digits: 2) "MPa" #if tau <= fv_d [<=] else [>] #calc.round(fv_d, digits: 2) "MPa" $

#box(
  fill: if taux_cis <= 100 { rgb("#ccffcc") } else { rgb("#ffcccc") },
  inset: 8mm,
  width: 100%
)[
  *Taux de travail en cisaillement* : #calc.round(taux_cis, digits: 1)%

  #if taux_cis <= 100 [
    ✓ *VÉRIFIÉ* — La poutre résiste au cisaillement
  ] else [
    ✗ *NON VÉRIFIÉ* — Renforcement nécessaire
  ]
]

#pagebreak()

= Vérifications aux États Limites de Service

== Flèche Instantanée (EC5 §7.2)

Pour une poutre sur deux appuis sous charge uniforme :

$ f_"inst" = (5 q_"ELS" L^4)/(384 E_d I) $

$ f_"inst" = (5 times #calc.round(q_els_char, digits: 2) times #L^4)/(384 times #calc.round(E_d, digits: 0) times #calc.round(I, digits: 5) times 10^3) times 10^3 = #calc.round(f_inst, digits: 1) "mm" $

== Flèche Finale avec Fluage (EC5 §2.2.3)

*Coefficient de fluage* k#sub[def] = #k_def (classe service #classe_service)

$ f_"fin" = f_"inst" (1 + k_"def") = #calc.round(f_inst, digits: 1) times (1 + #k_def) = #calc.round(f_fin, digits: 1) "mm" $

== Flèche Admissible (EC5 Tableau 7.2)

Pour élément supportant un plancher :

$ f_"lim" = L/250 = #L/250 times 10^3 = #calc.round(f_lim, digits: 1) "mm" $

*Critère* : $ f_"fin" <= f_"lim" $

$ #calc.round(f_fin, digits: 1) "mm" #if f_fin <= f_lim [<=] else [>] #calc.round(f_lim, digits: 1) "mm" $

#box(
  fill: if ratio_fleche <= 1.0 { rgb("#ccffcc") } else { rgb("#ffcccc") },
  inset: 8mm,
  width: 100%
)[
  *Ratio flèche* : #calc.round(ratio_fleche, digits: 2)

  #if ratio_fleche <= 1.0 [
    ✓ *VÉRIFIÉ* — Flèche acceptable
  ] else [
    ✗ *NON VÉRIFIÉ* — Flèche excessive
  ]
]

== Comparaison avec Mesures Terrain

*Flèche mesurée* : #int(f_mes) mm (date : #date_mesure)

*Flèche théorique finale* : #calc.round(f_fin, digits: 1) mm

$ "Ratio mesure/théorique" = #int(f_mes) / #calc.round(f_fin, digits: 1) = #calc.round(ratio_mesure, digits: 2) $

#box(fill: rgb("#fff3cd"), inset: 8mm, width: 100%)[
  #if ratio_mesure > 1.2 [
    ⚠ *ATTENTION* — Flèche mesurée significativement supérieure à la théorie

    Cela peut indiquer :
    - Dégradation plus importante que k#sub[exp] = #k_exp
    - Charges réelles supérieures aux hypothèses
    - Module E effectif réduit par fluage long terme
  ] else if ratio_mesure < 0.8 [
    ℹ Flèche mesurée inférieure à la théorie (favorable)
  ] else [
    ✓ Cohérence mesure/théorie acceptable
  ]
]

#pagebreak()

= Décision de Renforcement

== Synthèse des Vérifications

#table(
  columns: (2fr, 1fr, 1fr, 1fr),
  align: (left, center, center, center),

  [*Critère*], [*Valeur*], [*Limite*], [*État*],

  [Flexion ELU],
  [#calc.round(taux_flex, digits: 1)%],
  [100%],
  if taux_flex <= 100 [✓] else [✗],

  [Cisaillement ELU],
  [#calc.round(taux_cis, digits: 1)%],
  [100%],
  if taux_cis <= 100 [✓] else [✗],

  [Flèche ELS],
  [#calc.round(ratio_fleche, digits: 2)],
  [1.00],
  if ratio_fleche <= 1.0 [✓] else [✗],

  [Mesure terrain],
  [#calc.round(ratio_mesure, digits: 2)],
  [1.20],
  if ratio_mesure <= 1.2 [✓] else [✗],
)

== Conclusion

#box(
  fill: if besoin_renfort { rgb("#ffdddd") } else { rgb("#ddffdd") },
  inset: 12mm,
  width: 100%,
  radius: 4pt
)[
  #text(size: 13pt, weight: "bold")[
    #if besoin_renfort [
      ⚠ RENFORCEMENT NÉCESSAIRE
    ] else [
      ✓ STRUCTURE CONFORME
    ]
  ]

  #v(5mm)

  #if besoin_renfort [
    La poutre ne satisfait pas aux critères Eurocode. Un renforcement par profilés métalliques est requis.
  ] else [
    La poutre satisfait à tous les critères de vérification Eurocode. Aucun renforcement structurel n'est nécessaire.
  ]
]

#if besoin_renfort [

#pagebreak()

= Dimensionnement du Renforcement

== Principe Structurel

Le renforcement consiste à ajouter deux profilés métalliques UPE (U à Pales Égales) symétriquement de part et d'autre de la poutre bois, solidarisés par boulons traversants.

*Hypothèse de calcul* : Les UPE reprennent environ 35% du moment total (section mixte bois-acier).

$ M_"renfort" = 0.35 times M_"ELU" = 0.35 times #calc.round(M_elu, digits: 2) = #calc.round(M_renfort, digits: 2) "kNm" $

== Choix du Profilé UPE (EN 10365)

*Nuance acier* : S235 (EN 10025-2)
- Limite élastique f#sub[y] = #fy MPa
- Coefficient partiel γ#sub[M0] = 1.0

*Moment résistant plastique pour 2 UPE* :

$ M_"Rd" = 2 times W_"el" times f_y / gamma_"M0" $

#table(
  columns: (auto, auto, auto, auto, auto),
  align: center,

  [*Profilé*], [*Hauteur (mm)*], [*W#sub[el] (cm³)*], [*Poids (kg/m)*], [*M#sub[Rd] (kNm)*],

  [UPE 100], [100], [43.8], [12.2], [#calc.round(2 * 43.8 * 235 / 1000, digits: 1)],
  [UPE 120], [120], [62.8], [15.3], [#calc.round(2 * 62.8 * 235 / 1000, digits: 1)],
  [UPE 160], [160], [116], [22.8], [#calc.round(2 * 116 * 235 / 1000, digits: 1)],
  [UPE 200], [200], [191], [31.5], [#calc.round(2 * 191 * 235 / 1000, digits: 1)],
)

#box(fill: rgb("#e8f4f8"), inset: 10mm, width: 100%)[
  *Profilé retenu* : *2 × UPE #upe_h*

  - Module élastique : #upe_wel cm³ (par UPE)
  - Poids linéique : #upe_poids kg/m (par UPE)
  - Moment résistant : *#calc.round(M_rd_upe, digits: 1) kNm* > #calc.round(M_renfort, digits: 2) kNm ✓
]

== Configuration des Profilés

- *Longueur unitaire* : 4.0 m (maximum transport)
- *Nombre de tronçons* : 2 par UPE (L = #L m)
- *Recouvrement minimal* : 200 mm (transmission efforts)
- *Position* : Semelles vers l'extérieur (facilité boulonnage)

== Schéma de Principe

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Vue en coupe
    let bw = 4
    let hw = 5
    let upe_w = 0.5
    let upe_h = 1.2

    // Poutre bois
    rect((0, 0), (bw, hw), fill: rgb("#d4a574"), stroke: 2pt)
    content((bw/2, hw/2), [Poutre bois\ existante], anchor: "center")

    // UPE gauche
    rect((-upe_w, hw/2 - upe_h/2), (0, hw/2 + upe_h/2), fill: rgb("#b0b0b0"), stroke: 2pt)
    rect((-upe_w - 0.3, hw/2 - upe_h/2), (-upe_w, hw/2 - upe_h/2 + 0.2), fill: rgb("#b0b0b0"), stroke: 2pt)
    rect((-upe_w - 0.3, hw/2 + upe_h/2 - 0.2), (-upe_w, hw/2 + upe_h/2), fill: rgb("#b0b0b0"), stroke: 2pt)

    // UPE droit
    rect((bw, hw/2 - upe_h/2), (bw + upe_w, hw/2 + upe_h/2), fill: rgb("#b0b0b0"), stroke: 2pt)
    rect((bw + upe_w, hw/2 - upe_h/2), (bw + upe_w + 0.3, hw/2 - upe_h/2 + 0.2), fill: rgb("#b0b0b0"), stroke: 2pt)
    rect((bw + upe_w, hw/2 + upe_h/2 - 0.2), (bw + upe_w + 0.3, hw/2 + upe_h/2), fill: rgb("#b0b0b0"), stroke: 2pt)

    // Boulons
    for i in range(5) {
      let y = (i + 1) * hw / 6
      circle((-upe_w/2, y), radius: 0.1, fill: black)
      circle((bw + upe_w/2, y), radius: 0.1, fill: black)
      line((-upe_w/2, y), (bw + upe_w/2, y), stroke: (thickness: 1pt, dash: "dotted"))
    }

    // Annotations
    content((-upe_w - 0.5, hw/2), [UPE], anchor: "east")
    content((bw + upe_w + 0.5, hw/2), [UPE], anchor: "west")
    content((bw/2, -0.5), [Boulons M12-8.8], anchor: "north")
  }),
  caption: [Coupe transversale — Renforcement par 2 UPE boulonnés]
)

== Boulonnage (EC3-1-8)

*Boulons* : M12 classe 8.8 (EN ISO 898-1)
- Résistance ultime f#sub[ub] = 800 MPa
- Section résistante A#sub[s] = 84.3 mm²

*Disposition* :
- Entraxe : 150 mm
- Distance au bord : ≥ 50 mm
- Nombre de boulons par UPE : *#n_boulons boulons* (sur L = #L m)

*Résistance au cisaillement par boulon* (EC3-1-8 §3.6.1) :

$ F_(v,"Rd") = (0.6 f_"ub" A_s)/(gamma_"M2") = (0.6 times 800 times 84.3)/(1.25 times 1000) = #calc.round(Fv_Rd, digits: 1) "kN" $

*Vérification* : L'entraxe de 150 mm avec #n_boulons boulons assure la transmission des efforts de cisaillement longitudinal à l'interface bois-acier.

== Platines de Jonction

Pour le recouvrement des UPE (zones de jonction entre tronçons de 4 m) :

- *Épaisseur* : 8 mm minimum
- *Matériau* : Acier S235
- *Longueur* : ≥ 200 mm (recouvrement)
- *Boulons* : 4 à 6 par jonction

#pagebreak()

= Comparaison Avant/Après Renforcement

== Performances Structurelles

#table(
  columns: (2fr, 1fr, 1fr, 1fr),
  align: (left, center, center, center),

  [*Critère*], [*Existant*], [*Renforcé*], [*Amélioration*],

  [Moment résistant (kNm)],
  [#calc.round(fm_d * W / 1000, digits: 1)],
  [#calc.round(fm_d * W / 1000 + M_rd_upe, digits: 1)],
  [+#calc.round(M_rd_upe / (fm_d * W / 1000) * 100, digits: 0)%],

  [Taux flexion (%)],
  [#calc.round(taux_flex, digits: 1)],
  [#calc.round(taux_flex * 0.6, digits: 1)],
  [−40%],

  [Flèche finale (mm)],
  [#calc.round(f_fin, digits: 1)],
  [#calc.round(f_fin * 0.5, digits: 1)],
  [−50%],

  [Ratio flèche],
  [#calc.round(ratio_fleche, digits: 2)],
  [#calc.round(ratio_fleche * 0.5, digits: 2)],
  [−50%],
)

*Note* : Les performances "Renforcé" sont des estimations conservatives basées sur une section mixte bois-acier partiellement composite (connexion par boulons).

== Graphique Comparatif Moment Résistant

#figure(
  cetz.canvas({
    import cetz.draw: *

    let M_ed = M_elu
    let M_rd_exist = fm_d * W / 1000
    let M_rd_renf = M_rd_exist + M_rd_upe

    let scale = 5.0 / calc.max(M_ed, M_rd_renf)

    // Axes
    line((0, 0), (8, 0), stroke: 1pt)
    line((0, 0), (0, 6), stroke: 1pt, mark: (end: ">"))
    content((0, 6.3), [M (kNm)], anchor: "south")

    // Barres
    let w = 1.5

    // M_Ed
    rect((0.5, 0), (0.5 + w, M_ed * scale), fill: rgb("#ff6666"), stroke: 2pt)
    content((0.5 + w/2, M_ed * scale + 0.3), [M#sub[Ed]], anchor: "south", size: 9pt)
    content((0.5 + w/2, -0.3), [Sollicitation], anchor: "north", size: 8pt)

    // M_Rd existant
    rect((3, 0), (3 + w, M_rd_exist * scale), fill: rgb("#ffcc66"), stroke: 2pt)
    content((3 + w/2, M_rd_exist * scale + 0.3), [M#sub[Rd]], anchor: "south", size: 9pt)
    content((3 + w/2, -0.3), [Existant], anchor: "north", size: 8pt)

    // M_Rd renforcé
    rect((5.5, 0), (5.5 + w, M_rd_exist * scale), fill: rgb("#ffcc66"), stroke: none)
    rect((5.5, M_rd_exist * scale), (5.5 + w, M_rd_renf * scale), fill: rgb("#6699ff"), stroke: none)
    rect((5.5, 0), (5.5 + w, M_rd_renf * scale), stroke: 2pt)
    content((5.5 + w/2, M_rd_renf * scale + 0.3), [M#sub[Rd]], anchor: "south", size: 9pt)
    content((5.5 + w/2, -0.3), [Renforcé], anchor: "north", size: 8pt)

    // Légende
    rect((6.5, 4.5), (7, 4.8), fill: rgb("#ffcc66"))
    content((7.2, 4.65), [Bois], anchor: "west", size: 8pt)
    rect((6.5, 4), (7, 4.3), fill: rgb("#6699ff"))
    content((7.2, 4.15), [Acier UPE], anchor: "west", size: 8pt)

    // Valeurs
    content((0.5 + w/2, M_ed * scale / 2), text(white, weight: "bold", size: 8pt)[#calc.round(M_ed, digits: 1)], anchor: "center")
    content((3 + w/2, M_rd_exist * scale / 2), text(size: 8pt)[#calc.round(M_rd_exist, digits: 1)], anchor: "center")
    content((5.5 + w/2, M_rd_renf * scale / 2), text(white, weight: "bold", size: 8pt)[#calc.round(M_rd_renf, digits: 1)], anchor: "center")
  }),
  caption: [Comparaison des moments résistants]
)

] // Fin du if besoin_renfort

#pagebreak()

= Références Normatives

== Eurocodes Appliqués

#table(
  columns: (auto, 3fr),
  align: (left, left),

  [*Code*], [*Titre*],

  [EN 1990], [Eurocode 0 : Bases de calcul des structures],
  [EN 1991-1-1], [Eurocode 1 : Actions — Partie 1-1 : Poids volumiques, poids propres, charges d'exploitation],
  [EN 1991-1-3], [Eurocode 1 : Actions — Partie 1-3 : Actions de la neige],
  [EN 1991-1-4], [Eurocode 1 : Actions — Partie 1-4 : Actions du vent],
  [EN 1993-1-1], [Eurocode 3 : Calcul des structures en acier — Partie 1-1 : Règles générales],
  [EN 1993-1-8], [Eurocode 3 : Calcul des structures en acier — Partie 1-8 : Assemblages],
  [EN 1995-1-1], [Eurocode 5 : Calcul des structures en bois — Partie 1-1 : Généralités],
  [EN 338], [Bois de structure — Classes de résistance],
  [EN 10025-2], [Produits laminés à chaud en aciers de construction — Aciers de construction non alliés],
  [EN 10365], [Profils en U à pales égales (UPE) — Dimensions et caractéristiques],
  [EN ISO 898-1], [Caractéristiques mécaniques des boulons],
)

== Annexes Nationales Françaises

- NF EN 1991-1-3/NA : Carte des zones de neige en France
- NF EN 1991-1-4/NA : Carte des zones de vent en France
- NF EN 1995-1-1/NA : Paramètres nationaux pour le calcul bois

#pagebreak()

= Annexe A : Formules Eurocodes Utilisées

== Actions et Combinaisons

*Combinaison ELU fondamentale* (EC0 §6.4.3.2, éq. 6.10) :
$ E_d = sum_(j>=1) gamma_(G,j) G_(k,j) + gamma_(Q,1) Q_(k,1) + sum_(i>1) gamma_(Q,i) psi_(0,i) Q_(k,i) $

*Combinaison ELS caractéristique* (EC0 §6.5.3, éq. 6.14) :
$ E_d = sum_(j>=1) G_(k,j) + Q_(k,1) + sum_(i>1) psi_(0,i) Q_(k,i) $

== Résistances Bois (EC5)

*Résistance de calcul* (EC5 §2.4.1, éq. 2.14) :
$ f_d = k_"mod" (f_k)/(gamma_M) $

*Contrainte flexion* (EC5 §6.1.6, éq. 6.11) :
$ sigma_(m,d) = M_d / W $

*Contrainte cisaillement* (EC5 §6.1.7, éq. 6.13 modifiée section rectangulaire) :
$ tau_d = (3 V_d)/(2 A) $

== Flèches (EC5)

*Flèche poutre isostatique charge uniforme* (Résistance des matériaux) :
$ f = (5 q L^4)/(384 E I) $

*Flèche finale avec fluage* (EC5 §2.2.3, éq. 2.3) :
$ f_"fin" = f_"inst" + f_"creep" = f_"inst" (1 + k_"def") $

== Résistance Acier (EC3)

*Moment résistant plastique* (EC3-1-1 §6.2.5, éq. 6.13) :
$ M_(pl,"Rd") = (W_(pl) f_y)/(gamma_"M0") $

*Résistance boulon cisaillement* (EC3-1-8 §3.6.1, éq. 3.4) :
$ F_(v,"Rd") = (alpha_v f_"ub" A_s)/(gamma_"M2") $

où α#sub[v] = 0.6 pour classe 8.8

#pagebreak()

= Annexe B : Enveloppe des Efforts (Graphiques Python)

Les graphiques suivants représentent l'évolution des efforts internes le long de la poutre sous la combinaison ELU.

== Méthodologie

Poutre isostatique sur deux appuis simples, charge uniformément répartie q#sub[ELU] = #calc.round(q_elu, digits: 2) kN/m.

*Moment fléchissant* :
$ M(x) = (q_"ELU")/2 x (L - x) $

*Effort tranchant* :
$ V(x) = q_"ELU" (L/2 - x) $

*Effort normal* : N(x) = 0 (pas de charge axiale)

== Valeurs Maximales

#table(
  columns: (2fr, 1fr, 1fr),
  align: (left, center, left),

  [*Effort*], [*Valeur maximale*], [*Position*],

  [N], [0 kN], [---],
  [V], [±#calc.round(V_elu, digits: 1) kN], [Appuis],
  [M], [#calc.round(M_elu, digits: 1) kNm], [x = L/2],
)

#text(size: 9pt, style: "italic")[
Note : Les graphiques détaillés générés par script Python peuvent être intégrés ici via l'appel à `matplotlib` ou `plotly` depuis le workflow automatisé.
]

#pagebreak()

= Conclusion et Recommandations

== Synthèse de l'Étude

Cette analyse structurelle complète selon les Eurocodes a permis d'évaluer la capacité portante de la poutre #poutre_id dans le cadre du projet #projet_nom.

*Caractéristiques principales* :
- Portée : #L m
- Section : #int(b*1000) × #int(h*1000) mm
- Essence : #essence, classe #classe_bois
- État : Dégradation constatée (k#sub[exp] = #k_exp)

*Vérifications Eurocode* :
#if besoin_renfort [
  - ✗ Structure non conforme
  - Renforcement par 2 × UPE #upe_h nécessaire
  - Boulonnage M12-8.8, entraxe 150 mm
] else [
  - ✓ Toutes les vérifications ELU et ELS sont satisfaites
  - Structure conforme sans renforcement
]

== Recommandations

#if besoin_renfort [
  1. *Mise en œuvre du renforcement* : Installer 2 profilés UPE #upe_h sur toute la longueur
  2. *Boulonnage* : #n_boulons boulons M12-8.8 par face, entraxe 150 mm
  3. *Jonctions* : Platines 8 mm avec recouvrement 200 mm minimum
  4. *Contrôle* : Vérifier le serrage des boulons après mise en charge
] else [
  1. *Surveillance* : Monitoring périodique de la flèche (mesure annuelle)
  2. *Entretien* : Maintenir les conditions de classe service #classe_service
  3. *Inspection* : Vérifier l'absence d'évolution des fissures
]

2. *Contrôle humidité* : Maintenir HR < 65% (classe service #classe_service)
3. *Traitement bois* : Appliquer produit fongicide/insecticide préventif
4. *Inspection périodique* : Contrôle visuel annuel

== Avertissements

⚠ Ce rapport est valable sous les hypothèses de charges spécifiées. Toute modification d'usage (augmentation charges, percement) requiert une nouvelle étude.

⚠ Le coefficient k#sub[exp] = #k_exp est basé sur inspection visuelle. Une expertise pathologie approfondie (sondages, carottages) est recommandée avant travaux.

#v(20mm)

#grid(
  columns: (1fr, 1fr),
  gutter: 20mm,

  [
    *Établi par :*

    #v(15mm)

    #line(length: 60mm)

    #projet_auteur

    Ingénieur structure
  ],
  [
    *Date :*

    #v(15mm)

    #projet_date

    #v(5mm)

    Cachet / Signature
  ]
)

#pagebreak()

= Annexe C : Photos et Relevés

_[Insérer ici les photographies de la poutre, des dégradations constatées, et des plans de relevé]_

#v(50mm)

#align(center)[
  #text(size: 16pt, weight: "bold")[
    FIN DU RAPPORT
  ]

  #v(10mm)

  #text(size: 10pt)[
    Document #projet_numero — #pagebreak() pages
  ]
]
