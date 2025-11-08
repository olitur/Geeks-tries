// ============================================================
// Recipe Book Style Template
// ============================================================
// Generic style file for recipe PDFs with exercises for children
// Designed to be simple and family-friendly
// ============================================================

// ============================================================
// Metadata Configuration
// To be set in each recipe file before importing style.typ
// ============================================================
// #let recipe-name = "Madeleines au beurre"
// #let recipe-image = "images/madeleines.jpg"
// #let serving-persons = 6
// #let serving-items = "12 madeleines"
// ============================================================

// Theme Colors - Warm cooking colors
#let orange = rgb("#ff8c42")      // Warm orange for headers
#let cream = rgb("#fff5eb")       // Cream background
#let brown = rgb("#8b4513")       // Chocolate brown for text
#let lightbrown = rgb("#d2691e")  // Light brown for accents
#let green = rgb("#90be6d")       // Fresh green for healthy notes
#let ink = rgb("#222222")         // Dark text
#let inkl = rgb("#666666")        // Light gray text

// Page setup with logo in footer
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 3cm, left: 2.5cm, right: 2.5cm),
  fill: cream,
  footer: [
    #set align(left)
    #set text(size: 8pt, fill: inkl)
    #line(length: 100%, stroke: 0.5pt + inkl)
    #v(0.3em)
    #grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      [
        #text(style: "italic")[
          Document généré le #datetime.today().display("[day]/[month]/[year]") avec #link("https://typst.app/")[Typst]
        ]
      ],
      [
        // Logo in bottom right
        #image("/assets/images/canopee_logo.jpg", height: 1.2cm)
      ]
    )
  ]
)

// Text settings - Alegreya (from assets/fonts/) with system fallbacks
// Note: On Typst Web, fonts are auto-detected from uploaded files
// For command line: use --font-path assets/fonts flag
#set text(
  font: ("Alegreya", "DejaVu Sans", "Liberation Serif"),
  lang: "fr",
  size: 11pt,
  fill: ink
)

// Paragraph settings
#set par(
  justify: true,
  leading: 0.55em,
  first-line-indent: 0em
)

// Heading styles
#show heading.where(level: 1): it => [
  #v(1.5em)
  #text(size: 20pt, weight: "bold", fill: orange)[
    #smallcaps(it.body)
  ]
  #v(0.5em)
  #line(length: 100%, stroke: 1.5pt + orange)
  #v(1em)
]

#show heading.where(level: 2): it => [
  #v(1.2em)
  #text(size: 16pt, weight: "bold", fill: lightbrown)[
    #it.body
  ]
  #v(0.7em)
]

#show heading.where(level: 3): it => [
  #v(1em)
  #text(size: 13pt, weight: "bold", fill: brown)[
    #it.body
  ]
  #v(0.5em)
]

// ============================================================
// Helper Functions for Recipes
// ============================================================

// Recipe title block with image
#let recipe_title(name, image_path) = {
  align(center)[
    #v(1em)
    #text(size: 24pt, weight: "bold", fill: orange)[
      #name
    ]
    #v(1em)
    #if image_path != none [
      #box(
        stroke: 2pt + orange,
        inset: 0.5em,
        [#image(image_path, width: 50%)]
      )
    ]
    #v(1.5em)
  ]
}

// Ingredients list with nice formatting
#let ingredients_section(ingredients) = [
  == \u{1F95A} Ingrédients

  #set text(size: 11pt)
  #grid(
    columns: (auto, auto, 1fr),
    row-gutter: 0.8em,
    column-gutter: 1em,
    stroke: none,
    ..ingredients.map(ing => (
      [\u{2022}],
      [*#ing.name*],
      [#text(fill: lightbrown, style: "italic")[#ing.quantity]]
    )).flatten()
  )
  #v(1em)
]

// Preparation steps with numbered list
#let preparation_section(steps) = [
  == \u{1F468}\u{200D}\u{1F373} Préparation

  #set enum(numbering: "1.", indent: 1em)
  #for step in steps [
    + #step
  ]
  #v(1em)
]

