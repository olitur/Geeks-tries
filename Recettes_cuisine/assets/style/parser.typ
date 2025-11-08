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

// Parse all ingredients (up to 10)
#let parse-ingredients(content) = {
  let ingredients = ()

  for i in range(1, 11) {
    let name = extract-field(content, "ingredient#" + str(i) + "_name")

    if name != none {
      let ing = (
        name: name,
        quantity: extract-field(content, "ingredient#" + str(i) + "_quantity"),
        price: extract-field(content, "ingredient#" + str(i) + "_price"),
      )

      // Note: For now, bulk info and cost are in the comments
      // We'll extract the resulting cost from the price summary section instead
      // This is simpler and doesn't require complex regex

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
  // In Typst, we use float() but need to handle potential errors
  let value = 0.0

  // Simple parsing: find the first number
  let num-match = clean.matches(regex("(\\d+\\.?\\d*)"))
  if num-match.len() > 0 {
    // Convert string to float
    value = float(num-match.at(0).text)
  }

  value
}

// Extract ingredient costs from the price summary comments
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

// Format price for display
#let format-price(value) = {
  // Convert to string with 2 decimals
  let str-val = str(calc.round(value, digits: 2))

  // Replace period with comma
  str-val = str-val.replace(".", ",")

  str-val + " €"
}

// Main parsing function - reads file and returns all data
#let parse-recipe-file(filename) = {
  let content = read(filename)

  let ingredients = parse-ingredients(content)
  let ingredient-costs = extract-ingredient-costs(content)

  // Add costs to ingredients
  for i in range(ingredients.len()) {
    if i < ingredient-costs.len() and ingredient-costs.at(i) != none {
      ingredients.at(i).insert("cost", ingredient-costs.at(i))
    }
  }

  let energy-val = extract-price-value(extract-field(content, "# energy price (electric oven)"))
  let total-cost = calculate-total-cost(ingredient-costs, energy-cost: energy-val)

  (
    name: extract-field(content, "name"),
    ingredients: ingredients,
    steps: parse-steps(content),
    cooking: parse-cooking(content),
    serving: parse-serving(content),
    prices: (
      energy: if energy-val > 0.0 { format-price(energy-val) } else { none },
      total: format-price(total-cost),
    ),
  )
}
