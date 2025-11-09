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
  footer: context {
    set text(size: 9pt, fill: inkl)

    // Three-column footer: Logo | Date | Page number
    grid(
      columns: (auto, 1fr, auto),
      column-gutter: 1em,
      // Left: Logo
      image("assets/images/canopee_logo.jpg", height: 1cm),
      // Center: Generation date
      align(center)[
        #text(style: "italic")[
          Généré le #datetime.today().display("[day]/[month]/[year]")
        ]
      ],
      // Right: Pagination
      align(right)[
        Page #counter(page).get().first()/#counter(page).final().first()
      ]
    )
  }
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
  #pad(left: 1em)[
    #grid(
      columns: (auto, 1fr, 1.5fr),
      row-gutter: 0.8em,
      column-gutter: 1em,
      stroke: none,
      ..ingredients.map(ing => (
        [\u{2022}],
        [*#ing.name*],
        [#text(fill: lightbrown, style: "italic")[#ing.quantity]]
      )).flatten()
    )
  ]
  #v(1em)
]

// Preparation steps with numbered list
#let preparation_section(steps) = [
  == \u{1F468}\u{200D}\u{1F373} Préparation

  #set enum(numbering: "1.", indent: 1em)
  #for step in steps [
    + #eval(step.replace("\n", " \\ \n"), mode: "markup")
  ]
  #v(1em)
]

// Cooking info
#let cooking_info(time, temp, recipient, precautions: none) = [
  == \u{1F525} Cuisson

  #set text(size: 10.5pt)
  #pad(left: 1em)[
    #grid(
      columns: (auto, 1fr),
      row-gutter: 0.6em,
      column-gutter: 1em,
      [*Durée :*], [#time],
      [*Température :*], [#temp],
      [*Récipient :*], [#recipient],
      ..if precautions != none {
        ([*Précautions :*], [#precautions])
      } else {
        ()
      },
    )
  ]
  #v(1em)
]

// Serving info
#let serving_info(persons, items: none, time_after: none) = [
  == \u{1F37D}\u{FE0F} Service

  #set text(size: 10.5pt)
  #pad(left: 1em)[
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

// ============================================================
// Helper Functions for TOML Data Processing
// ============================================================

// Extract numeric value from price string (e.g., "0,51 euros" -> 0.51)
#let extract-price-value(price-str) = {
  if price-str == none {
    return 0.0
  }

  // Remove "euros" and trim
  let clean = price-str.replace("euros", "").replace("€", "").trim()

  // Replace comma with period for decimal
  clean = clean.replace(",", ".")

  // Try to convert to float
  let value = 0.0

  // Simple parsing: find the first number
  let num-match = clean.matches(regex("(\\d+\\.?\\d*)"))
  if num-match.len() > 0 {
    // Convert string to float
    value = float(num-match.at(0).text)
  }

  value
}

// Format price for display
#let format-price(value) = {
  // Convert to string with 2 decimals
  let str-val = str(calc.round(value, digits: 2))

  // Replace period with comma
  str-val = str-val.replace(".", ",")

  str-val + " €"
}

// Parse quantity string and convert to base units
// Returns (value, unit) tuple
#let parse-quantity(quantity-str) = {
  if quantity-str == none {
    return (0, "")
  }

  // Match patterns like "250 g", "1.5 kg", "3 œufs", "100 ml"
  let match = quantity-str.match(regex("([0-9.,]+)\\s*([a-zA-Zœéè]+)"))

  if match == none {
    return (0, "")
  }

  let value-str = match.captures.at(0).replace(",", ".")
  let value = float(value-str)
  let unit = match.captures.at(1).trim()

  // Convert to base units (kg → g, units → units, etc.)
  if unit == "kg" {
    return (value * 1000, "g")
  } else if unit == "g" {
    return (value, "g")
  } else if unit in ("œufs", "oeufs", "eggs", "units", "unités", "pièces", "pieces") {
    return (value, "units")
  } else if unit == "l" {
    return (value * 1000, "ml")
  } else if unit == "ml" {
    return (value, "ml")
  }

  // Return as-is if unit not recognized
  return (value, unit)
}

// Calculate ingredient cost from bulk price and quantities
#let calculate-ingredient-cost(bulk-price-str, bulk-quantity-str, recipe-quantity-str) = {
  if bulk-price-str == none or bulk-quantity-str == none or recipe-quantity-str == none {
    return 0.0
  }

  // Extract price value
  let price = extract-price-value(bulk-price-str)

  // Parse quantities
  let (bulk-qty, bulk-unit) = parse-quantity(bulk-quantity-str)
  let (recipe-qty, recipe-unit) = parse-quantity(recipe-quantity-str)

  // Check units match
  if bulk-unit != recipe-unit or bulk-qty == 0 {
    return 0.0
  }

  // Calculate cost: (recipe quantity / bulk quantity) × bulk price
  let ratio = recipe-qty / bulk-qty
  let cost = price * ratio

  return cost
}

// Calculate energy cost from cooking time
// Default: 3.5 kW oven (3500W), 0.51 EUR/kWh electricity rate
#let calculate-energy-cost(cooking-time-str, oven-power-kw: 3.5, rate-per-kwh: 0.51) = {
  if cooking-time-str == none {
    return 0.0
  }

  // Extract minutes from string like "10 minutes" or "25 min"
  let minutes-match = cooking-time-str.match(regex("(\\d+)\\s*(?:minutes?|min)"))
  if minutes-match != none {
    let minutes = float(minutes-match.captures.at(0))
    let hours = minutes / 60.0
    let cost = oven-power-kw * hours * rate-per-kwh
    return cost
  }

  // Extract hours if specified
  let hours-match = cooking-time-str.match(regex("(\\d+)\\s*(?:heures?|h)"))
  if hours-match != none {
    let hours = float(hours-match.captures.at(0))
    let cost = oven-power-kw * hours * rate-per-kwh
    return cost
  }

  return 0.0
}

// Process TOML recipe data - calculate costs and add formatted prices
#let process-recipe-data(toml-data) = {
  // Process ingredients - add cost field to each ingredient
  let processed-ingredients = ()
  for ing in toml-data.ingredients {
    let cost = calculate-ingredient-cost(
      ing.at("bulk_price", default: none),
      ing.at("bulk_quantity", default: none),
      ing.at("quantity", default: none)
    )

    processed-ingredients.push((
      name: ing.name,
      quantity: ing.quantity,
      bulk_quantity: ing.at("bulk_quantity", default: none),
      bulk_price: ing.at("bulk_price", default: none),
      cost: format-price(cost),
    ))
  }

  // Calculate total ingredient cost
  let total-ingredient-cost = 0.0
  for ing in processed-ingredients {
    total-ingredient-cost = total-ingredient-cost + extract-price-value(ing.cost)
  }

  // Calculate energy cost
  let energy-cost = calculate-energy-cost(
    toml-data.cooking.at("time", default: none),
    oven-power-kw: 3.5,
    rate-per-kwh: 0.51
  )

  // Calculate total cost
  let total-cost = total-ingredient-cost + energy-cost

  // Process steps - extract text field from TOML array
  let processed-steps = ()
  for step in toml-data.steps {
    processed-steps.push(step.text)
  }

  // Return processed data
  (
    name: toml-data.name,
    ingredients: processed-ingredients,
    steps: processed-steps,
    cooking: toml-data.cooking,
    serving: toml-data.serving,
    prices: (
      energy: if energy-cost > 0.0 { format-price(energy-cost) } else { none },
      total: format-price(total-cost),
    ),
  )
}
