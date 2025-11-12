#!/usr/bin/env python3
"""
Orchestrateur complet : Clacul → Graphiques → Typst → PDF
"""

import sys
import subprocess
from pathlib import Path

def workflow_complet(toml_file):
    print(f"\n🚀 Traitement de {toml_file}")
    
    # Étape 1: Calculs Eurocode
    print("1️⃣ Calculs Eurocode...")
    subprocess.run(["python", "calcul_eurocode.py", toml_file], check=True)
    
    # Étape 2: Générer graphiques avec Python
    print("2️⃣ Génération graphiques...")
    enveloppe = pd.read_csv("enveloppe_forces.csv")
    plt.figure(figsize=(10, 5))
    plt.plot(enveloppe['x'], enveloppe['M'], 'r-', label='Moment M(x)')
    plt.plot(enveloppe['x'], enveloppe['V'], 'b-', label='Tranchant V(x)')
    plt.title("Enveloppe des efforts internes")
    plt.xlabel("Position x (m)")
    plt.ylabel("Efforts (kNm / kN)")
    plt.legend()
    plt.grid(True)
    plt.savefig("enveloppe.png", dpi=150)
    plt.close()
    
    # Étape 3: Générer Typst complet
    print("3️⃣ Génération Typst...")
    generate_typst_report("resultats_calc.json", "enveloppe_forces.csv", "rapport_final.typ")
    
    # Étape 4: Compiler PDF
    print("4️⃣ Compilation PDF...")
    subprocess.run(["typst", "compile", "rapport_final.typ", Path(toml_file).stem + ".pdf"], check=True)
    
    print(f"✅ PDF final créé: {Path(toml_file).stem}.pdf")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: orchestrateur.py poutre_001.toml")
        sys.exit(1)
    
    for f in sys.argv[1:]:
        workflow_complet(f)