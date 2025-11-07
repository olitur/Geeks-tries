# Script R : Série temporelle du déplacement aux points clés
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

# Sélection des points clés (1m, 14m, 16m, 35m)
points_cles <- c(1, 14, 16, 35)
data_points_cles <- data %>% filter(distance_m %in% points_cles)

# Ajout d'étiquettes descriptives
data_points_cles <- data_points_cles %>%
  mutate(
    point_label = case_when(
      distance_m == 1 ~ "Extrémité gauche (1 m)",
      distance_m == 14 ~ "Zone critique - avant centre (14 m)",
      distance_m == 16 ~ "Zone critique - après centre (16 m)",
      distance_m == 35 ~ "Extrémité droite (35 m)",
      TRUE ~ as.character(distance_m)
    )
  )

# Calcul des variations saisonnières
data_points_cles <- data_points_cles %>%
  group_by(distance_m) %>%
  mutate(
    variation_depuis_debut = deplacement_mm - first(deplacement_mm),
    tendance = (deplacement_mm - first(deplacement_mm)) / (mois - 1) * 12  # variation annuelle
  )

# Création du graphique de séries temporelles
p <- ggplot(data_points_cles,
            aes(x = date, y = deplacement_mm,
                color = point_label, group = point_label)) +
  geom_line(linewidth = 1.2, alpha = 0.8) +
  geom_point(size = 2, alpha = 0.6) +
  # Mise en évidence des saisons humides (hiver-printemps)
  annotate("rect", xmin = as.Date("2023-11-01"), xmax = as.Date("2024-04-30"),
           ymin = -Inf, ymax = Inf, alpha = 0.1, fill = "blue") +
  annotate("rect", xmin = as.Date("2024-11-01"), xmax = as.Date("2025-04-30"),
           ymin = -Inf, ymax = Inf, alpha = 0.1, fill = "blue") +
  annotate("text", x = as.Date("2024-02-15"), y = 575,
           label = "Période humide\n(expansion)",
           color = "blue", size = 3.5, fontface = "italic") +
  # Mise en forme
  scale_color_manual(
    name = "Position sur le mur",
    values = c("#1f77b4", "#d62728", "#ff7f0e", "#2ca02c")
  ) +
  labs(
    title = "Évolution temporelle du déplacement aux points clés",
    subtitle = "Surveillance sur 24 mois (janvier 2023 - décembre 2024)",
    x = "Date de mesure",
    y = "Déplacement perpendiculaire (mm)",
    caption = "Les zones bleues indiquent les périodes humides (hiver-printemps) avec augmentation du déplacement\nLes zones non colorées correspondent aux périodes sèches (été-automne) avec réduction du déplacement"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray30"),
    plot.caption = element_text(size = 9, hjust = 0, color = "gray50"),
    legend.position = "bottom",
    legend.text = element_text(size = 9),
    legend.title = element_text(face = "bold", size = 10),
    panel.grid.minor = element_line(color = "gray90"),
    panel.grid.major = element_line(color = "gray80"),
    axis.title = element_text(face = "bold", size = 11),
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  scale_x_date(date_breaks = "2 months", date_labels = "%b %Y") +
  scale_y_continuous(breaks = seq(490, 580, by = 10))

# Sauvegarde du graphique
ggsave("images/timeseries_keypoints.png", plot = p,
       width = 14, height = 8, dpi = 300, bg = "white")

# Calcul des statistiques pour chaque point
stats_points <- data_points_cles %>%
  group_by(point_label) %>%
  summarise(
    deplacement_initial = first(deplacement_mm),
    deplacement_final = last(deplacement_mm),
    variation_totale = last(deplacement_mm) - first(deplacement_mm),
    variation_annuelle_moyenne = variation_totale / 2,  # sur 2 ans
    deplacement_max = max(deplacement_mm),
    deplacement_min = min(deplacement_mm),
    amplitude_saisonniere = deplacement_max - deplacement_min
  )

# Affichage des statistiques
cat("\n=== STATISTIQUES AUX POINTS CLÉS ===\n\n")
print(stats_points, n = Inf)

# Sauvegarde des statistiques
write.csv(stats_points, "images/statistiques_points_cles.csv", row.names = FALSE)

cat("\n\nGraphique de séries temporelles créé : images/timeseries_keypoints.png\n")
cat("Statistiques sauvegardées : images/statistiques_points_cles.csv\n")
