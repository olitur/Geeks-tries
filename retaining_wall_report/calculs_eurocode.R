# Script R : Calculs de stabilité selon Eurocodes (EN 1997-1 et EN 1992-1-1)
# Auteur : OLT
# Date : 2025-10-28
# Description : Vérification de la stabilité d'un mur en T inversé

cat("==============================================================\n")
cat(" CALCULS DE STABILITÉ - MUR DE SOUTÈNEMENT EN T INVERSÉ\n")
cat(" Selon Eurocodes EN 1997-1 (Géotechnique) et EN 1992-1-1 (Béton)\n")
cat("==============================================================\n\n")

# ====== DONNÉES D'ENTRÉE ======
cat("### 1. DONNÉES GÉOMÉTRIQUES ###\n\n")

# Géométrie du mur
H_mur <- 4.3  # Hauteur totale du mur (m)
e_voile <- 0.35  # Épaisseur du voile (m)
L_mur <- 35  # Longueur du mur (m)
L_semelle <- 2.5  # Largeur de la semelle (m)
e_semelle <- 0.50  # Épaisseur de la semelle (m)
L_patin <- 1.8  # Longueur du patin (côté remblai) (m)
L_talon <- 0.35  # Longueur du talon (côté libre) (m)

cat(sprintf("Hauteur du mur : H = %.2f m\n", H_mur))
cat(sprintf("Épaisseur du voile : e = %.2f m\n", e_voile))
cat(sprintf("Longueur du mur : L = %.0f m\n", L_mur))
cat(sprintf("Largeur de la semelle : B = %.2f m\n", L_semelle))
cat(sprintf("Épaisseur de la semelle : e_s = %.2f m\n", e_semelle))
cat(sprintf("Longueur du patin : L_p = %.2f m\n", L_patin))
cat(sprintf("Longueur du talon : L_t = %.2f m\n\n", L_talon))

# Propriétés des matériaux
cat("### 2. PROPRIÉTÉS DES MATÉRIAUX ###\n\n")

# Béton armé
gamma_beton <- 25  # kN/m³
fck <- 30  # Résistance caractéristique du béton (MPa)
fcd <- fck / 1.5  # Résistance de calcul (MPa)

cat(sprintf("Béton armé : γ_béton = %.0f kN/m³\n", gamma_beton))
cat(sprintf("Résistance caractéristique : f_ck = %.0f MPa\n", fck))
cat(sprintf("Résistance de calcul : f_cd = %.1f MPa\n\n", fcd))

# Sol de remblai
gamma_remblai <- 18  # kN/m³
phi_remblai <- 30  # Angle de frottement interne (degrés)
c_remblai <- 0  # Cohésion (kPa) - sol pulvérulent
delta <- phi_remblai * 2/3  # Angle de frottement sol/mur (degrés)

cat(sprintf("Sol de remblai : γ_sol = %.0f kN/m³\n", gamma_remblai))
cat(sprintf("Angle de frottement : φ' = %.0f°\n", phi_remblai))
cat(sprintf("Cohésion : c' = %.0f kPa\n", c_remblai))
cat(sprintf("Frottement sol/mur : δ = %.0f°\n\n", delta))

# Sol de fondation
gamma_fondation <- 19  # kN/m³
phi_fondation <- 32  # Angle de frottement interne (degrés)
c_fondation <- 10  # Cohésion (kPa)
qref <- 300  # Capacité portante de référence (kPa)

cat(sprintf("Sol de fondation : γ_fond = %.0f kN/m³\n", gamma_fondation))
cat(sprintf("Angle de frottement : φ'_fond = %.0f°\n", phi_fondation))
cat(sprintf("Cohésion : c'_fond = %.0f kPa\n", c_fondation))
cat(sprintf("Capacité portante de référence : q_ref = %.0f kPa\n\n", qref))

# Coefficients partiels de sécurité (ELU - Approche 2)
gamma_G_inf <- 1.0  # Actions permanentes défavorables
gamma_G_sup <- 1.35  # Actions permanentes favorables
gamma_Q <- 1.5  # Actions variables
gamma_phi <- 1.25  # Coefficient partiel sur tan(φ)

cat("### 3. COEFFICIENTS DE SÉCURITÉ (ELU - Approche 2) ###\n\n")
cat(sprintf("γ_G,inf (favorable) = %.2f\n", gamma_G_inf))
cat(sprintf("γ_G,sup (défavorable) = %.2f\n", gamma_G_sup))
cat(sprintf("γ_Q = %.2f\n", gamma_Q))
cat(sprintf("γ_φ = %.2f\n\n", gamma_phi))

