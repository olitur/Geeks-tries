# Script R : Élévation du mur avec zones bonnes et mauvaises
# Auteur : OLT
# Date : 2025-10-28

# Chargement des bibliothèques nécessaires
library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)

# Lecture des données
data <- read.csv("mur_soutenement.csv", stringsAsFactors = FALSE)

# Conversion de la date
data$date <- as.Date(data$date)

# Sélection des données du dernier mois (mois 24)
data_final <- data %>% filter(mois == 24)

# Calcul de l'inclinaison pour chaque segment
# Inclinaison = déplacement en mm / hauteur du mur (4300 mm)
hauteur_mur <- 4300  # mm

data_final <- data_final %>%
  mutate(
    # Déplacement depuis l'état initial (mois 1)
    deplacement_initial = c(500.23, 502.45, 505.12, 508.34, 512.23, 516.78, 521.45,
                           526.89, 532.12, 536.78, 538.45, 539.23, 539.78, 540.68,
                           543.12, 545.23, 544.56, 542.89, 540.12, 537.45, 534.23,
                           530.78, 527.12, 523.45, 519.89, 516.12, 512.78, 509.45,
                           506.23, 503.56, 501.34, 500.12, 499.45, 499.01, 498.78),
    variation_deplacement = deplacement_mm - deplacement_initial,
    inclinaison_rad = atan(variation_deplacement / hauteur_mur),
    inclinaison_deg = inclinaison_rad * (180 / pi),
    inclinaison_pourcent = (variation_deplacement / hauteur_mur) * 100
  )

# Détermination des zones critiques
# Seuil : inclinaison > 0.5% considérée comme critique
seuil_critique <- 0.5  # %
seuil_acceptable <- 0.3  # %

data_final <- data_final %>%
  mutate(
    etat_zone = case_when(
      inclinaison_pourcent >= seuil_critique ~ "Critique - À reconstruire",
      inclinaison_pourcent >= seuil_acceptable ~ "Surveillance renforcée",
      TRUE ~ "Acceptable"
    ),
    couleur_zone = case_when(
      inclinaison_pourcent >= seuil_critique ~ "#d62728",  # rouge
      inclinaison_pourcent >= seuil_acceptable ~ "#ff7f0e",  # orange
      TRUE ~ "#2ca02c"  # vert
    )
  )

# Création du graphique d'élévation
p1 <- ggplot(data_final, aes(x = distance_m, y = hauteur_mur / 1000)) +
  # Rectangle pour représenter le mur avec couleurs selon l'état
  geom_tile(aes(fill = etat_zone, y = hauteur_mur / 2000),
            height = hauteur_mur / 1000, width = 1, alpha = 0.7) +
  # Ligne supérieure du mur (état déformé)
  geom_line(aes(y = (hauteur_mur + variation_deplacement) / 1000),
            color = "black", linewidth = 1.5) +
  # Ligne de référence (état initial)
  geom_hline(yintercept = hauteur_mur / 1000,
             linetype = "dashed", color = "gray30", linewidth = 1) +
  # Annotations pour les zones critiques
  geom_text(data = data_final %>% filter(distance_m %in% c(14, 16)),
            aes(y = 0.5, label = sprintf("%.2f°\n%.2f%%",
                                          inclinaison_deg,
                                          inclinaison_pourcent)),
            size = 3, fontface = "bold", color = "red") +
  # Mise en forme
  scale_fill_manual(
    name = "État du mur",
    values = c("Critique - À reconstruire" = "#d62728",
               "Surveillance renforcée" = "#ff7f0e",
               "Acceptable" = "#2ca02c")
  ) +
  labs(
    title = "Élévation du mur de soutènement - État après 24 mois",
    subtitle = sprintf("Hauteur : %.1f m | Longueur : 35 m | Épaisseur : 35 cm", hauteur_mur / 1000),
    x = "Distance depuis l'origine gauche (m)",
    y = "Hauteur (m)",
    caption = "La ligne continue noire représente l'état déformé après 24 mois\nLa ligne pointillée grise représente l'état initial"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray30"),
    plot.caption = element_text(size = 9, hjust = 0, color = "gray50"),
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_text(face = "bold", size = 11),
    panel.grid.minor = element_line(color = "gray90"),
    panel.grid.major = element_line(color = "gray80"),
    axis.title = element_text(face = "bold", size = 11)
  ) +
  scale_x_continuous(breaks = seq(0, 35, by = 5)) +
  coord_fixed(ratio = 5)

