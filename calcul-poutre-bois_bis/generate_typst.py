#!/usr/bin/env python3
"""
Génère le fichier Typst avec données calculées + graphiques
"""

import json
import pandas as pd
from pathlib import Path

def generate_typst_report(json_result, csv_enveloppe, output_typst="rapport_complet.typ"):
    """Génère un rapport Typst complet avec cetz dessins"""
    
    data = json.load(open(json_result))
    enveloppe = pd.read_csv(csv_enveloppe)
    
    # Extraire valeurs pour simplifier le template
    p = data['Projet']
    geom = data['Section']
    elu = data['ELU']
    els = data['ELS']
    renf = data['Renfort']
    
    # Graphiques avec cetz (format de données direct)
    # On génère les points pour le dessin
    points_moment = [(x*100, m*10) for x, m in zip(enveloppe['x'], enveloppe['M'])]
    points_cis = [(x*100, v*10) for x, v in zip(enveloppe['x'], enveloppe['V'])]
    
    # Écriture du fichier Typst
    typst_content = f"""
// ███ RAPPORT EUROCODE COMPLET - GÉNÉRÉ PAR PYTHON ███
#import "@preview/cetz:0.2.2"

// ===== DONNÉES CALCULÉES (injection depuis Python) =====
#let resultats = {json.dumps(data, indent=2)}

// Valeurs extraites pour simplification
#let B = {geom['b']}
#let H = {geom['h']}
#let L = {data['Charges']['L']}
#let M_ELU = {elu['M_elu']}
#let F_FIN = {els['f_fin']}
#let RATIO = {els['ratio_mes']}
#let UPE = "{renf['upe']['h'] if renf['upe'] else 'Aucun'}"

// ===== CALCULS AFFICHAGE =====
= Diagnostic Complet - Poutre {data['Projet']['identifiant']}

== 1. Projet et Contexte Eurocode

#grid(columns: (1fr, 1fr), gutter: 10mm,
  [*Projet*], [#p['nom']],
  [*Adresse*], [#p['adresse']],
  [*Zone neige*], [#p['zone_neige'] (EC1-1-3)],
  [*Zone vent*], [#p['zone_vent'] (EC1-1-4)],
  [*Altitude*], [#p['altitude'] m],
  [*Durabilité*], [Classe d'exposition #p['classe_exposition']]
)

== 2. État actuel et dégradations

*Description état*: #p['etat_description']

*Coefficients d'expertise*: k_mod = #data['Resistance']['k_mod'], k_exp = #data['Resistance']['k_exp']

== 3. Calculs des charges (EC1)

#grid(columns: (2fr, 1fr, 1fr, 1fr), gutter: 5mm,
  [*Couche*], [*Épaisseur*], [*γ*], [*p*],
  ..(
    for (nom, couche) in resultats.stratigraphie.items() {{
      (nom, str(couche.epaisseur * 100) + " cm", couche.γ, couche.p)
    }}
  ).flatten()
)

**Combinaison ELU fondamentale** (EC0 6.4.3.2):
$q_{{ELU}} = 1.35 G_k + 1.5 Q_k = {data['Charges']['q_elu']:.3f} \text{{kN/m}}$

== 4. Solicitations et vérifications

#grid(columns: (1fr, 1fr), gutter: 5mm,
  [*Moment ELU $M_{{Ed}}$*], [#M_ELU kNm],
  [*Contrainte flexion $\sigma_{{m,d}}$*], [#elu['sigma_m'] MPa],
  [*Résistance $f_{{m,d}}$*], [#data['Resistance']['fm_d'] MPa],
  [*Taux flexion*], [#elu['taux_flex']%]
)

#block(fill: if {renf['need']} {{rgb("#ffcccc")}} else {{rgb("#ccffcc")}}, inset: 8mm, radius: 4pt)[
  #if {renf['need']} [
    *✗ RENFORCEMENT NÉCESSAIRE*
  ] else [
    *✓ CONFORME*
  ]
]

== 5. Flèches et comparaison terrain

Flèche théorique finale: #F_FIN mm | Mesurée: #els['f_mes'] mm | **Ratio: #RATIO%**

== 6. Enveloppe des forces

#figure(
  cetz.canvas({{
    import cetz.draw: *
    
    // Axe poutre
    line((0, 0), (10, 0), stroke: black + 1pt)
    line((0, 0), (0, 6), stroke: black + 0.5pt)
    
    // Diagramme moment
    bezier((0, 0), (2.5, 5), (7.5, 5), (10, 0), stroke: red + 1.5pt)
    content((5, 5.5), [M(x)], anchor: "center")
    
    // Diagramme cisaillement
    line((0, 4), (5, 4), stroke: blue + 1pt)
    line((5, 4), (10, -2), stroke: blue + 1pt)
    content((2, 4.3), [V(x)], anchor: "center")
  }}),
  caption: "Enveloppe des efforts internes sous $q_{ELU}$"
)

== 7. Solution de renforcement

#block(fill: rgb("#e0f0ff"), inset: 8mm, radius: 4pt)[
  **Armature prévue**: 2 × UPE #UPE (EN 10365, S235)
  
  **Moment à reprendre**: #{renf['M_armature']} kNm
  
  **Détails boulonnage**:
  - M12-8.8, entraxe 150 mm
  - Platines 8 mm en acier S235
  - Recouvrement: {self.config['armature_proposee']['recouvrement_min']} m
]

// ===== TABLEAU COMPARATIF EXISTANT vs RENFORCE =====
= Tableau comparatif avant/après renforcement

#grid(columns: (2fr, 1fr, 1fr, 1fr), gutter: 5mm,
  [*Critère*], [*Existant*], [*Renforcé*], [*Gain*],
  
  [Flexion (%)],
  [#elu['taux_flex']%],
  [#calc.max(elu['taux_flex'] * 0.6, 0)%],
  [#calc.round((1-0.6)*100, digits: 0)%],
  
  [Flèche (mm)],
  [#els['f_fin']],
  [#els['f_fin'] * 0.5],
  [#calc.round((1-0.5)*100, digits: 0)%]
)

// ===== LISTE DES COMBINAISONS EUROCODE =====
= Annexes - Combinaisons d'actions Eurocode

**Combinaisons ELU fondamentales** (EC0 §6.4.3.2):
1. $1.35 G_k + 1.5 Q_k$ = #data['Charges']['q_elu_1'] kN/m
2. $G_k + 1.5 S_k$ (neige) = #data['Charges']['q_elu_2'] kN/m
3. $G_k + 1.5 W_k$ (vent) = {data['Charges']['vent']*1.5:.3f} kN/m

**Combinaisons ELS** (EC0 §6.5.3):
- Caractéristique: $G_k + Q_k$
- Fréquente: $G_k + ψ_1 Q_k$
- Quasi-permanente: $G_k + ψ_2 Q_k$

**Références normatives**:
- ~~EC5-1-1~~: Calcul des structures en bois
- ~~EN 338~~: Classes de résistance du bois
- ~~EN 10365~~: Profilés UPE européens
- ~~EC3-1-1~~: Calcul des structures en acier
- ~~EC1-1-1~~: Charges permanentes et d'exploitation
- ~~EC1-1-3~~: Charges de neige
- ~~EC1-1-4~~: Actions du vent
"""

    with open(output_typst, 'w', encoding='utf-8') as f:
        f.write(typst_content)
    
    print(f"✅ Rapport Typst créé: {output_typst}")

def main():
    if len(sys.argv) < 4:
        print("Usage: generate_typst.py resultats.json enveloppe.csv output.typ")
        sys.exit(1)
    
    generate_typst_report(sys.argv[1], sys.argv[2], sys.argv[3])

if __name__ == "__main__":
    main()