# ====== CALCUL DES POUSSÉES DES TERRES (RANKINE/COULOMB) ======
cat("==============================================================\n")
cat("### 4. CALCUL DES POUSSÉES DES TERRES ###\n\n")

# Coefficient de poussée active (formule de Rankine simplifiée)
phi_rad <- phi_remblai * pi / 180
Ka <- tan(pi/4 - phi_rad/2)^2

cat(sprintf("Coefficient de poussée active : K_a = %.3f (Éq. 1)\n", Ka))
cat(sprintf("  K_a = tan²(45° - φ'/2)\n"))
cat(sprintf("  K_a = tan²(45° - %.0f°/2) = %.3f\n\n", phi_remblai, Ka))

# Pression horizontale des terres
# À la base : sigma_h = Ka * gamma * H
sigma_h_base <- Ka * gamma_remblai * H_mur

cat(sprintf("Pression horizontale à la base : σ_h = %.2f kPa (Éq. 2)\n", sigma_h_base))
cat(sprintf("  σ_h = K_a × γ_sol × H\n"))
cat(sprintf("  σ_h = %.3f × %.0f × %.1f = %.2f kPa\n\n", Ka, gamma_remblai, H_mur, sigma_h_base))

# Résultante de la poussée active (par mètre linéaire de mur)
Pa <- 0.5 * Ka * gamma_remblai * H_mur^2

cat(sprintf("Résultante de la poussée active : P_a = %.2f kN/m (Éq. 3)\n", Pa))
cat(sprintf("  P_a = 1/2 × K_a × γ_sol × H²\n"))
cat(sprintf("  P_a = 0.5 × %.3f × %.0f × %.1f² = %.2f kN/m\n\n", Ka, gamma_remblai, H_mur, Pa))

# Point d'application (au tiers inférieur)
z_Pa <- H_mur / 3

cat(sprintf("Point d'application : z = H/3 = %.2f m depuis la base\n\n", z_Pa))

# ====== CALCUL DES CHARGES PERMANENTES ======
cat("==============================================================\n")
cat("### 5. CALCUL DES CHARGES PERMANENTES ###\n\n")

# Poids du voile
V_voile <- e_voile * H_mur * 1  # Par mètre linéaire
G_voile <- V_voile * gamma_beton
x_voile <- L_talon + e_voile / 2

cat(sprintf("Poids du voile : G_voile = %.2f kN/m (Éq. 4)\n", G_voile))
cat(sprintf("  G_voile = e × H × γ_béton\n"))
cat(sprintf("  G_voile = %.2f × %.1f × %.0f = %.2f kN/m\n", e_voile, H_mur, gamma_beton, G_voile))
cat(sprintf("  Bras de levier : x_voile = %.2f m\n\n", x_voile))

# Poids de la semelle
V_semelle <- L_semelle * e_semelle * 1
G_semelle <- V_semelle * gamma_beton
x_semelle <- L_semelle / 2

cat(sprintf("Poids de la semelle : G_semelle = %.2f kN/m (Éq. 5)\n", G_semelle))
cat(sprintf("  G_semelle = B × e_s × γ_béton\n"))
cat(sprintf("  G_semelle = %.2f × %.2f × %.0f = %.2f kN/m\n", L_semelle, e_semelle, gamma_beton, G_semelle))
cat(sprintf("  Bras de levier : x_semelle = %.2f m\n\n", x_semelle))

# Poids du remblai sur le patin
H_remblai_patin <- H_mur - e_semelle
V_remblai <- (L_patin - e_voile) * H_remblai_patin * 1
G_remblai <- V_remblai * gamma_remblai
x_remblai <- L_talon + e_voile + (L_patin - e_voile) / 2

cat(sprintf("Poids du remblai sur patin : G_remblai = %.2f kN/m (Éq. 6)\n", G_remblai))
cat(sprintf("  G_remblai = (L_p - e) × H_remb × γ_sol\n"))
cat(sprintf("  G_remblai = (%.2f - %.2f) × %.2f × %.0f = %.2f kN/m\n",
            L_patin, e_voile, H_remblai_patin, gamma_remblai, G_remblai))
cat(sprintf("  Bras de levier : x_remblai = %.2f m\n\n", x_remblai))