# Sauvegarde du graphique
ggsave("images/elevation_wall_status.png", plot = p1,
       width = 14, height = 6, dpi = 300, bg = "white")

# Graphique complémentaire : profil d'inclinaison
p2 <- ggplot(data_final, aes(x = distance_m, y = inclinaison_pourcent)) +
  geom_area(aes(fill = etat_zone), alpha = 0.6) +
  geom_line(color = "black", linewidth = 1.2) +
  geom_point(size = 2, color = "black") +
  # Lignes de seuil
  geom_hline(yintercept = seuil_critique, linetype = "dashed",
             color = "#d62728", linewidth = 1) +
  geom_hline(yintercept = seuil_acceptable, linetype = "dashed",
             color = "#ff7f0e", linewidth = 1) +
  annotate("text", x = 32, y = seuil_critique + 0.05,
           label = "Seuil critique (0.5%)",
           color = "#d62728", fontface = "bold", size = 3.5) +
  annotate("text", x = 32, y = seuil_acceptable + 0.05,
           label = "Seuil surveillance (0.3%)",
           color = "#ff7f0e", fontface = "bold", size = 3.5) +
  # Mise en forme
  scale_fill_manual(
    name = "État du mur",
    values = c("Critique - À reconstruire" = "#d62728",
               "Surveillance renforcée" = "#ff7f0e",
               "Acceptable" = "#2ca02c")
  ) +
  labs(
    title = "Profil d'inclinaison du mur de soutènement",
    subtitle = "Inclinaison en pourcentage par rapport à la hauteur du mur",
    x = "Distance depuis l'origine gauche (m)",
    y = "Inclinaison (%)",
    caption = "Valeurs calculées à partir des mesures du mois 24 par rapport au mois 1"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray30"),
    plot.caption = element_text(size = 9, hjust = 0, color = "gray50"),
    legend.position = "bottom",
    legend.text = element_text(size = 10),
    legend.title = element_text(face = "bold", size = 11),
    panel.grid.minor = element_line(color = "gray90"),
    panel.grid.major = element_line(color = "gray80"),
    axis.title = element_text(face = "bold", size = 11)
  ) +
  scale_x_continuous(breaks = seq(0, 35, by = 5))

# Sauvegarde du graphique
ggsave("images/inclination_profile.png", plot = p2,
       width = 14, height = 7, dpi = 300, bg = "white")

# Calcul des zones à reconstruire et à conserver
zones_critiques <- data_final %>%
  filter(etat_zone == "Critique - À reconstruire") %>%
  summarise(
    longueur_critique = n(),  # nombre de segments
    debut_zone = min(distance_m),
    fin_zone = max(distance_m)
  )

zones_surveillance <- data_final %>%
  filter(etat_zone == "Surveillance renforcée") %>%
  summarise(
    longueur_surveillance = n(),
    debut_zone = min(distance_m),
    fin_zone = max(distance_m)
  )

zones_acceptables <- data_final %>%
  filter(etat_zone == "Acceptable") %>%
  summarise(
    longueur_acceptable = n()
  )

# Affichage des résultats
cat("\n=== ANALYSE DES ZONES DU MUR ===\n\n")
cat(sprintf("Zone critique (à reconstruire) : %d m (%.1f%% du mur)\n",
            zones_critiques$longueur_critique,
            (zones_critiques$longueur_critique / 35) * 100))
cat(sprintf("  → De %d m à %d m\n\n",
            zones_critiques$debut_zone, zones_critiques$fin_zone))

cat(sprintf("Zone sous surveillance renforcée : %d m (%.1f%% du mur)\n",
            zones_surveillance$longueur_surveillance,
            (zones_surveillance$longueur_surveillance / 35) * 100))
cat(sprintf("  → De %d m à %d m\n\n",
            zones_surveillance$debut_zone, zones_surveillance$fin_zone))

cat(sprintf("Zone acceptable : %d m (%.1f%% du mur)\n\n",
            zones_acceptables$longueur_acceptable,
            (zones_acceptables$longueur_acceptable / 35) * 100))

# Sauvegarde des données d'analyse
write.csv(data_final, "images/analyse_elevation.csv", row.names = FALSE)

cat("\nGraphiques créés :\n")
cat("  - images/elevation_wall_status.png\n")
cat("  - images/inclination_profile.png\n")
cat("Données d'analyse sauvegardées : images/analyse_elevation.csv\n")
