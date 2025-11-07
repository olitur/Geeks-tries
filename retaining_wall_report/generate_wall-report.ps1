# Script PowerShell : Génération du rapport de surveillance du mur de soutènement
# Auteur : OLT
# Date : 2025-10-28
# Description : Ce script vérifie les dépendances, génère les graphiques R et compile le PDF Typst

# Couleurs pour les messages
$ErrorColor = "Red"
$WarningColor = "Yellow"
$SuccessColor = "Green"
$InfoColor = "Cyan"

Write-Host "`n========================================================" -ForegroundColor $InfoColor
Write-Host " GÉNÉRATION DU RAPPORT - MUR DE SOUTÈNEMENT" -ForegroundColor $InfoColor
Write-Host "========================================================`n" -ForegroundColor $InfoColor

# Fonction pour vérifier si une commande existe
function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Fonction pour afficher un message d'erreur et quitter
function Exit-WithError {
    param([string]$Message)
    Write-Host "`n[ERREUR] $Message" -ForegroundColor $ErrorColor
    Write-Host "`nLa génération du rapport a échoué." -ForegroundColor $ErrorColor
    exit 1
}

# Fonction pour afficher un avertissement
function Show-Warning {
    param([string]$Message)
    Write-Host "[AVERTISSEMENT] $Message" -ForegroundColor $WarningColor
}

# Fonction pour afficher un succès
function Show-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor $SuccessColor
}

# Fonction pour afficher une information
function Show-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $InfoColor
}

# ====== VÉRIFICATION DES DÉPENDANCES ======

Write-Host "### 1. VÉRIFICATION DES DÉPENDANCES ###`n" -ForegroundColor $InfoColor

# Vérification de R
Show-Info "Vérification de R..."

# Variable globale pour le chemin de Rscript
$global:RscriptPath = $null

# Chercher Rscript dans le PATH d'abord
if (Test-CommandExists "Rscript") {
    $global:RscriptPath = "Rscript"
    $rVersion = & $global:RscriptPath --version 2>&1 | Select-String -Pattern "version" | Select-Object -First 1
    Show-Success "R est installé et dans le PATH : $rVersion"
} else {
    # Chercher dans les emplacements standard
    Show-Info "R n'est pas dans le PATH, recherche dans les emplacements standard..."

    $possiblePaths = @(
        "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe",
        "C:\Program Files\R\R-4.5.0\bin\Rscript.exe"
    )

    # Chercher toutes les versions de R installées
    if (Test-Path "C:\Program Files\R") {
        $rDirs = Get-ChildItem "C:\Program Files\R" -Directory -Filter "R-*" | Sort-Object -Descending
        foreach ($dir in $rDirs) {
            $possiblePaths += "$($dir.FullName)\bin\x64\Rscript.exe"
            $possiblePaths += "$($dir.FullName)\bin\Rscript.exe"
        }
    }

    # Tester chaque chemin
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            $global:RscriptPath = $path
            $rVersion = & $global:RscriptPath --version 2>&1 | Select-String -Pattern "version" | Select-Object -First 1
            Show-Success "R trouvé : $path"
            Show-Success "Version : $rVersion"
            break
        }
    }

    if ($null -eq $global:RscriptPath) {
        Exit-WithError "R n'est pas installé ou introuvable.`n`nInstallation sur Windows 11 :`n  1. Téléchargez R depuis https://cran.r-project.org/bin/windows/base/`n  2. Installez R en suivant les instructions`n  3. Le script le trouvera automatiquement OU ajoutez-le au PATH"
    }
}

# Vérification de Typst
Show-Info "Vérification de Typst..."
if (Test-CommandExists "typst") {
    $typstVersion = typst --version
    Show-Success "Typst est installé : $typstVersion"
} else {
    Exit-WithError "Typst n'est pas installé ou pas dans le PATH.`n`nInstallation sur Windows 11 :`n  Option 1 - Via winget (recommandé) :`n    winget install --id Typst.Typst`n  Option 2 - Via Scoop :`n    scoop install typst`n  Option 3 - Téléchargement manuel :`n    1. Téléchargez depuis https://github.com/typst/typst/releases`n    2. Extrayez l'exécutable dans un dossier (ex: C:\Tools\typst\)`n    3. Ajoutez ce dossier au PATH système`n  4. Redémarrez PowerShell"
}

# Vérification des packages R nécessaires
Show-Info "Vérification des packages R requis..."
$requiredPackages = @("ggplot2", "dplyr", "tidyr", "scales")
$missingPackages = @()

foreach ($pkg in $requiredPackages) {
    $checkScript = "if (!require('$pkg', quietly = TRUE)) quit(status = 1)"
    $result = & $global:RscriptPath -e $checkScript 2>&1
    if ($LASTEXITCODE -ne 0) {
        $missingPackages += $pkg
    }
}

