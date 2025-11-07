#!/usr/bin/env Rscript

# Script pour générer les graphiques de suivi des fissures
# Association Canopée - 2025

# Liste des packages requis
required_packages <- c("readr", "dplyr", "ggplot2", "scales", "lubridate", "gghighlight", "patchwork")

# Fonction pour installer les packages manquants
cat("Vérification des packages R...\n")
missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if (length(missing_packages) > 0) {
  cat(sprintf("Installation des packages manquants : %s\n", paste(missing_packages, collapse=", ")))
  install.packages(missing_packages, repos='https://cran.rstudio.com/', quiet=TRUE)
  cat("✓ Packages installés avec succès\n")
} else {
  cat("✓ Tous les packages sont déjà installés\n")
}

# Charger les bibliothèques nécessaires
suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(scales)
  library(lubridate)
  library(gghighlight)
  library(patchwork)
})

# Définir le répertoire de travail
# Si exécuté depuis RStudio, utiliser le chemin du fichier source
# Sinon, utiliser le répertoire de travail actuel
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getSourceEditorContext()$path))
} else {
  # En ligne de commande, rester dans le répertoire courant
  # (le script PowerShell se charge de se placer dans le bon dossier)
}

# Lire les données
cat("Lecture du fichier fissures.csv...\n")
data <- read_csv("fissures.csv", show_col_types = FALSE)

# Convertir la date
data$date <- as.Date(data$date)

# Créer une colonne combinée pour identifier chaque série
data <- data %>%
  mutate(serie = paste0(fissure, "-M", mesure))

# Fonction pour créer un graphique pour une série avec highlight des extrema
create_plot <- function(data_serie, titre, mesure_label, couleur = "#2C5F8D") {
  # Calculer les statistiques
  stats <- data_serie %>%
    summarise(
      min_val = min(ouverture_mm, na.rm = TRUE),
      max_val = max(ouverture_mm, na.rm = TRUE),
      mean_val = mean(ouverture_mm, na.rm = TRUE),
      start_val = first(ouverture_mm),
      end_val = last(ouverture_mm),
      evolution = end_val - start_val
    )

  # Trouver les dates des extrema
  date_min <- data_serie %>% filter(ouverture_mm == stats$min_val) %>% pull(date) %>% first()
  date_max <- data_serie %>% filter(ouverture_mm == stats$max_val) %>% pull(date) %>% first()

  # Déterminer la couleur selon l'évolution
  if (stats$evolution < -0.5) {
    couleur <- "#4CAF50"  # Vert : fermeture
    tendance_label <- sprintf("Fermeture: -%.2f mm", abs(stats$evolution))
  } else if (stats$evolution > 0.5) {
    couleur <- "#E74C3C"  # Rouge : ouverture
    tendance_label <- sprintf("Ouverture: +%.2f mm", stats$evolution)
  } else {
    couleur <- "#FF9800"  # Orange : stable
    tendance_label <- sprintf("Stable: %+.2f mm", stats$evolution)
  }

  # Créer le graphique
  p <- ggplot(data_serie, aes(x = date, y = ouverture_mm)) +
    # Ligne principale
    geom_line(color = couleur, size = 1.2, alpha = 0.8) +

    # Points de données
    geom_point(color = couleur, size = 1.2, alpha = 0.5) +

    # Highlight des points min et max
    geom_point(data = data_serie %>% filter(ouverture_mm == stats$min_val),
               aes(x = date, y = ouverture_mm),
               color = "#3498DB", size = 4, shape = 21, fill = "white", stroke = 2) +
    geom_point(data = data_serie %>% filter(ouverture_mm == stats$max_val),
               aes(x = date, y = ouverture_mm),
               color = "#E74C3C", size = 4, shape = 21, fill = "white", stroke = 2) +

    # Annotations pour min et max
    annotate("text", x = date_min, y = stats$min_val,
             label = sprintf("Min: %.2f mm\n%s", stats$min_val, format(date_min, "%d/%m/%Y")),
             vjust = 1.5, hjust = 0.5, size = 3, color = "#3498DB", fontface = "bold") +
    annotate("text", x = date_max, y = stats$max_val,
             label = sprintf("Max: %.2f mm\n%s", stats$max_val, format(date_max, "%d/%m/%Y")),
             vjust = -0.5, hjust = 0.5, size = 3, color = "#E74C3C", fontface = "bold") +

    # Tendance lissée
    geom_smooth(method = "loess", color = "#34495E", size = 0.8,
                se = TRUE, alpha = 0.15, linetype = "dashed") +

    # Ligne horizontale pour la moyenne
    geom_hline(yintercept = stats$mean_val, color = "#7F8C8D",
               linetype = "dotted", size = 0.5, alpha = 0.7) +

    # Échelle des dates
    scale_x_date(
      date_breaks = "4 months",
      date_labels = "%b\n%Y",
      expand = expansion(mult = c(0.02, 0.02))
    ) +

    # Échelle des valeurs
    scale_y_continuous(
      breaks = pretty_breaks(n = 10),
      expand = expansion(mult = c(0.1, 0.1))
    ) +

    # Titres et labels
    labs(
      title = sprintf("%s - %s", titre, mesure_label),
      subtitle = sprintf("Moyenne: %.2f mm | %s | Amplitude: %.2f mm",
                        stats$mean_val, tendance_label, stats$max_val - stats$min_val),
      x = "Date de mesure",
      y = "Ouverture (mm)"
    ) +

    # Thème
    theme_minimal(base_size = 11, base_family = "sans") +
    theme(
      plot.title = element_text(size = 13, face = "bold", hjust = 0.5, margin = margin(b = 3)),
      plot.subtitle = element_text(size = 9, hjust = 0.5, color = "#666666", margin = margin(b = 8)),
      axis.title = element_text(size = 9, face = "bold"),
      axis.title.x = element_text(margin = margin(t = 8)),
      axis.title.y = element_text(margin = margin(r = 8)),
      axis.text = element_text(size = 8),
      axis.text.x = element_text(angle = 0, hjust = 0.5),
      panel.grid.major = element_line(color = "#E0E0E0", size = 0.3),
      panel.grid.minor = element_line(color = "#F5F5F5", size = 0.2),
      plot.background = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA),
      plot.margin = margin(10, 10, 10, 10)
    )

  return(p)
}