# Poids total vertical
G_total <- G_voile + G_semelle + G_remblai

cat(sprintf("Poids total vertical : G_total = %.2f kN/m (Éq. 7)\n", G_total))
cat(sprintf("  G_total = G_voile + G_semelle + G_remblai\n"))
cat(sprintf("  G_total = %.2f + %.2f + %.2f = %.2f kN/m\n\n",
            G_voile, G_semelle, G_remblai, G_total))

# ====== VÉRIFICATION AU RENVERSEMENT ======
cat("==============================================================\n")
cat("### 6. VÉRIFICATION AU RENVERSEMENT ###\n\n")

# Point de rotation : extrémité aval de la semelle (côté libre)
O_x <- 0

# Moments stabilisateurs
M_stab_voile <- G_voile * x_voile
M_stab_semelle <- G_semelle * x_semelle
M_stab_remblai <- G_remblai * x_remblai
M_stab_total <- M_stab_voile + M_stab_semelle + M_stab_remblai

cat("Moments stabilisateurs (par rapport au point O) :\n")
cat(sprintf("  M_voile = %.2f × %.2f = %.2f kN⋅m/m (Éq. 8)\n", G_voile, x_voile, M_stab_voile))
cat(sprintf("  M_semelle = %.2f × %.2f = %.2f kN⋅m/m (Éq. 9)\n", G_semelle, x_semelle, M_stab_semelle))
cat(sprintf("  M_remblai = %.2f × %.2f = %.2f kN⋅m/m (Éq. 10)\n", G_remblai, x_remblai, M_stab_remblai))
cat(sprintf("  M_stab = %.2f kN⋅m/m (Éq. 11)\n\n", M_stab_total))

# Moment renversant
M_renversant <- Pa * z_Pa

cat("Moment renversant :\n")
cat(sprintf("  M_renversant = P_a × z = %.2f × %.2f = %.2f kN⋅m/m (Éq. 12)\n\n", Pa, z_Pa, M_renversant))

# Coefficient de sécurité au renversement
FS_renversement <- M_stab_total / M_renversant

cat(sprintf("Coefficient de sécurité au renversement : FS_r = %.2f (Éq. 13)\n", FS_renversement))
cat(sprintf("  FS_r = M_stab / M_renversant = %.2f / %.2f = %.2f\n", M_stab_total, M_renversement, FS_renversement))
cat(sprintf("  Critère Eurocode : FS_r ≥ 1.5\n"))
if (FS_renversement >= 1.5) {
  cat(sprintf("  ✓ VÉRIFIÉ (%.2f ≥ 1.5)\n\n", FS_renversement))
} else {
  cat(sprintf("  ✗ NON VÉRIFIÉ (%.2f < 1.5)\n\n", FS_renversement))
}

# ====== VÉRIFICATION AU GLISSEMENT ======
cat("==============================================================\n")
cat("### 7. VÉRIFICATION AU GLISSEMENT ###\n\n")

# Angle de frottement de calcul
phi_d <- atan(tan(phi_fondation * pi / 180) / gamma_phi) * 180 / pi
delta_fond <- phi_d * 2/3

cat(sprintf("Angle de frottement de calcul : φ_d = %.1f° (Éq. 14)\n", phi_d))
cat(sprintf("  φ_d = arctan(tan(φ') / γ_φ)\n"))
cat(sprintf("  φ_d = arctan(tan(%.0f°) / %.2f) = %.1f°\n\n", phi_fondation, gamma_phi, phi_d))

# Force résistante au glissement
delta_fond_rad <- delta_fond * pi / 180
F_resistance <- G_total * tan(delta_fond_rad) + c_fondation * L_semelle

cat(sprintf("Force résistante au glissement : F_r = %.2f kN/m (Éq. 15)\n", F_resistance))
cat(sprintf("  F_r = G_total × tan(δ) + c' × B\n"))
cat(sprintf("  F_r = %.2f × tan(%.1f°) + %.0f × %.2f = %.2f kN/m\n\n",
            G_total, delta_fond, c_fondation, L_semelle, F_resistance))

# Coefficient de sécurité au glissement
FS_glissement <- F_resistance / Pa

