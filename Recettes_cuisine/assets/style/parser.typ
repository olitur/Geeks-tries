// ============================================================
// Recipe Metadata Parser
// ============================================================
// Reads and parses informations_*.txt files
// ============================================================

// Extract a field value from text
#let extract-field(content, field-name) = {
  let pattern = field-name + ":\s*(.+)"
  let matches = content.matches(regex(pattern))

  if matches.len() > 0 {
    let value = matches.at(0).captures.at(0).trim()

    // Strip inline comments (anything after #)
    let comment-pos = value.position("#")
    if comment-pos != none {
      value = value.slice(0, comment-pos).trim()
    }

    // Check if empty or [ ]
    if value == "[ ]" or value == "[]" or value == "" {
      none
    } else {
      value
    }
  } else {
    none
  }
}

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
// Examples: "250 g" → (250, "g"), "1 kg" → (1000, "g"), "3 œufs" → (3, "units")
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

// Parse all ingredients (up to 10)
#let parse-ingredients(content) = {
  let ingredients = ()

  for i in range(1, 11) {
    let name = extract-field(content, "ingredient#" + str(i) + "_name")

    if name != none {
      let recipe-qty = extract-field(content, "ingredient#" + str(i) + "_quantity")
      let bulk-qty = extract-field(content, "ingredient#" + str(i) + "_bulk_quantity")
      let bulk-price = extract-field(content, "ingredient#" + str(i) + "_bulk_price")

      // Calculate cost automatically from bulk price and quantities
      let cost = calculate-ingredient-cost(bulk-price, bulk-qty, recipe-qty)

      let ing = (
        name: name,
        quantity: recipe-qty,
        bulk_quantity: bulk-qty,
        bulk_price: bulk-price,
        cost: format-price(cost),
      )

      ingredients.push(ing)
    }
  }

  ingredients
}

// Parse preparation steps (up to 10)
#let parse-steps(content) = {
  let steps = ()

  for i in range(1, 11) {
    let step = extract-field(content, "preparation_step#" + str(i))
    if step != none {
      steps.push(step)
    }
  }

  steps
}

// Parse cooking information
#let parse-cooking(content) = {
  (
    time: extract-field(content, "cooking_time"),
    temperature: extract-field(content, "cooking_temperature"),
    recipient: extract-field(content, "cooking_recipient"),
    precautions: extract-field(content, "cooking_prior_precautions"),
    verification_during: extract-field(content, "cooking_verification_steps_during"),
    verification_end: extract-field(content, "cooking_verification_step_end"),
  )
}

// Parse serving information
#let parse-serving(content) = {
  (
    time_after: extract-field(content, "serving_time_after_cooking"),
    items: extract-field(content, "serving_number_of_items"),
    persons: extract-field(content, "serving_number_of_persons"),
  )
}

// Extract ingredient costs from the price summary comments (deprecated - now calculated automatically)
#let extract-ingredient-costs(content) = {
  let costs = ()

  // Look for lines like: # ingredient#1 price: 0,51 euros
  for i in range(1, 11) {
    let pattern = "# ingredient#" + str(i) + " price:\\s*(.+)"
    let matches = content.matches(regex(pattern))

    if matches.len() > 0 {
      let cost-str = matches.at(0).captures.at(0).trim()
      if cost-str != "[ ]" and cost-str != "[]" and cost-str != "" {
        costs.push(cost-str)
      } else {
        costs.push(none)
      }
    } else {
      costs.push(none)
    }
  }

  costs
}

// Calculate total cost from ingredients
#let calculate-total-cost(ingredient-costs, energy-cost: 0.0) = {
  let total = energy-cost

  for cost in ingredient-costs {
    if cost != none {
      total = total + extract-price-value(cost)
    }
  }

  total
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

// Main parsing function - reads file and returns all data
#let parse-recipe-file(filename) = {
  let content = read(filename)

  let ingredients = parse-ingredients(content)

  // Extract ingredient costs (already calculated in parse-ingredients)
  let ingredient-costs = ()
  for ing in ingredients {
    let cost-val = extract-price-value(ing.cost)
    ingredient-costs.push(ing.cost)
  }

  // Get cooking info to calculate energy cost
  let cooking-info = parse-cooking(content)

  // Calculate energy cost automatically from cooking time
  // Using 3.5 kW oven power (3500W) and 0.51 EUR/kWh electricity rate
  let energy-val = calculate-energy-cost(cooking-info.time, oven-power-kw: 3.5, rate-per-kwh: 0.51)
  let total-cost = calculate-total-cost(ingredient-costs, energy-cost: energy-val)

  (
    name: extract-field(content, "name"),
    ingredients: ingredients,
    steps: parse-steps(content),
    cooking: cooking-info,
    serving: parse-serving(content),
    prices: (
      energy: if energy-val > 0.0 { format-price(energy-val) } else { none },
      total: format-price(total-cost),
    ),
  )
}
