#!/usr/bin/env pwsh
# Script PowerShell pour compiler le rapport de suivi des fissures
# Association Canopée - 2025
#
# Ce script automatise le processus complet de génération du rapport :
# 1. Génère les graphiques avec R (ggplot2 + gghighlight + patchwork)
# 2. Compile le document Typst en PDF
#
# Prérequis :
# - R avec les packages : readr, dplyr, ggplot2, scales, lubridate, gghighlight, patchwork
# - Typst (https://typst.app/)
#
# Usage : .\compile-fissures-report.ps1

# Configuration
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# Couleurs pour le terminal
function Write-Step {
    param([string]$Message)
    Write-Host "`n[ÉTAPE] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

# Afficher le titre
Write-Host "`n================================================" -ForegroundColor Yellow
Write-Host "  Compilation du rapport de suivi des fissures" -ForegroundColor Yellow
Write-Host "  Association Canopée" -ForegroundColor Yellow
Write-Host "================================================`n" -ForegroundColor Yellow

# Vérifier les prérequis
Write-Step "Vérification des prérequis..."

# Vérifier R et trouver Rscript
$RscriptPath = $null
try {
    $rVersion = & Rscript --version 2>&1 | Select-Object -First 1
    $RscriptPath = "Rscript"
    Write-Success "R est installé : $rVersion"
} catch {
    # R n'est pas dans le PATH, chercher dans les emplacements communs
    Write-Host "R n'est pas dans le PATH, recherche en cours..." -ForegroundColor Yellow

    $commonPaths = @(
        "C:\Program Files\R\R-*\bin\Rscript.exe",
        "C:\Program Files\R\R-*\bin\x64\Rscript.exe",
        "$env:LOCALAPPDATA\Programs\R\R-*\bin\Rscript.exe"
    )

    foreach ($pathPattern in $commonPaths) {
        $foundPaths = Get-ChildItem -Path $pathPattern -ErrorAction SilentlyContinue | Sort-Object -Descending
        if ($foundPaths) {
            $RscriptPath = $foundPaths[0].FullName
            break
        }
    }

    if ($RscriptPath) {
        $rVersion = & $RscriptPath --version 2>&1 | Select-Object -First 1
        Write-Success "R trouvé : $rVersion"
        Write-Host "  Chemin : $RscriptPath" -ForegroundColor Gray
    } else {
        Write-Error-Custom "R n'est pas installé"
        Write-Host "Installez R depuis : https://cran.r-project.org/" -ForegroundColor Yellow
        exit 1
    }
}

# Vérifier Typst
try {
    $typstVersionOutput = & typst --version 2>&1
    Write-Success "Typst est installé : $typstVersionOutput"

    # Extraire le numéro de version et vérifier si c'est la dernière version
    if ($typstVersionOutput -match "typst (\d+\.\d+\.\d+)") {
        $currentVersion = [version]$matches[1]
        $recommendedVersion = [version]"0.14.0"

        if ($currentVersion -lt $recommendedVersion) {
            Write-Host "  ⚠️  Une nouvelle version de Typst est disponible (v$recommendedVersion)" -ForegroundColor Yellow
            Write-Host "  Pour mettre à jour : winget upgrade --id Typst.Typst" -ForegroundColor Gray
        }
    }
} catch {
    Write-Error-Custom "Typst n'est pas installé ou n'est pas dans le PATH"
    Write-Host "Installez Typst avec : winget install --id Typst.Typst" -ForegroundColor Yellow
    Write-Host "Ou depuis : https://github.com/typst/typst/releases" -ForegroundColor Yellow
    exit 1
}

# Vérifier que le fichier de données existe
if (-not (Test-Path "fissures.csv")) {
    Write-Error-Custom "Le fichier fissures.csv n'existe pas"
    exit 1
}
Write-Success "Fichier de données trouvé : fissures.csv"

# Étape 1 : Générer les graphiques avec R
Write-Step "Génération des graphiques avec R (ggplot2 + gghighlight + patchwork)..."

try {
    & $RscriptPath generate-fissures-graphs.R
    if ($LASTEXITCODE -ne 0) {
        throw "Le script R a retourné une erreur"
    }
    Write-Success "Graphiques générés avec succès"
} catch {
    Write-Error-Custom "Erreur lors de la génération des graphiques : $_"
    Write-Host "Vérifiez que les packages R sont installés :" -ForegroundColor Yellow
    Write-Host "  install.packages(c('readr', 'dplyr', 'ggplot2', 'scales', 'lubridate', 'gghighlight', 'patchwork'))" -ForegroundColor Yellow
    exit 1
}

# Vérifier que les images ont été générées
$expectedImages = @(
    "images/fissure-FA1-M1.png",
    "images/fissure-FA1-M2.png",
    "images/fissure-FA2-M1.png",
    "images/fissure-FA2-M2.png",
    "images/fissure-FA1-combined.png",
    "images/fissure-FA2-combined.png",
    "images/fissures-overview.png"
)

$missingImages = @()
foreach ($img in $expectedImages) {
    if (-not (Test-Path $img)) {
        $missingImages += $img
    }
}

if ($missingImages.Count -gt 0) {
    Write-Error-Custom "Images manquantes :"
    foreach ($img in $missingImages) {
        Write-Host "  - $img" -ForegroundColor Red
    }
    exit 1
}

Write-Success "Toutes les images ont été générées (7 fichiers PNG)"

# Étape 2 : Compiler le document Typst
Write-Step "Compilation du document Typst en PDF..."

try {
    & typst compile suivi-fissures.typ
    if ($LASTEXITCODE -ne 0) {
        throw "Typst a retourné une erreur"
    }
    Write-Success "Document PDF compilé avec succès"
} catch {
    Write-Error-Custom "Erreur lors de la compilation Typst : $_"
    exit 1
}

# Vérifier que le PDF a été créé
if (-not (Test-Path "suivi-fissures.pdf")) {
    Write-Error-Custom "Le fichier PDF n'a pas été créé"
    exit 1
}

# Afficher les informations sur le fichier généré
$pdfInfo = Get-Item "suivi-fissures.pdf"
$pdfSizeKB = [math]::Round($pdfInfo.Length / 1KB, 2)

Write-Host "`n================================================" -ForegroundColor Green
Write-Host "  ✓ COMPILATION RÉUSSIE" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host "`nRapport généré :" -ForegroundColor White
Write-Host "  Fichier    : suivi-fissures.pdf" -ForegroundColor Cyan
Write-Host "  Taille     : $pdfSizeKB Ko" -ForegroundColor Cyan
Write-Host "  Modifié le : $($pdfInfo.LastWriteTime)" -ForegroundColor Cyan
Write-Host "`nGraphiques générés dans le dossier images/ :" -ForegroundColor White
Write-Host "  - 4 graphiques individuels (FA1-M1, FA1-M2, FA2-M1, FA2-M2)" -ForegroundColor Cyan
Write-Host "  - 2 graphiques combinés (FA1-combined, FA2-combined)" -ForegroundColor Cyan
Write-Host "  - 1 vue d'ensemble (fissures-overview)" -ForegroundColor Cyan
Write-Host "`n"

# Proposer d'ouvrir le PDF
$openPDF = Read-Host "Voulez-vous ouvrir le PDF ? (O/N)"
if ($openPDF -eq "O" -or $openPDF -eq "o") {
    Start-Process "suivi-fissures.pdf"
}
