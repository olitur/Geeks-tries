# Script R : Vue en plan du mouvement de la crête du mur de soutènement
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

# Sélection des mois clés pour la visualisation (tous les 3 mois)
mois_cles <- c(1, 4, 7, 10, 13, 16, 19, 22, 24)
data_filtered <- data %>% filter(mois %in% mois_cles)

# Calcul des statistiques par position
stats_par_position <- data %>%
  group_by(distance_m) %>%
  summarise(
    min_deplacement = min(deplacement_mm),
    max_deplacement = max(deplacement_mm),
    mean_deplacement = mean(deplacement_mm)
  )

# Création du graphique en vue de dessus
p <- ggplot() +
  # Lignes de mouvement par mois
  geom_line(data = data_filtered,
            aes(x = distance_m, y = deplacement_mm,
                group = mois, color = as.factor(mois)),
            linewidth = 0.8, alpha = 0.7) +
  # Ligne des valeurs moyennes
  geom_line(data = stats_par_position,
            aes(x = distance_m, y = mean_deplacement),
            color = "black", linewidth = 1.5, linetype = "solid") +
  # Points min et max
  geom_point(data = stats_par_position %>% filter(max_deplacement == max(max_deplacement)),
             aes(x = distance_m, y = max_deplacement),
             color = "red", size = 4, shape = 17) +
  geom_point(data = stats_par_position %>% filter(min_deplacement == min(min_deplacement)),
             aes(x = distance_m, y = min_deplacement),
             color = "blue", size = 4, shape = 17) +
  # Annotations pour min et max
  geom_text(data = stats_par_position %>% filter(max_deplacement == max(max_deplacement)),
            aes(x = distance_m, y = max_deplacement,
                label = sprintf("Max: %.2f mm", max_deplacement)),
            vjust = -1, color = "red", fontface = "bold", size = 4) +
  geom_text(data = stats_par_position %>% filter(min_deplacement == min(min_deplacement)),
            aes(x = distance_m, y = min_deplacement,
                label = sprintf("Min: %.2f mm", min_deplacement)),
            vjust = 2, color = "blue", fontface = "bold", size = 4) +
  # Annotation pour la moyenne
  annotate("text", x = 17.5, y = mean(stats_par_position$mean_deplacement),
           label = "Valeur moyenne", vjust = -1, color = "black",
           fontface = "bold", size = 4) +
  # Mise en forme
  scale_color_viridis_d(name = "Mois de mesure", option = "plasma") +
  labs(
    title = "Vue en plan du déplacement de la crête du mur de soutènement",
    subtitle = "Évolution sur 24 mois - Mesures tous les 3 mois",
    x = "Distance depuis l'origine gauche (m)",
    y = "Déplacement perpendiculaire (mm)",
    caption = "Les triangles rouges et bleus indiquent respectivement les valeurs maximales et minimales\nLa ligne noire continue représente la valeur moyenne sur toute la période"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray30"),
    plot.caption = element_text(size = 9, hjust = 0, color = "gray50"),
    legend.position = "right",
    legend.text = element_text(size = 9),
    legend.title = element_text(face = "bold", size = 10),
    panel.grid.minor = element_line(color = "gray90"),
    panel.grid.major = element_line(color = "gray80"),
    axis.title = element_text(face = "bold", size = 11)
  ) +
  scale_x_continuous(breaks = seq(0, 35, by = 5)) +
  scale_y_continuous(breaks = seq(490, 580, by = 10))

# Sauvegarde du graphique
ggsave("images/plan_view_movement.png", plot = p,
       width = 12, height = 8, dpi = 300, bg = "white")

cat("Graphique de vue en plan créé : images/plan_view_movement.png\n")
