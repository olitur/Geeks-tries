# Calcul Poutre Bois - Analyse Eurocode Complète

## 📋 Description

Système complet d'analyse structurelle pour poutres en bois selon les Eurocodes (EC0, EC1, EC3, EC5).
Génère automatiquement un rapport PDF professionnel avec calculs détaillés, schémas, et dimensionnement de renforcement par profilés UPE.

## 🎯 Fonctionnalités

- ✅ **Calculs Eurocode complets** :
  - EC1 : Combinaisons de charges (permanentes, exploitation, neige, vent)
  - EC5 : Vérifications bois (flexion, cisaillement, flèches)
  - EC3 : Dimensionnement renforcement acier (UPE, boulonnage)

- ✅ **Rapport PDF professionnel** :
  - Page de titre
  - Table des matières
  - Calculs détaillés avec formules
  - Schémas structuraux (cetz)
  - Diagrammes des efforts (M, V, N)
  - Tableaux de synthèse
  - Références normatives

- ✅ **Graphiques Python** :
  - Enveloppes des efforts internes
  - Diagrammes moment, tranchant, normal
  - Export PNG haute résolution

- ✅ **Données paramétrables** :
  - Localisation Eurocode (zones neige/vent)
  - Géométrie poutre
  - État et dégradations
  - Mesures terrain

## 📁 Fichiers du Projet

```
calcul-poutre-bois_bis/
├── poutre_001.toml              # Données du projet (à éditer)
├── calcul_eurocode.py           # Moteur de calcul principal
├── generate_typst.py            # Génération rapport Typst
├── generate_graphics.py         # Génération graphiques Python
├── orchestrateur.py             # Workflow automatique complet
├── rapport_complet_standalone.typ  # Rapport Typst standalone (données intégrées)
├── test.typ                     # Fichier test Typst minimal
└── README.md                    # Ce fichier
```

## 🚀 Installation

### Prérequis

1. **Python 3.9+** avec les packages :
   ```bash
   pip install toml numpy pandas matplotlib
   ```

2. **Typst** (compilation PDF) :
   - Windows : Télécharger depuis https://github.com/typst/typst/releases
   - Ajouter `typst.exe` au PATH
   - Vérifier : `typst --version`

### Installation rapide

```bash
cd calcul-poutre-bois_bis
pip install -r requirements.txt  # Si fichier créé
```

## 📝 Utilisation

### Méthode 1 : Rapport Standalone (Recommandé pour débuter)

Le fichier `rapport_complet_standalone.typ` contient toutes les données et calculs intégrés.

```bash
# Compiler directement le rapport standalone
typst compile rapport_complet_standalone.typ rapport_standalone.pdf
```

✅ **Avantages** :
- Aucune dépendance Python
- Compilation immédiate
- Données de démonstration incluses
- Parfait pour tester Typst

### Méthode 2 : Workflow Automatique Complet

**Étape 1 : Éditer les données**

Ouvrir `poutre_001.toml` et modifier :
```toml
[projet]
nom = "Votre projet"
date = "2025-11-12"
numero_dossier = "2025-XXXX"

[poutre_existante]
longueur = 7.35  # m
largeur = 0.53   # m
hauteur = 0.62   # m

[mesures_terrain]
deflexion_mesuree = 0.045  # m (45 mm)
date_mesure = "15/10/2024"

# ... etc
```

**Étape 2 : Exécuter le workflow complet**

```bash
python orchestrateur.py poutre_001.toml
```

Ce script exécute automatiquement :
1. Calculs Eurocode → `resultats_calc.json` + `enveloppe_forces.csv`
2. Graphiques Python → `enveloppe_*.png`
3. Génération Typst → `rapport_final.typ`
4. Compilation PDF → `poutre_001.pdf`

### Méthode 3 : Étape par Étape (Debug/Développement)

```bash
# 1. Calculs Eurocode
python calcul_eurocode.py poutre_001.toml
# → Génère : resultats_calc.json, enveloppe_forces.csv

# 2. Graphiques (optionnel)
python generate_graphics.py enveloppe_forces.csv
# → Génère : enveloppe_complet.png, enveloppe_moment.png, etc.

# 3. Rapport Typst
python generate_typst.py resultats_calc.json enveloppe_forces.csv rapport_custom.typ
# → Génère : rapport_custom.typ

# 4. Compilation PDF
typst compile rapport_custom.typ rapport_custom.pdf
# → Génère : rapport_custom.pdf
```

## 📊 Structure des Données TOML

Le fichier `poutre_001.toml` est organisé en sections :

### Section `[projet]`
Informations générales (nom, auteur, date, n° dossier)

