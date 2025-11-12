#!/usr/bin/env python3
"""
Génère le fichier Typst avec données calculées + graphiques
Usage: generate_typst.py resultats.json enveloppe.csv output.typ
"""

import sys
import json
import pandas as pd
from pathlib import Path


def generate_typst_report(json_file, csv_file, output_typ):
    """Génère un rapport Typst complet à partir des calculs"""

    # Charger les données
    with open(json_file, 'r') as f:
        data = json.load(f)

    enveloppe = pd.read_csv(csv_file)

    # Extraire les données pour simplifier
    projet = data['Projet']
    section = data['Section']
    charges = data['Charges']
    resistance = data['Resistance']
    elu = data['ELU']
    els = data['ELS']
    renfort = data['Renfort']

    # Créer le contenu Typst
    typst_content = f"""// ███████████████████████████████████████████████████████████████████████████████
// RAPPORT COMPLET D'ANALYSE STRUCTURELLE - GÉNÉRÉ AUTOMATIQUEMENT
// ███████████████████████████████████████████████████████████████████████████████

#import "@preview/cetz:0.2.2"

#set page(paper: "a4", margin: 25mm, numbering: "1")
#set text(font: "New Computer Modern", size: 10pt, lang: "fr")
#set par(justify: true)
#set heading(numbering: "1.1.")

// ═══════════════════════════════════════════════════════════════════════════════
// DONNÉES CALCULÉES (depuis Python/JSON)
// ═══════════════════════════════════════════════════════════════════════════════

#let projet_nom = "{projet['nom']}"
#let projet_numero = "{projet['numero_dossier']}"
#let projet_auteur = "{projet['auteur']}"
#let projet_date = "{projet['date']}"
#let projet_type = "{projet['type_ouvrage']}"
#let poutre_id = "{projet['identifiant']}"

// Localisation
#let loc_adresse = "{projet['adresse']}"
#let loc_zone_neige = "{projet['zone_neige']}"
#let loc_zone_vent = "{projet['zone_vent']}"
#let loc_altitude = {projet['altitude']}

// État poutre
#let etat_description = "{projet['etat_description']}"

// Géométrie
#let L = {charges['L']}
#let b = {section['b']}
#let h = {section['h']}
#let A = {section['A']}
#let I = {section['I']}
#let W = {section['W']}

// Charges
#let gk = {charges['gk']}
#let qk = {charges['qk']}
#let q_elu = {charges['q_elu']}
#let q_elu_1 = {charges['q_elu_1']}
#let q_elu_2 = {charges['q_elu_2']}
#let q_els_char = {charges['q_els_char']}

// Résistances
#let k_mod = {resistance['k_mod']}
#let k_exp = {resistance['k_exp']}
#let fm_k = {resistance['fm_k']}
#let fm_d = {resistance['fm_d']}
#let fv_d = {resistance['fv_d']}
#let E_d = {resistance['E_d']}

// Sollicitations ELU
#let M_elu = {elu['M_elu']}
#let V_elu = {elu['V_elu']}
#let sigma_m = {elu['sigma_m']}
#let tau = {elu['tau']}
#let taux_flex = {elu['taux_flex']}
#let taux_cis = {elu['taux_cis']}

// Flèches ELS
#let f_inst = {els['f_inst']}
#let f_fin = {els['f_fin']}
#let f_lim = {els['f_lim']}
#let f_mes = {els['f_mes']}
#let ratio_mes = {els['ratio_mes']}
#let k_def = {els['k_def']}

// Renforcement
#let besoin_renfort = {str(renfort['need']).lower()}
#let M_armature = {renfort['M_armature']}
"""

    # Ajouter données UPE si renforcement nécessaire
    if renfort['need'] and renfort['upe']:
        upe = renfort['upe']
        typst_content += f"""#let upe_h = {upe['h']}
#let upe_wel = {upe['Wel']}
#let upe_poids = {upe['poids']}
#let upe_mrd = {upe['M_rd']}
"""
    else:
        typst_content += """#let upe_h = 0
#let upe_wel = 0
#let upe_poids = 0
#let upe_mrd = 0
"""

    # Ajouter le corps du rapport
    typst_content += """
// ═══════════════════════════════════════════════════════════════════════════════
// PAGE DE TITRE
// ═══════════════════════════════════════════════════════════════════════════════

#align(center)[
  #v(40mm)
  #text(size: 20pt, weight: "bold")[
    RAPPORT D'ANALYSE STRUCTURELLE\\
    RENFORCEMENT POUTRE BOIS
  ]

  #v(10mm)
  #text(size: 14pt)[Calculs selon Eurocodes 0, 1, 3 et 5]

  #v(20mm)
  #box(width: 100%, stroke: 1pt + black, inset: 10mm)[
    #grid(
      columns: (1fr, 2fr),
      gutter: 8mm,
      align: (right, left),
      [*Projet :*], [#projet_nom],
      [*N° dossier :*], [#projet_numero],
      [*Poutre :*], [#poutre_id],
      [*Localisation :*], [#loc_adresse],
      [*Auteur :*], [#projet_auteur],
      [*Date :*], [#projet_date],
    )
  ]
]

#pagebreak()

#outline(indent: auto)

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
// CORPS DU RAPPORT
// ═══════════════════════════════════════════════════════════════════════════════

= Contexte du Projet

== Identification

#grid(
  columns: (1fr, 2fr),
  gutter: 8mm,
  [*Projet :*], [#projet_nom],
  [*N° dossier :*], [#projet_numero],
  [*Type :*], [#projet_type],
  [*Poutre :*], [#poutre_id],
  [*Localisation :*], [#loc_adresse],
)

== Paramètres Eurocode

#grid(
  columns: (auto, auto, auto),
  gutter: 8mm,
  align: left,
  [*Paramètre*], [*Valeur*], [*Référence*],
  [Zone neige], [#loc_zone_neige], [EC1-1-3],
  [Zone vent], [Zone #loc_zone_vent], [EC1-1-4],
  [Altitude], [#loc_altitude m], [---],
)

== État de la Poutre

#text(style: "italic")[#etat_description]

*Coefficient de dégradation* : k#sub[exp] = #k_exp

#pagebreak()

= Géométrie et Propriétés

== Dimensions

#table(
  columns: (2fr, 1fr, 1fr),
  align: (left, center, left),
  [*Propriété*], [*Valeur*], [*Unité*],
  [Portée L], [#L], [m],
  [Largeur b], [#calc.round(b*1000, digits: 0)], [mm],
  [Hauteur h], [#calc.round(h*1000, digits: 0)], [mm],
  [Aire A], [#calc.round(A, digits: 4)], [m²],
  [Inertie I], [#calc.round(I, digits: 5)], [m⁴],
  [Module W], [#calc.round(W, digits: 5)], [m³],
)

== Schéma Structural

#figure(
  cetz.canvas({{
    import cetz.draw: *
    let scale = 1.2
    let Lplot = L * scale
    let hplot = 0.8

    // Appuis
    line((0, 0), (0.3, -0.3), stroke: 2pt)
    line((0, 0), (-0.3, -0.3), stroke: 2pt)
    line((Lplot, 0), (Lplot, -0.3), stroke: 2pt)
    circle((Lplot, 0), radius: 0.15, fill: white, stroke: 2pt)

    // Poutre
    rect((0, 0), (Lplot, hplot), fill: rgb("#d4a574"), stroke: 2pt)

    // Charge répartie
    for i in range(15) {{
      let x = i * Lplot / 14
      line((x, hplot + 0.3), (x, hplot), stroke: (paint: red, thickness: 1.5pt), mark: (end: ">"))
    }}

    content((Lplot/2, -0.7), [L = #L m], anchor: "center")
    content((Lplot/2, hplot + 0.8), text(fill: red)[q (kN/m)], anchor: "center")
  }}),
  caption: [Schéma structural — Poutre sur deux appuis simples]
)

#pagebreak()

= Calcul des Charges (EC1)

== Charges Permanentes et d'Exploitation

#table(
  columns: (2fr, 1fr, 1fr),
  align: (left, center, left),
  [*Type*], [*Valeur*], [*Unité*],
  [Charges permanentes G#sub[k]], [#calc.round(gk, digits: 2)], [kN/m],
  [Charges exploitation Q#sub[k]], [#calc.round(qk, digits: 2)], [kN/m],
)

== Combinaisons d'Actions

=== États Limites Ultimes (EC0 §6.4.3.2)

1. *Fondamentale* : $ 1.35 G_k + 1.5 Q_k = #calc.round(q_elu_1, digits: 2) "kN/m" $

2. *Neige dominante* : $ G_k + 1.5 S_k = #calc.round(q_elu_2, digits: 2) "kN/m" $

#box(fill: rgb("#ffffcc"), inset: 10mm, width: 100%)[
  *Combinaison ELU retenue* (maximum) :
  $ q_("ELU") = #calc.round(q_elu, digits: 2) "kN/m" $
]

=== États Limites de Service

*Caractéristique* : $ G_k + Q_k = #calc.round(q_els_char, digits: 2) "kN/m" $

#pagebreak()

= Caractéristiques des Matériaux

== Bois (EN 338)

#table(
  columns: (2fr, 1fr, 1fr),
  align: (left, center, left),
  [*Propriété*], [*Valeur*], [*Unité*],
  [f#sub[m,k] (caractéristique)], [#fm_k], [MPa],
  [k#sub[mod] (modification)], [#k_mod], [---],
  [k#sub[exp] (dégradation)], [#k_exp], [---],
  [γ#sub[M] (partiel)], [1.25], [---],
  [f#sub[m,d] (calcul)], [#calc.round(fm_d, digits: 2)], [MPa],
  [E#sub[d] (calcul)], [#calc.round(E_d, digits: 0)], [MPa],
)

*Résistance de calcul* (EC5 §2.4.1) :
$ f_(m,d) = (k_"mod" times f_(m,k))/(gamma_M) times k_"exp" = (#k_mod times #fm_k)/1.25 times #k_exp = #calc.round(fm_d, digits: 2) "MPa" $

#pagebreak()

= Vérifications ELU

== Sollicitations

Pour une poutre sur deux appuis simples sous charge uniforme :

*Moment maximal* :
$ M_"Ed" = (q_"ELU" L^2)/8 = (#calc.round(q_elu, digits: 2) times #L^2)/8 = #calc.round(M_elu, digits: 2) "kNm" $

*Effort tranchant* :
$ V_"Ed" = (q_"ELU" L)/2 = (#calc.round(q_elu, digits: 2) times #L)/2 = #calc.round(V_elu, digits: 2) "kN" $

== Vérification Flexion

*Contrainte* :
$ sigma_(m,d) = M_"Ed" / W = #calc.round(sigma_m, digits: 2) "MPa" $

*Critère* : $ sigma_(m,d) <= f_(m,d) $

#box(
  fill: if taux_flex <= 100 {{ rgb("#ccffcc") }} else {{ rgb("#ffcccc") }},
  inset: 8mm,
  width: 100%
)[
  *Taux de travail en flexion* : #calc.round(taux_flex, digits: 1)%

  #if taux_flex <= 100 [
    ✓ *VÉRIFIÉ*
  ] else [
    ✗ *NON VÉRIFIÉ* — Renforcement nécessaire
  ]
]

== Vérification Cisaillement

*Contrainte* :
$ tau_d = (3 V_"Ed")/(2 A) = #calc.round(tau, digits: 2) "MPa" $

*Critère* : $ tau_d <= f_(v,d) $

#box(
  fill: if taux_cis <= 100 {{ rgb("#ccffcc") }} else {{ rgb("#ffcccc") }},
  inset: 8mm,
  width: 100%
)[
  *Taux de travail cisaillement* : #calc.round(taux_cis, digits: 1)%

  #if taux_cis <= 100 [
    ✓ *VÉRIFIÉ*
  ] else [
    ✗ *NON VÉRIFIÉ*
  ]
]

#pagebreak()

= Vérifications ELS

== Flèches

*Flèche instantanée* :
$ f_"inst" = (5 q_"ELS" L^4)/(384 E_d I) = #calc.round(f_inst*1000, digits: 1) "mm" $

*Flèche finale avec fluage* (k#sub[def] = #k_def) :
$ f_"fin" = f_"inst" (1 + k_"def") = #calc.round(f_fin*1000, digits: 1) "mm" $

*Flèche limite* (L/250) :
$ f_"lim" = L/250 = #calc.round(f_lim*1000, digits: 1) "mm" $

#box(
  fill: if f_fin <= f_lim {{ rgb("#ccffcc") }} else {{ rgb("#ffcccc") }},
  inset: 8mm,
  width: 100%
)[
  *Critère* : $ f_"fin" #if f_fin <= f_lim [<=] else [>] f_"lim" $

  #if f_fin <= f_lim [
    ✓ *VÉRIFIÉ* — Flèche acceptable
  ] else [
    ✗ *NON VÉRIFIÉ* — Flèche excessive
  ]
]

== Comparaison Mesure Terrain

*Flèche mesurée* : #calc.round(f_mes*1000, digits: 1) mm

*Ratio mesure/théorie* : #calc.round(ratio_mes, digits: 2)

#if ratio_mes > 1.2 [
  #box(fill: rgb("#fff3cd"), inset: 8mm, width: 100%)[
    ⚠ *ATTENTION* — Flèche mesurée significativement supérieure
  ]
] else if ratio_mes < 0.8 [
  #box(fill: rgb("#d1ecf1"), inset: 8mm, width: 100%)[
    ℹ Flèche mesurée inférieure (favorable)
  ]
] else [
  #box(fill: rgb("#d4edda"), inset: 8mm, width: 100%)[
    ✓ Cohérence mesure/théorie acceptable
  ]
]

#pagebreak()

= Diagrammes des Efforts

#figure(
  cetz.canvas({{
    import cetz.draw: *

    let Lplot = 10
    let hmax = 3

    // Axe x
    line((0, 0), (Lplot, 0), stroke: 1pt, mark: (end: ">"))
    content((Lplot + 0.3, 0), [x], anchor: "west")

    // Diagramme moment (parabole)
    let n = 50
    let pts = ()
    for i in range(n + 1) {{
      let xi = i / n * Lplot
      let Mi = hmax * (xi / Lplot) * (1 - xi / Lplot) * 4
      pts.push((xi, Mi))
    }}

    line(..pts, stroke: (paint: red, thickness: 2pt))
    content((Lplot/2, hmax + 0.3), text(fill: red)[M(x)], anchor: "south")
    content((Lplot/2, hmax/2), text(fill: red, size: 9pt)[M#sub[max] = #calc.round(M_elu, digits: 1) kNm], anchor: "center")

    line((0, -0.8), (Lplot, -0.8), stroke: 1pt, mark: (start: "|", end: "|"))
    content((Lplot/2, -0.8), [L = #L m], anchor: "north")
  }}),
  caption: [Diagramme du moment fléchissant M(x)]
)

#figure(
  cetz.canvas({{
    import cetz.draw: *

    let Lplot = 10
    let Vmax = 2

    // Axes
    line((0, 0), (Lplot, 0), stroke: 1pt, mark: (end: ">"))
    content((Lplot + 0.3, 0), [x], anchor: "west")
    line((0, -Vmax), (0, Vmax), stroke: 1pt, mark: (end: ">"))
    content((0, Vmax + 0.3), [V], anchor: "south")

    // Diagramme effort tranchant
    line((0, Vmax), (Lplot, -Vmax), stroke: (paint: blue, thickness: 2pt))

    content((0.5, Vmax), text(fill: blue, size: 9pt)[+#calc.round(V_elu, digits: 1) kN], anchor: "west")
    content((Lplot - 0.5, -Vmax), text(fill: blue, size: 9pt)[−#calc.round(V_elu, digits: 1) kN], anchor: "east")
  }}),
  caption: [Diagramme de l'effort tranchant V(x)]
)

#pagebreak()

= Synthèse et Décision

#table(
  columns: (2fr, 1fr, 1fr, 1fr),
  align: (left, center, center, center),
  [*Critère*], [*Valeur*], [*Limite*], [*État*],
  [Flexion ELU], [#calc.round(taux_flex, digits: 1)%], [100%], if taux_flex <= 100 [✓] else [✗],
  [Cisaillement ELU], [#calc.round(taux_cis, digits: 1)%], [100%], if taux_cis <= 100 [✓] else [✗],
  [Flèche ELS], [#calc.round((f_fin/f_lim), digits: 2)], [1.00], if f_fin <= f_lim [✓] else [✗],
  [Mesure terrain], [#calc.round(ratio_mes, digits: 2)], [1.20], if ratio_mes <= 1.2 [✓] else [✗],
)

#v(10mm)

#box(
  fill: if besoin_renfort {{ rgb("#ffdddd") }} else {{ rgb("#ddffdd") }},
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
    La poutre ne satisfait pas aux critères Eurocode.\\
    Un renforcement par profilés métalliques est requis.
  ] else [
    La poutre satisfait à tous les critères de vérification Eurocode.
  ]
]

"""

    # Ajouter section renforcement si nécessaire
    if renfort['need']:
        typst_content += """
#pagebreak()

= Dimensionnement du Renforcement

== Principe

Renforcement par 2 profilés UPE (U à Pales Égales) symétriques, solidarisés par boulons M12 classe 8.8.

*Moment à reprendre* : $ M_"renfort" = #calc.round(M_armature, digits: 2) "kNm" $

== Profilé Retenu

#box(fill: rgb("#e8f4f8"), inset: 10mm, width: 100%)[
  *Profilé* : *2 × UPE #upe_h* (EN 10365)

  - Hauteur : #upe_h mm
  - Module élastique : #upe_wel cm³ (par UPE)
  - Poids linéique : #upe_poids kg/m (par UPE)
  - Acier : S235 (f#sub[y] = 235 MPa)

  *Moment résistant* : *#calc.round(upe_mrd, digits: 1) kNm* ✓
]

== Schéma de Principe

#figure(
  cetz.canvas({{
    import cetz.draw: *

    let bw = 4
    let hw = 5
    let upe_w = 0.5
    let upe_h_plot = 1.2

    // Poutre bois
    rect((0, 0), (bw, hw), fill: rgb("#d4a574"), stroke: 2pt)
    content((bw/2, hw/2), [Poutre bois], anchor: "center")

    // UPE gauche
    rect((-upe_w, hw/2 - upe_h_plot/2), (0, hw/2 + upe_h_plot/2), fill: rgb("#b0b0b0"), stroke: 2pt)
    rect((-upe_w - 0.3, hw/2 - upe_h_plot/2), (-upe_w, hw/2 - upe_h_plot/2 + 0.2), fill: rgb("#b0b0b0"), stroke: 2pt)
    rect((-upe_w - 0.3, hw/2 + upe_h_plot/2 - 0.2), (-upe_w, hw/2 + upe_h_plot/2), fill: rgb("#b0b0b0"), stroke: 2pt)

    // UPE droit
    rect((bw, hw/2 - upe_h_plot/2), (bw + upe_w, hw/2 + upe_h_plot/2), fill: rgb("#b0b0b0"), stroke: 2pt)
    rect((bw + upe_w, hw/2 - upe_h_plot/2), (bw + upe_w + 0.3, hw/2 - upe_h_plot/2 + 0.2), fill: rgb("#b0b0b0"), stroke: 2pt)
    rect((bw + upe_w, hw/2 + upe_h_plot/2 - 0.2), (bw + upe_w + 0.3, hw/2 + upe_h_plot/2), fill: rgb("#b0b0b0"), stroke: 2pt)

    // Boulons
    for i in range(5) {{
      let y = (i + 1) * hw / 6
      circle((-upe_w/2, y), radius: 0.1, fill: black)
      circle((bw + upe_w/2, y), radius: 0.1, fill: black)
    }}

    content((-upe_w - 0.5, hw/2), [UPE], anchor: "east")
    content((bw + upe_w + 0.5, hw/2), [UPE], anchor: "west")
    content((bw/2, -0.5), [Boulons M12-8.8], anchor: "north")
  }}),
  caption: [Coupe transversale — Renforcement par 2 UPE]
)

== Boulonnage

- *Diamètre* : M12 classe 8.8
- *Entraxe* : 150 mm
- *Nombre* : #calc.ceil(L / 0.15) boulons par face
- *Platines jonction* : 8 mm, recouvrement 200 mm minimum

"""

    # Ajouter pied de page
    typst_content += """
#pagebreak()

= Références Normatives

#table(
  columns: (auto, 3fr),
  align: (left, left),
  [*Code*], [*Titre*],
  [EN 1990], [Eurocode 0 : Bases de calcul des structures],
  [EN 1991-1-1], [Eurocode 1 : Charges d'exploitation],
  [EN 1991-1-3], [Eurocode 1 : Actions de la neige],
  [EN 1991-1-4], [Eurocode 1 : Actions du vent],
  [EN 1993-1-1], [Eurocode 3 : Calcul structures acier],
  [EN 1995-1-1], [Eurocode 5 : Calcul structures bois],
  [EN 338], [Bois de structure — Classes de résistance],
  [EN 10365], [Profilés en U (UPE)],
)

#v(20mm)

#grid(
  columns: (1fr, 1fr),
  gutter: 20mm,
  [
    *Établi par :*

    #v(15mm)

    #line(length: 60mm)

    #projet_auteur
  ],
  [
    *Date :*

    #v(15mm)

    #projet_date
  ]
)

#align(center)[
  #v(20mm)
  #text(size: 12pt, weight: "bold")[FIN DU RAPPORT]
]
"""

    # Écrire le fichier
    with open(output_typ, 'w', encoding='utf-8') as f:
        f.write(typst_content)

    print(f"✅ Rapport Typst créé : {output_typ}")
    print(f"   - Projet : {projet['nom']}")
    print(f"   - Poutre : {projet['identifiant']}")
    print(f"   - Renforcement : {'OUI' if renfort['need'] else 'NON'}")
    if renfort['need'] and renfort['upe']:
        print(f"   - UPE : 2 × UPE {upe['h']}")


def main():
    if len(sys.argv) < 4:
        print("Usage: python generate_typst.py resultats.json enveloppe.csv output.typ")
        sys.exit(1)

    generate_typst_report(sys.argv[1], sys.argv[2], sys.argv[3])


if __name__ == "__main__":
    main()