# Créer le dossier images s'il n'existe pas
if (!dir.exists("images")) {
  dir.create("images")
  cat("Création du dossier images/\n")
}

# Générer les graphiques pour chaque série
cat("\nGénération des graphiques individuels et combinés...\n")

# Préparer les données pour chaque mesure
data_FA1_M1 <- data %>% filter(serie == "FA1-M1")
data_FA1_M2 <- data %>% filter(serie == "FA1-M2")
data_FA2_M1 <- data %>% filter(serie == "FA2-M1")
data_FA2_M2 <- data %>% filter(serie == "FA2-M2")

# Créer les graphiques individuels
cat("  - Génération des graphiques individuels...\n")
p_FA1_M1 <- create_plot(data_FA1_M1, "Fissure FA1", "Mesure 1")
p_FA1_M2 <- create_plot(data_FA1_M2, "Fissure FA1", "Mesure 2")
p_FA2_M1 <- create_plot(data_FA2_M1, "Fissure FA2", "Mesure 1")
p_FA2_M2 <- create_plot(data_FA2_M2, "Fissure FA2", "Mesure 2")

# Sauvegarder les graphiques individuels
ggsave("images/fissure-FA1-M1.png", p_FA1_M1, width = 10, height = 6, dpi = 300, bg = "white")
ggsave("images/fissure-FA1-M2.png", p_FA1_M2, width = 10, height = 6, dpi = 300, bg = "white")
ggsave("images/fissure-FA2-M1.png", p_FA2_M1, width = 10, height = 6, dpi = 300, bg = "white")
ggsave("images/fissure-FA2-M2.png", p_FA2_M2, width = 10, height = 6, dpi = 300, bg = "white")

# Créer les graphiques combinés avec patchwork
cat("  - Création des graphiques combinés (patchwork)...\n")