cat(sprintf("Coefficient de sécurité au glissement : FS_g = %.2f (Éq. 16)\n", FS_glissement))
cat(sprintf("  FS_g = F_r / P_a = %.2f / %.2f = %.2f\n", F_resistance, Pa, FS_glissement))
cat(sprintf("  Critère Eurocode : FS_g ≥ 1.5\n"))
if (FS_glissement >= 1.5) {
  cat(sprintf("  ✓ VÉRIFIÉ (%.2f ≥ 1.5)\n\n", FS_glissement))
} else {
  cat(sprintf("  ✗ NON VÉRIFIÉ (%.2f < 1.5)\n\n", FS_glissement))
}

# ====== VÉRIFICATION DE LA CAPACITÉ PORTANTE ======
cat("==============================================================\n")
cat("### 8. VÉRIFICATION DE LA CAPACITÉ PORTANTE ###\n\n")

# Excentricité de la charge
e_charge <- (M_stab_total - M_renversant) / G_total - L_semelle / 2

cat(sprintf("Excentricité de la charge : e = %.3f m (Éq. 17)\n", e_charge))
cat(sprintf("  e = (M_stab - M_renversant) / G_total - B/2\n"))
cat(sprintf("  e = (%.2f - %.2f) / %.2f - %.2f/2 = %.3f m\n\n",
            M_stab_total, M_renversant, G_total, L_semelle, e_charge))

# Largeur efficace
B_eff <- L_semelle - 2 * abs(e_charge)

cat(sprintf("Largeur efficace : B' = %.2f m (Éq. 18)\n", B_eff))
cat(sprintf("  B' = B - 2|e| = %.2f - 2×%.3f = %.2f m\n\n", L_semelle, abs(e_charge), B_eff))

# Contrainte sous la semelle (répartition trapézoïdale)
q_max <- G_total / L_semelle * (1 + 6 * e_charge / L_semelle)
q_min <- G_total / L_semelle * (1 - 6 * e_charge / L_semelle)

cat("Contraintes sous la semelle :\n")
cat(sprintf("  q_max = %.2f kPa (Éq. 19)\n", q_max))
cat(sprintf("    q_max = G_total/B × (1 + 6e/B)\n"))
cat(sprintf("    q_max = %.2f/%.2f × (1 + 6×%.3f/%.2f) = %.2f kPa\n\n",
            G_total, L_semelle, e_charge, L_semelle, q_max))
cat(sprintf("  q_min = %.2f kPa (Éq. 20)\n", q_min))
cat(sprintf("    q_min = G_total/B × (1 - 6e/B)\n"))
cat(sprintf("    q_min = %.2f/%.2f × (1 - 6×%.3f/%.2f) = %.2f kPa\n\n",
            G_total, L_semelle, e_charge, L_semelle, q_min))

# Vérification
cat(sprintf("Capacité portante admissible : q_adm = %.0f kPa\n", qref))
cat(sprintf("  Critère : q_max ≤ q_adm\n"))
if (q_max <= qref) {
  cat(sprintf("  ✓ VÉRIFIÉ (%.2f kPa ≤ %.0f kPa)\n\n", q_max, qref))
} else {
  cat(sprintf("  ✗ NON VÉRIFIÉ (%.2f kPa > %.0f kPa)\n\n", q_max, qref))
}

# Vérification de l'excentricité
cat(sprintf("Vérification de l'excentricité : e ≤ B/6\n"))
e_limite <- L_semelle / 6
if (abs(e_charge) <= e_limite) {
  cat(sprintf("  ✓ VÉRIFIÉ (%.3f m ≤ %.3f m)\n\n", abs(e_charge), e_limite))
} else {
  cat(sprintf("  ✗ NON VÉRIFIÉ (%.3f m > %.3f m)\n\n", abs(e_charge), e_limite))
}

# ====== CALCUL DU BASCULEMENT ACCEPTABLE ======
cat("==============================================================\n")
cat("### 9. CALCUL DU BASCULEMENT ACCEPTABLE ###\n\n")

# Variation de déplacement limite pour maintenir FS_r = 1.5
# À partir de l'équation : (M_stab - ΔM) / M_renversant = 1.5
# Où ΔM est la perte de moment due au basculement

# Déplacement horizontal limite au sommet
# Angle limite pour FS_r = 1.5
theta_limite_rad <- atan((M_stab_total / M_renversant - 1.5) * M_renversant / (G_total * L_semelle / 2))
theta_limite_deg <- theta_limite_rad * 180 / pi
deplacement_limite_mm <- tan(theta_limite_rad) * H_mur * 1000

