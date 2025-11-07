@echo off
REM Script Batch : Génération du rapport de surveillance du mur de soutènement
REM Auteur : OLT
REM Date : 2025-10-28

echo ========================================================
echo  GENERATION DU RAPPORT - MUR DE SOUTENEMENT
echo ========================================================
echo.

REM Vérification de R
echo [INFO] Verification de R...

REM Chercher Rscript dans le PATH d'abord
where Rscript >nul 2>&1
if %errorlevel% equ 0 (
    set "RSCRIPT=Rscript"
    echo [OK] R est installe et dans le PATH
    goto :r_found
)

REM Sinon, chercher dans les emplacements standard
if exist "C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe" (
    set "RSCRIPT=C:\Program Files\R\R-4.5.0\bin\x64\Rscript.exe"
    echo [OK] R trouve : C:\Program Files\R\R-4.5.0\bin\x64\
    goto :r_found
)

if exist "C:\Program Files\R\R-4.5.0\bin\Rscript.exe" (
    set "RSCRIPT=C:\Program Files\R\R-4.5.0\bin\Rscript.exe"
    echo [OK] R trouve : C:\Program Files\R\R-4.5.0\bin\
    goto :r_found
)

REM Chercher toute version de R installée
for /d %%i in ("C:\Program Files\R\R-*") do (
    if exist "%%i\bin\x64\Rscript.exe" (
        set "RSCRIPT=%%i\bin\x64\Rscript.exe"
        echo [OK] R trouve : %%i\bin\x64\
        goto :r_found
    )
    if exist "%%i\bin\Rscript.exe" (
        set "RSCRIPT=%%i\bin\Rscript.exe"
        echo [OK] R trouve : %%i\bin\
        goto :r_found
    )
)

echo [ERREUR] R n'est pas installe ou introuvable
echo.
echo Installation sur Windows 11 :
echo   1. Telechargez R depuis https://cran.r-project.org/bin/windows/base/
echo   2. Installez R en suivant les instructions
echo   3. Ajoutez R au PATH systeme OU le script le trouvera automatiquement
pause
exit /b 1

:r_found

REM Vérification de Typst
echo [INFO] Verification de Typst...
where typst >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Typst n'est pas installe ou pas dans le PATH
    echo.
    echo Installation sur Windows 11 :
    echo   winget install --id Typst.Typst
    echo.
    echo Ou telechargez depuis : https://github.com/typst/typst/releases
    pause
    exit /b 1
)
echo [OK] Typst est installe
echo.

REM Création du dossier images
echo [INFO] Verification du dossier images...
if not exist "images" (
    mkdir "images"
    echo [OK] Dossier 'images' cree
) else (
    echo [OK] Dossier 'images' existe
)
echo.

REM Génération des graphiques R
echo ========================================================
echo  GENERATION DES GRAPHIQUES R
echo ========================================================
echo.

if exist "plot_plan_view.R" (
    echo [INFO] Execution de plot_plan_view.R...
    "%RSCRIPT%" plot_plan_view.R
    if %errorlevel% equ 0 (
        echo [OK] plot_plan_view.R execute avec succes
    ) else (
        echo [ERREUR] Echec de l'execution de plot_plan_view.R
        echo.
        echo Les packages R necessaires sont peut-etre manquants.
        echo Installez-les avec : "%RSCRIPT%" -e "install.packages(c('ggplot2', 'dplyr', 'tidyr', 'scales'))"
        pause
        exit /b 1
    )
)

if exist "plot_timeseries.R" (
    echo [INFO] Execution de plot_timeseries.R...
    "%RSCRIPT%" plot_timeseries.R
    if %errorlevel% equ 0 (
        echo [OK] plot_timeseries.R execute avec succes
    ) else (
        echo [ERREUR] Echec de l'execution de plot_timeseries.R
        pause
        exit /b 1
    )
)

if exist "plot_elevation.R" (
    echo [INFO] Execution de plot_elevation.R...
    "%RSCRIPT%" plot_elevation.R
    if %errorlevel% equ 0 (
        echo [OK] plot_elevation.R execute avec succes
    ) else (
        echo [ERREUR] Echec de l'execution de plot_elevation.R
        pause
        exit /b 1
    )
)

echo.

REM Vérification des images générées
echo [INFO] Verification des images generees...
set "missing_images=0"

if not exist "images\plan_view_movement.png" (
    echo [ATTENTION] Image manquante : plan_view_movement.png
    set "missing_images=1"
)
if not exist "images\timeseries_keypoints.png" (
    echo [ATTENTION] Image manquante : timeseries_keypoints.png
    set "missing_images=1"
)
if not exist "images\elevation_wall_status.png" (
    echo [ATTENTION] Image manquante : elevation_wall_status.png
    set "missing_images=1"
)
if not exist "images\inclination_profile.png" (
    echo [ATTENTION] Image manquante : inclination_profile.png
    set "missing_images=1"
)

if %missing_images% equ 0 (
    echo [OK] Toutes les images ont ete generees
) else (
    echo [ATTENTION] Certaines images sont manquantes
)
echo.

REM Compilation du PDF Typst
echo ========================================================
echo  COMPILATION DU PDF TYPST
echo ========================================================
echo.

set "typst_source=rapport_mur_soutenement.typ"
set "pdf_output=Rapport_Surveillance_Mur_Soutenement.pdf"

if not exist "%typst_source%" (
    echo [ERREUR] Fichier source Typst '%typst_source%' introuvable
    pause
    exit /b 1
)

echo [INFO] Compilation de %typst_source% en %pdf_output% (PDF 2.0)...
typst compile --pdf-standard 2.0 "%typst_source%" "%pdf_output%"

if %errorlevel% equ 0 (
    echo [OK] PDF genere avec succes : %pdf_output%
    for %%A in ("%pdf_output%") do echo [INFO] Taille du PDF : %%~zA octets
    echo [INFO] Chemin complet : %cd%\%pdf_output%
) else (
    echo [ERREUR] Echec de la compilation du PDF Typst
    pause
    exit /b 1
)

echo.
echo ========================================================
echo  GENERATION TERMINEE AVEC SUCCES
echo ========================================================
echo.
echo Fichiers generes :
echo   - Graphiques R dans le dossier 'images/'
echo   - %pdf_output%
echo.

REM Proposer d'ouvrir le PDF
set /p "open_pdf=Voulez-vous ouvrir le PDF maintenant ? (O/N) : "
if /i "%open_pdf%"=="O" (
    echo [INFO] Ouverture du PDF...
    start "" "%pdf_output%"
)

echo.
echo Script termine.
pause