### Section `[localisation_eurocode]`
Paramètres Eurocode :
- `zone_neige` : A1, A2, B1, B2, C1, C2, D, E (EC1-1-3)
- `zone_vent` : 1, 2, 3, 4 (EC1-1-4)
- `altitude` : influence charge neige

### Section `[poutre_existante]`
Géométrie, essence, classe résistance, classe service

### Section `[mesures_terrain]`
Flèche mesurée, date, instrument, conditions

### Section `[degradations_etat]`
État actuel, coefficient k_exp, fissures, humidité

### Section `[stratigraphie_plancher]`
Couches successives avec épaisseur et poids volumique

### Sections charges et actions
- `[charges_permanentes]`
- `[charges_exploitation_eurocode]`
- `[actions_neige]`
- `[actions_vent]`

### Sections renforcement
- `[armature_proposee]`
- `[details_boulonnage]`

Voir `poutre_001.toml` pour exemple complet avec commentaires.

## 🎨 Personnalisation

### Modifier le rapport Typst

Éditer `generate_typst.py` pour :
- Changer mise en page, polices, couleurs
- Ajouter sections, tableaux, graphiques
- Modifier formules affichées
- Personnaliser schémas cetz

### Ajouter calculs Eurocode

Éditer `calcul_eurocode.py` classe `EurocodeCalculator` :
- Nouvelles méthodes de calcul
- Vérifications additionnelles
- Exports JSON personnalisés

## 📐 Exemples de Calculs

### Combinaisons ELU

```python
# EC0 §6.4.3.2 - Fondamentale
q_ELU = 1.35 * G_k + 1.5 * Q_k

# Neige dominante
q_ELU_neige = G_k + 1.5 * S_k

# Retenir le maximum
q_ELU_final = max(q_ELU, q_ELU_neige, q_ELU_vent)
```

### Moment résistant bois

```python
# EC5 §2.4.1
f_m,d = (k_mod * f_m,k) / γ_M * k_exp

# EC5 §6.1.6
σ_m,d = M_Ed / W ≤ f_m,d
```

### Flèche avec fluage

```python
# EC5 §2.2.3
f_fin = f_inst * (1 + k_def)

# EC5 Tableau 7.2
f_lim = L / 250
```

## 🔧 Dépannage

### Erreur : `typst: command not found`
➡️ Typst n'est pas installé ou pas dans le PATH.
Solution : Installer Typst et ajouter au PATH Windows

### Erreur : `ModuleNotFoundError: No module named 'toml'`
➡️ Package Python manquant.
Solution : `pip install toml numpy pandas matplotlib`

### Erreur compilation Typst : `package cetz not found`
➡️ Package Typst cetz manquant.
Solution : Au premier `typst compile`, cetz se télécharge automatiquement (connexion Internet requise)

### Rapport PDF vide ou incomplet
➡️ Données JSON ou CSV corrompues.
Solution : Relancer `python calcul_eurocode.py poutre_001.toml`

### Graphiques Python ne s'affichent pas
➡️ Normal, ils sont sauvegardés en PNG uniquement.
Solution : Vérifier fichiers `enveloppe_*.png` dans le dossier

## 📚 Références Normatives

- **EN 1990** (EC0) : Bases de calcul des structures
- **EN 1991-1-1** (EC1) : Charges permanentes et d'exploitation
- **EN 1991-1-3** (EC1) : Actions de la neige
- **EN 1991-1-4** (EC1) : Actions du vent
- **EN 1993-1-1** (EC3) : Calcul structures acier
- **EN 1993-1-8** (EC3) : Assemblages
- **EN 1995-1-1** (EC5) : Calcul structures bois
- **EN 338** : Bois de structure — Classes de résistance
- **EN 10365** : Profilés UPE
- **EN ISO 898-1** : Boulons

## 🤝 Contribution

Ce projet a été développé avec l'assistance de Claude (Anthropic).

Pour améliorer le code :
1. Tester avec différentes configurations
2. Ajouter vérifications Eurocode supplémentaires
3. Améliorer graphiques et schémas
4. Documenter cas d'usage spécifiques

## 📧 Support

Pour questions ou problèmes :
1. Vérifier ce README
2. Consulter `errors.md` pour erreurs connues
3. Tester avec `rapport_complet_standalone.typ` d'abord
4. Vérifier logs Python pour détails erreurs

## 📄 Licence

Utilisation libre pour projets personnels et professionnels.
Vérifier toujours calculs par ingénieur qualifié avant travaux.

---

**⚠️ AVERTISSEMENT IMPORTANT ⚠️**

Ces calculs sont fournis à titre informatif. Tout projet structurel doit être vérifié et validé par un ingénieur structure qualifié et assuré. L'auteur décline toute responsabilité en cas d'utilisation inadéquate.