cat("Limites de basculement acceptables :\n")
cat(sprintf("  Angle limite : θ_lim = %.3f° (Éq. 21)\n", theta_limite_deg))
cat(sprintf("  Déplacement horizontal limite au sommet : Δ_lim = %.2f mm (Éq. 22)\n", deplacement_limite_mm))
cat(sprintf("    Δ_lim = H × tan(θ_lim) = %.1f × tan(%.3f°) = %.2f mm\n\n",
            H_mur, theta_limite_deg, deplacement_limite_mm))

# Calcul du déplacement mesuré (mois 1 vs mois 24)
# À la position la plus critique (14-16 m)
deplacement_initial_centre <- 540.68  # mm (mois 1, position 14m)
deplacement_final_centre <- 567.01  # mm (mois 24, position 14m)
deplacement_mesure <- deplacement_final_centre - deplacement_initial_centre
angle_mesure_rad <- atan(deplacement_mesure / 1000 / H_mur)
angle_mesure_deg <- angle_mesure_rad * 180 / pi

cat("Mesures réelles (position 14 m) :\n")
cat(sprintf("  Déplacement initial (mois 1) : %.2f mm\n", deplacement_initial_centre))
cat(sprintf("  Déplacement final (mois 24) : %.2f mm\n", deplacement_final_centre))
cat(sprintf("  Variation : Δ = %.2f mm\n", deplacement_mesure))
cat(sprintf("  Angle mesuré : θ = %.3f°\n\n", angle_mesure_deg))

cat("Comparaison avec les limites :\n")
if (deplacement_mesure <= deplacement_limite_mm) {
  cat(sprintf("  ✓ ACCEPTABLE (%.2f mm ≤ %.2f mm)\n", deplacement_mesure, deplacement_limite_mm))
  cat(sprintf("  ✓ ACCEPTABLE (%.3f° ≤ %.3f°)\n\n", angle_mesure_deg, theta_limite_deg))
} else {
  cat(sprintf("  ✗ CRITIQUE (%.2f mm > %.2f mm)\n", deplacement_mesure, deplacement_limite_mm))
  cat(sprintf("  ✗ CRITIQUE (%.3f° > %.3f°)\n\n", angle_mesure_deg, theta_limite_deg))
}

# ====== SYNTHÈSE ET RECOMMANDATIONS ======
cat("==============================================================\n")
cat("### 10. SYNTHÈSE ET RECOMMANDATIONS ###\n\n")

verifications <- data.frame(
  Critere = c("Renversement", "Glissement", "Capacité portante", "Excentricité", "Basculement mesuré"),
  Valeur = c(FS_renversement, FS_glissement, q_max, abs(e_charge), deplacement_mesure),
  Limite = c(1.5, 1.5, qref, e_limite, deplacement_limite_mm),
  Unite = c("-", "-", "kPa", "m", "mm"),
  Statut = c(
    ifelse(FS_renversement >= 1.5, "✓ OK", "✗ NON CONFORME"),
    ifelse(FS_glissement >= 1.5, "✓ OK", "✗ NON CONFORME"),
    ifelse(q_max <= qref, "✓ OK", "✗ NON CONFORME"),
    ifelse(abs(e_charge) <= e_limite, "✓ OK", "✗ NON CONFORME"),
    ifelse(deplacement_mesure <= deplacement_limite_mm, "✓ OK", "✗ CRITIQUE")
  ),
  stringsAsFactors = FALSE
)

print(verifications)
cat("\n")

# Sauvegarde des résultats
write.csv(verifications, "images/synthese_verifications.csv", row.names = FALSE)

cat("Recommandations :\n")
if (deplacement_mesure > deplacement_limite_mm) {
  cat("  1. INTERVENTION URGENTE REQUISE\n")
  cat("  2. Renforcement immédiat de la zone centrale (10-20 m)\n")
  cat("  3. Mise en place de tirants d'ancrage\n")
  cat("  4. Surveillance hebdomadaire renforcée\n")
  cat("  5. Évacuation du remblai sur la zone critique si nécessaire\n")
} else if (deplacement_mesure > deplacement_limite_mm * 0.7) {
  cat("  1. Surveillance mensuelle renforcée\n")
  cat("  2. Prévoir un renforcement à moyen terme\n")
  cat("  3. Limiter les charges en tête de mur\n")
} else {
  cat("  1. Surveillance trimestrielle\n")
  cat("  2. Mur en bon état structurel\n")
}

cat("\n\nFichier de synthèse créé : images/synthese_verifications.csv\n")
cat("Calculs Eurocode terminés.\n")