if ($missingPackages.Count -gt 0) {
    Show-Warning "Packages R manquants : $($missingPackages -join ', ')"

    Write-Host "`nVoulez-vous installer automatiquement les packages manquants ? (O/N) " -NoNewline -ForegroundColor $WarningColor
    $response = Read-Host

    if ($response -eq "O" -or $response -eq "o") {
        Show-Info "Installation des packages manquants..."
        foreach ($pkg in $missingPackages) {
            Show-Info "Installation de $pkg..."
            $installScript = "install.packages('$pkg', repos='https://cran.rstudio.com/', quiet=TRUE)"
            & $global:RscriptPath -e $installScript
            if ($LASTEXITCODE -eq 0) {
                Show-Success "$pkg installé avec succès"
            } else {
                Exit-WithError "Échec de l'installation de $pkg"
            }
        }
    } else {
        Exit-WithError "Packages R manquants. Installation manuelle requise :`n  & '$global:RscriptPath' -e `"install.packages(c('$($missingPackages -join "', '")'))`""
    }
} else {
    Show-Success "Tous les packages R requis sont installés"
}

Write-Host ""

# ====== CRÉATION DU DOSSIER IMAGES ======

Show-Info "Vérification du dossier images..."
if (!(Test-Path "images")) {
    New-Item -ItemType Directory -Path "images" | Out-Null
    Show-Success "Dossier 'images' créé"
} else {
    Show-Success "Dossier 'images' existe"
}

Write-Host ""

# ====== GÉNÉRATION DES GRAPHIQUES R ======

Write-Host "### 2. GÉNÉRATION DES GRAPHIQUES R ###`n" -ForegroundColor $InfoColor

$rScripts = @(
    "plot_plan_view.R",
    "plot_timeseries.R",
    "plot_elevation.R"
)

foreach ($script in $rScripts) {
    if (Test-Path $script) {
        Show-Info "Exécution de $script..."
        & $global:RscriptPath $script
        if ($LASTEXITCODE -eq 0) {
            Show-Success "$script exécuté avec succès"
        } else {
            Exit-WithError "Échec de l'exécution de $script"
        }
    } else {
        Show-Warning "Script $script introuvable, ignoré"
    }
}

Write-Host ""

# ====== VÉRIFICATION DES IMAGES GÉNÉRÉES ======

Show-Info "Vérification des images générées..."
$expectedImages = @(
    "images/plan_view_movement.png",
    "images/timeseries_keypoints.png",
    "images/elevation_wall_status.png",
    "images/inclination_profile.png"
)

$missingImages = @()
foreach ($img in $expectedImages) {
    if (!(Test-Path $img)) {
        $missingImages += $img
    }
}

if ($missingImages.Count -gt 0) {
    Show-Warning "Images manquantes : $($missingImages -join ', ')"
    Show-Warning "Le PDF sera généré mais certaines images seront absentes"
} else {
    Show-Success "Toutes les images ont été générées"
}

Write-Host ""

# ====== COMPILATION DU PDF TYPST ======

Write-Host "### 3. COMPILATION DU PDF TYPST ###`n" -ForegroundColor $InfoColor

$typstSource = "rapport_mur_soutenement.typ"
$pdfOutput = "Rapport_Surveillance_Mur_Soutenement.pdf"

if (!(Test-Path $typstSource)) {
    Exit-WithError "Fichier source Typst '$typstSource' introuvable"
}

Show-Info "Compilation de $typstSource en $pdfOutput (PDF 2.0)..."
typst compile --pdf-standard 2.0 $typstSource $pdfOutput

if ($LASTEXITCODE -eq 0) {
    Show-Success "PDF généré avec succès : $pdfOutput"

    # Obtenir la taille du fichier
    $fileSize = (Get-Item $pdfOutput).Length
    $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
    Show-Info "Taille du PDF : $fileSizeMB Mo"

    # Afficher le chemin complet
    $fullPath = Resolve-Path $pdfOutput
    Show-Info "Chemin complet : $fullPath"
} else {
    Exit-WithError "Échec de la compilation du PDF Typst"
}

Write-Host ""

# ====== RÉSUMÉ FINAL ======

Write-Host "========================================================" -ForegroundColor $InfoColor
Write-Host " GÉNÉRATION TERMINÉE AVEC SUCCÈS" -ForegroundColor $SuccessColor
Write-Host "========================================================" -ForegroundColor $InfoColor

Write-Host "`nFichiers générés :" -ForegroundColor $InfoColor
Write-Host "  - Graphiques R dans le dossier 'images/'" -ForegroundColor $InfoColor
Write-Host "  - $pdfOutput" -ForegroundColor $SuccessColor

Write-Host "`nVoulez-vous ouvrir le PDF maintenant ? (O/N) " -NoNewline -ForegroundColor $InfoColor
$openPdf = Read-Host

if ($openPdf -eq "O" -or $openPdf -eq "o") {
    Show-Info "Ouverture du PDF..."
    Start-Process $pdfOutput
}

Write-Host "`nScript terminé.`n" -ForegroundColor $SuccessColor
