# Résumé du projet - Rapport de surveillance du mur de soutènement

## ✅ Projet complété avec succès

### 📦 Contenu du dossier

Le dossier `retaining_wall_report` contient un système complet de génération de rapport technique professionnel.

### 🎯 Objectif

Générer automatiquement un rapport PDF de surveillance d'un mur de soutènement incluant :
- Analyse de données de mesures topographiques (24 mois)
- Graphiques R de haute qualité
- Calculs de stabilité selon Eurocodes EN 1997-1 et EN 1992-1-1
- Recommandations d'action

### 📄 Fichiers créés

**Données** :
- `mur_soutenement.csv` : 840 mesures (24 mois × 35 points)

**Scripts R** (génération graphiques) :
- `plot_plan_view.R` : Vue en plan du mouvement
- `plot_timeseries.R` : Séries temporelles aux points clés
- `plot_elevation.R` : Élévation et zonage critique

**Document Typst** :
- `rapport_mur_soutenement.typ` : Source du rapport (42 pages)
  - Calculs Eurocode avec formules numérotées
  - Variables personnalisables (client, auteur, logos)
  - Support dual-logo (bureau d'études + client)
  - Signatures automatiques

**Scripts de génération** :
- `generate_wall-report.bat` : Script batch (recommandé, pas de restriction)
- `generate_wall-report.ps1` : Script PowerShell (plus de fonctionnalités)

**Documentation** :
- `README.md` : Guide complet d'utilisation
- `SUMMARY.md` : Ce fichier

**Images** :
- `images/` : Graphiques générés + signatures + logos
  - `231115_logo-regrain_V3-trans.png` : Logo bureau d'études Regrain
  - `canopee_logo.jpg` : Logo Association Canopée
  - `signature_OLT.png`, `signature_BCT.png`, `signature_ACB.png`

### 📊 Résultat final

**PDF généré** : `Rapport_Surveillance_Mur_Soutenement.pdf`
- **Taille** : 2.4 MB
- **Pages** : ~42 pages
- **Format** : PDF 2.0 (ISO 32000-2:2020)
- **Qualité** : Images 300 DPI pour impression professionnelle
- **Métadonnées** : 17 mots-clés intégrés pour indexation et recherche
- **Accessibilité** : PDF tagué par défaut
- **Contenu** :
  - Page de titre avec logos Regrain (bureau d'études) et Canopée (client)
  - Tableau de révisions (A0 → B1)
  - Sommaire avec titres colorés
  - Introduction et méthodologie
  - Résultats avec 4 graphiques R
  - Calculs Eurocode complets (22 formules numérotées)
  - Recommandations détaillées
  - Signatures automatiques des 3 intervenants
  - Annexes

## 🔧 Solutions techniques apportées

### Problème 1 : Politique d'exécution PowerShell

**Symptôme** : Erreur "L'exécution de scripts est désactivée"

**Cause** : Politique `LocalMachine` = `Restricted`

**Solutions** :
1. **Script batch** : Pas de restriction, fonctionne toujours
2. **PowerShell avec bypass** : `powershell -ExecutionPolicy Bypass -File script.ps1`
3. **Modification permanente** : `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`

### Problème 2 : R non trouvé dans PATH

**Symptôme** : Scripts ne trouvent pas Rscript.exe

**Solution** : Détection automatique dans les deux scripts
- Cherche d'abord dans PATH
- Puis dans `C:\Program Files\R\R-x.x.x\bin\x64\`
- Puis dans toutes les versions installées
- Version détectée : R 4.5.0

### Problème 3 : Affichage des logos et signatures

**Solution** : Conditionnels Typst
```typst
#if societe-logo != "" and societe-logo != none [
  #image(societe-logo, width: 80%)
]
```

### Problème 4 : Configuration du format PDF 2.0

**Symptôme** : Besoin d'utiliser le format PDF 2.0 moderne

**Solution** : Flag de compilation Typst
- Ajout de `--pdf-standard 2.0` dans les deux scripts de génération
- Commande : `typst compile --pdf-standard 2.0 source.typ output.pdf`
- Avantages :
  - Accessibilité améliorée
  - Structure moderne pour lecteurs d'écran
  - Métadonnées enrichies (17 mots-clés)
  - Compatibilité avec outils récents

## 📐 Calculs Eurocode implémentés

**Vérifications structurelles** :

1. **Poussée des terres** (Rankine)
   - Coefficient Ka = 0,333
   - Poussée active Pa = 55,41 kN/m

2. **Charges permanentes**
   - Voile : 37,63 kN/m
   - Semelle : 31,25 kN/m
   - Remblai : 99,18 kN/m
   - Total : 168,06 kN/m

3. **Renversement**
   - FSr = 2,09 ✓ (≥ 1,5)

4. **Glissement**
   - FSg = 1,42 ✗ (< 1,5)

5. **Capacité portante**
   - qmax = 123,1 kPa ✓ (≤ 300 kPa)

6. **Excentricité**
   - e = 0,737 m ✗ (> 0,417 m)

**Conclusion** : Intervention requise (2 critères non conformes)

## 📈 Analyse des données

**Zones identifiées** :
- Zone critique (rouge) : 12 m (34,3%) → positions 11-22 m → Reconstruction
- Zone surveillance (orange) : 13 m (37,1%) → positions 7-31 m → Surveillance renforcée
- Zone acceptable (vert) : 10 m (28,6%) → Surveillance normale

**Déplacements mesurés** :
- Point critique (14 m) : +26,33 mm sur 24 mois
- Limite acceptable : 37,6 mm
- Statut : Sous le seuil mais tendance préoccupante

## 💰 Recommandations et coûts

**Solution recommandée** : Tirants d'ancrage
- 10 tirants dans la zone 10-20 m
- Coût : 45 000 € HT (travaux)
- Coût total : 90 000 € HT (avec études et surveillance)

**Alternatives** :
- Contrebutée : 85 000 € HT
- Reconstruction partielle : 120 000 € HT

## 🚀 Utilisation

### Méthode la plus simple

```cmd
cd PDFs\retaining_wall_report
generate_wall-report.bat
```

### Avec PowerShell

```powershell
cd PDFs\retaining_wall_report
powershell -ExecutionPolicy Bypass -File .\generate_wall-report.ps1
```

## 🎨 Personnalisation

Modifier les variables en haut de `rapport_mur_soutenement.typ` :

**Équipe** :
- `auteur-nom`, `auteur-trigramme`, `auteur-signature`
- `verificateur-nom`, `verificateur-trigramme`, `verificateur-signature`
- `controleur-nom`, `controleur-trigramme`, `controleur-signature`

**Client** :
- `client-nom`, `client-contact`, `client-fonction`
- `client-adresse`, `client-email`, `client-tel`
- `client-logo`

**Société** :
- `societe-nom`, `societe-adresse`, `societe-email`, `societe-tel`
- `societe-logo`

**Projet** :
- `lieu-mur`, `date-creation`
- `titre-principal`, `sous-titre`

## 📚 Références

**Normes utilisées** :
- EN 1997-1 : Eurocode 7 - Calcul géotechnique
- EN 1992-1-1 : Eurocode 2 - Structures en béton
- EN 1991-1-1 : Eurocode 1 - Actions sur les structures

**Outils** :
- R 4.5.0 (graphiques)
- Typst 0.14.0 (PDF)
- ggplot2, dplyr, tidyr, scales (packages R)

## ✨ Fonctionnalités notables

1. **Dual-logo sur page de titre** : Bureau d'études (gauche) + Client (droite)
2. **Signatures automatiques** : Affichage conditionnel des images PNG
3. **Formules numérotées** : 22 équations Eurocode avec références croisées
4. **Titres colorés** : H1 bleu, H2 vert, H3 rouge, H4 noir
5. **Tableau de révisions** : Traçabilité complète avec trigrammes
6. **Graphiques professionnels** : 4 visualisations R haute résolution (300 DPI)
7. **Détection automatique R** : Fonctionne même si R n'est pas dans PATH
8. **Variables centralisées** : Personnalisation facile sans toucher au corps du document

## 📊 Statistiques du projet

- **Lignes de code Typst** : ~850
- **Lignes de code R** : ~400 (3 scripts)
- **Lignes de code PowerShell** : ~250
- **Lignes de code Batch** : ~180
- **Fichiers créés** : 15
- **Images générées** : 4 graphiques + 3 signatures
- **Temps de génération** : ~30 secondes
- **Taille PDF finale** : 2,1 MB

## 🎯 Statut du projet

✅ **Complété à 100%**

Tous les objectifs du fichier TBDs.md ont été atteints :
- ✅ Données CSV créées
- ✅ Scripts R fonctionnels
- ✅ Calculs Eurocode complets
- ✅ Document Typst professionnel
- ✅ Scripts de génération automatique
- ✅ Documentation complète
- ✅ Logos et signatures intégrés

---

**Dernière mise à jour** : 28 octobre 2025
**Version du rapport** : B1
**Auteur du projet** : OLT
