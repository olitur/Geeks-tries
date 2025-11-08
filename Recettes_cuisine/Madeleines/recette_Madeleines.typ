// ============================================================
// Recette : Madeleines au beurre
// ============================================================
// Fichier généré automatiquement par generate_recipe.py
// ============================================================

#import "../assets/style/style_recettes.typ": *

// ============================================================
// RECETTE
// ============================================================

#recipe_title(
  "Madeleines au beurre",
  none
)

// Ingrédients
#ingredients_section((
  (name: "Farine", quantity: "250 g"),
  (name: "Beurre", quantity: "100 g"),
  (name: "Œufs", quantity: "3 units"),
  (name: "Sucre", quantity: "150 g"),
))

// Préparation
#preparation_section((
  "Mélanger la farine et le sucre.",
  "Ajouter les œufs un à un.",
  "Faire fondre le beurre et l'incorporer à la pâte.",
  "Laisser reposer la pâte au réfrigérateur pendant 1 heure.",
  "Remplir les moules à madeleines avec la pâte.",
))

// Cuisson
#cooking_info(
  "10 minutes",
  "200 °C (thermostat 6-7)",
  "Moules à madeleines",
  precautions: "Beurrer et fariner les moules."
)

// Service
#serving_info(
  "6 personnes",
  items: "12 madeleines",
  time_after: "Immédiatement après refroidissement"
)

// ============================================================
// EXERCICES POUR LES ENFANTS
// ============================================================

= Activités ludiques

#exercise_box(
  "Compte les ingrédients",
  [
    Combien d'ingrédients différents utilise-t-on pour cette recette ?

    #v(1em)
    Réponse : \_\_\_\_\_\_\_
  ]
)

#exercise_box(
  "Les étapes de préparation",
  [
    Dessine les 3 étapes principales de la préparation :

    #v(1em)
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 1em,
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[Étape 1]
        ]
      ],
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[Étape 2]
        ]
      ],
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[Étape 3]
        ]
      ]
    )
  ]
)

#fun_fact[
  Sais-tu que la cuisine est une science ? Quand tu mélanges les ingrédients et que tu les chauffes, des réactions chimiques se produisent ! C'est ce qui donne le bon goût et la belle forme à tes gâteaux.
]

#exercise_box(
  "Calcul gourmand",
  [
    Si la recette est pour 6 personnes personnes, combien faut-il d'ingrédients pour 12 personnes ?

    #v(0.5em)
    _Multiplie chaque quantité par 2 !_
  ]
)

#tips_box[
  N'oublie pas de toujours demander l'aide d'un adulte pour utiliser le four ! 👨‍👩‍👧‍👦
]