# Fissure FA1 - Comparaison des deux mesures
combined_FA1 <- p_FA1_M1 / p_FA1_M2 +
  plot_annotation(
    title = 'Fissure FA1 - Comparaison des deux points de mesure sur 3 ans',
    subtitle = 'Mesure 1 (fermeture progressive) vs Mesure 2 (ouverture continue) | Janvier 2022 - Décembre 2024',
    caption = 'Source: Mesures hebdomadaires fissuromètre SAUGNAC FD-125 | © Association Canopée 2025',
    theme = theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0.5, margin = margin(b = 5)),
      plot.subtitle = element_text(size = 11, hjust = 0.5, color = "#666666", margin = margin(b = 10)),
      plot.caption = element_text(size = 9, hjust = 1, color = "#999999", margin = margin(t = 10))
    )
  ) +
  plot_layout(heights = c(1, 1))

ggsave("images/fissure-FA1-combined.png", combined_FA1, width = 12, height = 10, dpi = 300, bg = "white")

# Fissure FA2 - Comparaison des deux mesures
combined_FA2 <- p_FA2_M1 / p_FA2_M2 +
  plot_annotation(
    title = 'Fissure FA2 - Comparaison des deux points de mesure sur 3 ans',
    subtitle = 'Mesure 1 (stable) vs Mesure 2 (légère ouverture) | Janvier 2022 - Décembre 2024',
    caption = 'Source: Mesures hebdomadaires fissuromètre SAUGNAC FD-125 | © Association Canopée 2025',
    theme = theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0.5, margin = margin(b = 5)),
      plot.subtitle = element_text(size = 11, hjust = 0.5, color = "#666666", margin = margin(b = 10)),
      plot.caption = element_text(size = 9, hjust = 1, color = "#999999", margin = margin(t = 10))
    )
  ) +
  plot_layout(heights = c(1, 1))

ggsave("images/fissure-FA2-combined.png", combined_FA2, width = 12, height = 10, dpi = 300, bg = "white")

# Vue d'ensemble - Toutes les mesures
cat("  - Création de la vue d'ensemble (4 graphiques)...\n")
overview <- (p_FA1_M1 | p_FA1_M2) / (p_FA2_M1 | p_FA2_M2) +
  plot_annotation(
    title = 'Suivi différentiel de fissures - Vue d\'ensemble sur 3 ans',
    subtitle = 'Analyse comparative de 4 points de mesure | Janvier 2022 - Décembre 2024',
    caption = 'Source: Mesures hebdomadaires fissuromètre SAUGNAC FD-125 | © Association Canopée 2025',
    theme = theme(
      plot.title = element_text(size = 18, face = "bold", hjust = 0.5, margin = margin(b = 5)),
      plot.subtitle = element_text(size = 12, hjust = 0.5, color = "#666666", margin = margin(b = 10)),
      plot.caption = element_text(size = 9, hjust = 1, color = "#999999", margin = margin(t = 10))
    )
  )

ggsave("images/fissures-overview.png", overview, width = 16, height = 12, dpi = 300, bg = "white")

cat("\n✓ Tous les graphiques ont été générés avec succès dans le dossier images/!\n")
cat("  Fichiers individuels: images/fissure-FA1-M1.png, images/fissure-FA1-M2.png, images/fissure-FA2-M1.png, images/fissure-FA2-M2.png\n")
cat("  Fichiers combinés: images/fissure-FA1-combined.png, images/fissure-FA2-combined.png\n")
cat("  Vue d'ensemble: images/fissures-overview.png\n\n")

# Afficher les statistiques récapitulatives
cat("Statistiques récapitulatives:\n")
cat("=============================\n\n")

stats_summary <- data %>%
  group_by(serie) %>%
  summarise(
    Minimum = min(ouverture_mm),
    Maximum = max(ouverture_mm),
    Moyenne = mean(ouverture_mm),
    Debut = first(ouverture_mm),
    Fin = last(ouverture_mm),
    Evolution = Fin - Debut,
    .groups = "drop"
  )

print(stats_summary, n = Inf)

cat("\n✓ Script terminé!\n")
