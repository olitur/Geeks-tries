#!/usr/bin/env python3
"""
Moteur de calcul Eurocode complet
Usage: calcul_eurocode.py poutre_001.toml
"""

import sys
import json
import toml
import numpy as np
import pandas as pd
from pathlib import Path
from datetime import datetime

class EurocodeCalculator:
    """Calculateur conforme Eurocode 5, 1, 3"""
    
    def __init__(self, toml_path):
        self.config = toml.load(toml_path)
        self.poutre = self.config['poutre_existante']
        self.L = self.poutre['longueur']
        self.b = self.poutre['largeur']
        self.h = self.poutre['hauteur']
        self.resultats = {}

        # Ajouter info projet
        self.resultats['Projet'] = {
            'nom': self.config['projet']['nom'],
            'numero_dossier': self.config['projet']['numero_dossier'],
            'auteur': self.config['projet']['auteur'],
            'date': self.config['projet']['date'],
            'type_ouvrage': self.config['projet']['type_ouvrage'],
            'identifiant': self.poutre['identifiant'],
            'adresse': f"{self.config['localisation_eurocode']['ville']}, {self.config['localisation_eurocode']['departement']}",
            'zone_neige': self.config['localisation_eurocode']['zone_neige'],
            'zone_vent': self.config['localisation_eurocode']['zone_vent'],
            'altitude': self.config['localisation_eurocode']['altitude'],
            'classe_exposition': self.config['exigences_durabilite']['classe_exposition'],
            'etat_description': self.config['degradations_etat']['description']
        }
        
    def calcul_charges(self):
        """EC1 - Calcul des charges permanentes et variables"""
        # Poids propres - calcul depuis stratigraphie
        strat = self.config['stratigraphie_plancher']
        gk_plancher = 0
        for key, layer in strat.items():
            if key != 'plafond' and isinstance(layer, dict):
                gk_plancher += layer.get('epaisseur', 0) * layer.get('poids_volumique', 0)

        # Ajouter plafond si existe
        if 'plafond' in strat:
            gk_plancher += strat['plafond'].get('epaisseur', 0) * strat['plafond'].get('poids_volumique', 0)

        gk_amenage = self.config['charges_permanentes']['amenagement']['valeur']
        gk_finitions = self.config['charges_permanentes']['finitions_additionnelles']['valeur']
        gk_total = gk_plancher + gk_amenage + gk_finitions

        # Charges linéiques (largeur poutre)
        self.gk = gk_total * self.b  # kN/m
        self.qk = self.config['charges_exploitation_eurocode']['qk'] * self.b

        # État neige (EC1-1-3)
        neige = self.config['actions_neige']['neige_sol_caract'] * self.config['actions_neige']['coeff_forme'] * self.b

        # État vent (EC1-1-4)
        vent = self.config['actions_vent']['pression_dynamique'] * self.b * 0.5

        # Combinaisons ELU (EC0 6.4.3.2)
        # Combinaison 1: 1.35G + 1.5Q
        self.q_elu_1 = 1.35 * self.gk + 1.5 * self.qk
        # Combinaison 2: G + 1.5N (si neige > Q)
        self.q_elu_2 = self.gk + 1.5 * neige
        # Combinaison 3: G + 1.5W (vent)
        self.q_elu_3 = self.gk + 1.5 * vent
        # Combinaison retenue = max
        self.q_elu = max(self.q_elu_1, self.q_elu_2, self.q_elu_3)

        # Combinaisons ELS
        psi_2 = self.config['charges_exploitation_eurocode']['psi_2']
        self.q_els_char = self.gk + self.qk
        self.q_els_qperm = self.gk + self.qk * psi_2

        self.resultats['Charges'] = {
            'L': self.L,
            'gk': float(self.gk),
            'qk': float(self.qk),
            'neige': float(neige),
            'vent': float(vent),
            'q_elu': float(self.q_elu),
            'q_elu_1': float(self.q_elu_1),
            'q_elu_2': float(self.q_elu_2),
            'q_elu_3': float(self.q_elu_3),
            'q_els_char': float(self.q_els_char)
        }
        
    def calcul_section(self):
        """Propriétés géométriques"""
        self.A = self.b * self.h
        self.I = self.b * self.h**3 / 12
        self.W = self.b * self.h**2 / 6
        self.resultats['Section'] = {
            'b': float(self.b),
            'h': float(self.h),
            'A': float(self.A),
            'I': float(self.I),
            'W': float(self.W)
        }
        
    def calcul_resistance(self):
        """EC5 - Résistance du bois"""
        classe_service = str(self.poutre['classe_service'])
        k_mod = 0.8 if classe_service == "2" else 0.6
        k_exp = self.config['degradations_etat']['reduction_coefficient']

        # D30 (EN 338)
        fm_k, fv_k, E_0_05 = 30.0, 3.0, 6700.0

        self.k_mod = k_mod
        self.k_exp = k_exp
        self.fm_d = k_mod * fm_k / 1.25 * k_exp  # EC5 2.4.1
        self.fv_d = k_mod * fv_k / 1.25 * k_exp
        self.E_d = E_0_05 * k_exp

        self.resultats['Resistance'] = {
            'fm_k': float(fm_k),
            'fv_k': float(fv_k),
            'E_0_05': float(E_0_05),
            'fm_d': float(self.fm_d),
            'fv_d': float(self.fv_d),
            'E_d': float(self.E_d),
            'k_mod': float(k_mod),
            'k_exp': float(k_exp)
        }
        
    def calcul_solicitations(self):
        """Sollicitations sous charges ELU"""
        self.M_elu = self.q_elu * self.L**2 / 8  # Poutre sur 2 appuis
        self.V_elu = self.q_elu * self.L / 2

        self.sigma_m = self.M_elu * 1000 / self.W  # kNm -> Nm, m³ -> mm³
        self.tau = 3 * self.V_elu * 1000 / (2 * self.A)

        self.taux_flex = self.sigma_m / self.fm_d * 100
        self.taux_cis = self.tau / self.fv_d * 100

        self.resultats['ELU'] = {
            'M_elu': float(self.M_elu),
            'V_elu': float(self.V_elu),
            'sigma_m': float(self.sigma_m),
            'tau': float(self.tau),
            'taux_flex': float(self.taux_flex),
            'taux_cis': float(self.taux_cis)
        }
        
    def calcul_fleches(self):
        """EC5 - Flèches ELS"""
        psi_2 = self.config['charges_exploitation_eurocode']['psi_2']
        classe_service = str(self.poutre['classe_service'])
        k_def = 0.8 if classe_service == "2" else 0.6

        self.f_inst = 5 * self.q_els_char * self.L**4 / (384 * self.E_d * self.I)
        self.f_fin = self.f_inst * (1 + k_def)  # EC5 2.2.3(5)
        self.f_lim = self.L / 250  # EC5 Tableau 7.2

        self.f_mes = self.config['mesures_terrain']['deflexion_mesuree']
        self.ratio_mes = self.f_mes / self.f_fin if self.f_fin > 0 else 0

        self.resultats['ELS'] = {
            'f_inst': float(self.f_inst),
            'f_fin': float(self.f_fin),
            'f_lim': float(self.f_lim),
            'f_mes': float(self.f_mes),
            'ratio_mes': float(self.ratio_mes),
            'k_def': float(k_def)
        }
        
    def calcul_renforcement(self):
        """EC3 - Dimensionnement armature UPE"""
        self.need_reinforce = (
            self.taux_flex > 100 or self.taux_cis > 100 or
            self.f_fin > self.f_lim or self.ratio_mes > 1.2
        )

        self.M_armature = 0
        self.upe_propose = None

        if self.need_reinforce:
            self.M_armature = self.M_elu * 0.35  # UPE reprend 35% du moment

            # Catalogue UPE EN 10365
            upe_catalog = [
                {"h": 80, "Wel": 28.8, "poids": 9.63},
                {"h": 100, "Wel": 43.8, "poids": 12.2},
                {"h": 120, "Wel": 62.8, "poids": 15.3},
                {"h": 140, "Wel": 88.0, "poids": 18.9},
                {"h": 160, "Wel": 116, "poids": 22.8},
                {"h": 180, "Wel": 150, "poids": 27.1},
                {"h": 200, "Wel": 191, "poids": 31.5},
                {"h": 220, "Wel": 245, "poids": 36.4},
                {"h": 240, "Wel": 300, "poids": 41.5},
            ]

            for profil in upe_catalog:
                M_rd = 2 * profil["Wel"] * 235 / 1000  # 2 UPE, S235, γM0=1.0
                if M_rd >= self.M_armature:
                    self.upe_propose = profil.copy()
                    self.upe_propose['M_rd'] = M_rd
                    break

            # Si aucun profil suffisant, prendre le plus grand
            if self.upe_propose is None:
                self.upe_propose = upe_catalog[-1].copy()
                self.upe_propose['M_rd'] = 2 * upe_catalog[-1]["Wel"] * 235 / 1000

        self.resultats['Renfort'] = {
            'need': bool(self.need_reinforce),
            'M_armature': float(self.M_armature) if self.need_reinforce else 0,
            'upe': self.upe_propose
        }
        
    def calcul_enveloppes(self):
        """Python génère les enveloppes N, T, M"""
        x = np.linspace(0, self.L, 100)

        # Poutre isostatique sous charge uniforme
        N = np.zeros_like(x)  # Pas d'effort normal
        V = self.q_elu * (self.L/2 - x)  # Effort tranchant
        M = self.q_elu * x * (self.L - x) / 2  # Moment fléchissant

        # Enregistrement pour export
        self.enveloppe = pd.DataFrame({
            'x': x,
            'N': N,
            'V': V,
            'M': M
        })
        
    def execute_all(self):
        """Exécute tous les calculs dans l'ordre Eurocode"""
        self.calcul_charges()
        self.calcul_section()
        self.calcul_resistance()
        self.calcul_solicitations()
        self.calcul_fleches()
        self.calcul_renforcement()
        self.calcul_enveloppes()
        return self.resultats, self.enveloppe

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python calcul_eurocode.py poutre_001.toml")
        sys.exit(1)
    
    calc = EurocodeCalculator(sys.argv[1])
    resultats, enveloppe = calc.execute_all()
    
    # Export JSON pour Typst
    import json
    with open("resultats_calc.json", "w") as f:
        json.dump(resultats, f, indent=2)
    
    # Export CSV pour graphiques
    enveloppe.to_csv("enveloppe_forces.csv", index=False)
    
    print("✅ Calculs Eurocode terminés")
    print(f"  - JSON créé : resultats_calc.json")
    print(f"  - CSV créé : enveloppe_forces.csv")