// Cooking info box
#let cooking_info(time, temp, recipient, precautions: none) = [
  == \u{1F525} Cuisson

  #box(
    fill: orange.lighten(80%),
    stroke: 1.5pt + orange,
    radius: 0.5em,
    inset: 1em,
    width: 100%,
  )[
    #set text(size: 10.5pt)
    #grid(
      columns: (auto, 1fr),
      row-gutter: 0.6em,
      column-gutter: 1em,
      [*Durée :*], [#time],
      [*Température :*], [#temp],
      [*Récipient :*], [#recipient],
    )

    #if precautions != none [
      #v(0.5em)
      #line(length: 100%, stroke: 0.5pt + orange)
      #v(0.5em)
      *Précautions :* #precautions
    ]
  ]
  #v(1em)
]

// Serving info box
#let serving_info(persons, items: none, time_after: none) = [
  == \u{1F37D}\u{FE0F} Service

  #box(
    fill: green.lighten(80%),
    stroke: 1.5pt + green,
    radius: 0.5em,
    inset: 1em,
    width: 100%,
  )[
    #set text(size: 10.5pt)
    #grid(
      columns: (auto, 1fr),
      row-gutter: 0.6em,
      column-gutter: 1em,
      [*Pour :*], [#persons],
      ..if items != none {
        ([*Nombre de pièces :*], [#items])
      } else {
        ()
      },
      ..if time_after != none {
        ([*Quand servir :*], [#time_after])
      } else {
        ()
      },
    )
  ]
  #v(1em)
]

// Exercise box for children
#let exercise_box(title, content) = [
  #box(
    fill: rgb("#fff9e6"),
    stroke: 2pt + rgb("#ffd700"),
    radius: 0.8em,
    inset: 1.2em,
    width: 100%,
  )[
    #set text(size: 11pt)
    #align(center)[
      #text(size: 14pt, weight: "bold", fill: rgb("#ff6b35"))[
        \u{270F}\u{FE0F} EXERCICE: #title
      ]
    ]
    #v(0.8em)
    #content
  ]
  #v(1em)
]

// Cost breakdown table
#let cost_table(ingredients, energy_cost: none, total: none) = [
  == \u{1F4B0} Coût de revient

  #table(
    columns: (1fr, auto, auto),
    align: (left, center, right),
    stroke: 0.5pt + inkl,
    fill: (col, row) => if row == 0 { orange.lighten(70%) } else if row == ingredients.len() + 1 { green.lighten(80%) },
    inset: 0.7em,

    // Header
    [*Ingrédient*], [*Quantité*], [*Prix*],

    // Ingredients rows
    ..ingredients.map(ing => (
      [#ing.name],
      [#ing.quantity],
      [#text(fill: brown)[#ing.cost]]
    )).flatten(),

    // Energy cost if provided
    ..if energy_cost != none {
      (
        [Énergie (four électrique)],
        [\u{2014}],
        [#text(fill: brown)[#energy_cost]]
      )
    } else {
      ()
    },

    // Total row
    ..if total != none {
      (
        [*TOTAL*],
        [],
        [*#text(fill: orange, size: 12pt)[#total]*]
      )
    } else {
      ()
    },
  )
  #v(1em)
]

// Tips and notes box
#let tips_box(content) = [
  #box(
    fill: rgb("#e8f5e9"),
    stroke: 1.5pt + green,
    radius: 0.5em,
    inset: 1em,
    width: 100%,
  )[
    #set text(size: 10.5pt)
    #text(weight: "bold", fill: green)[\u{1F4A1} ASTUCE :]
    #v(0.3em)
    #content
  ]
  #v(1em)
]

// Fun fact box for children
#let fun_fact(content) = [
  #box(
    fill: rgb("#fef3e2"),
    stroke: 1.5pt + rgb("#f4a261"),
    radius: 0.5em,
    inset: 1em,
    width: 100%,
  )[
    #set text(size: 10.5pt)
    #text(weight: "bold", fill: rgb("#e76f51"))[\u{1F31F} LE SAIS-TU ?]
    #v(0.3em)
    #content
  ]
  #v(1em)
]
