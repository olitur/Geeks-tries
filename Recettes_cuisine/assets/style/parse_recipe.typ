// ============================================================
// Recipe Metadata Parser
// ============================================================
// Parses informations_*.txt files and extracts recipe data
// Pure Typst - no external dependencies needed!
// ============================================================

// Parse a single field from the content
#let parse_field(content, field_name) = {
  let pattern = field_name + ":\\s*(.+)"
  let matches = content.matches(regex(pattern))
  if matches.len() > 0 {
    let value = matches.at(0).captures.at(0).trim()
    // Skip empty values
    if value != "[ ]" and value != "[]" and value != "" {
      value
    } else {
      none
    }
  } else {
    none
  }
}

// Parse all ingredients (up to 10)
#let parse_ingredients(content) = {
  let ingredients = ()
  for i in range(1, 11) {
    let name = parse_field(content, "ingredient#" + str(i) + "_name")
    if name != none {
      let quantity = parse_field(content, "ingredient#" + str(i) + "_quantity")
      let price = parse_field(content, "ingredient#" + str(i) + "_price")

      // Extract cost from comments (# resulting cost: X)
      let cost_pattern = "# ingredient#" + str(i) + "[^#]*# resulting cost:\\s*([^\\n]+)"
      let cost_matches = content.matches(regex(cost_pattern))
      let cost = if cost_matches.len() > 0 {
        let val = cost_matches.at(0).captures.at(0).trim()
        if val != "[ ]" and val != "[]" { val } else { none }
      } else { none }

      // Extract bulk info
      let bulk_qty_pattern = "# ingredient#" + str(i) + "[^#]*# bulk quantity:\\s*([^\\n]+)"
      let bulk_price_pattern = "# ingredient#" + str(i) + "[^#]*# bulk price:\\s*([^\\n]+)"

      let bulk_qty_matches = content.matches(regex(bulk_qty_pattern))
      let bulk_price_matches = content.matches(regex(bulk_price_pattern))

      let bulk_qty = if bulk_qty_matches.len() > 0 {
        let val = bulk_qty_matches.at(0).captures.at(0).trim()
        if val != "[ ]" and val != "[]" { val } else { none }
      } else { none }

      let bulk_price = if bulk_price_matches.len() > 0 {
        let val = bulk_price_matches.at(0).captures.at(0).trim()
        if val != "[ ]" and val != "[]" { val } else { none }
      } else { none }

      ingredients.push((
        name: name,
        quantity: if quantity != none { quantity } else { "" },
        price: if price != none { price } else { "" },
        cost: if cost != none { cost } else { "" },
        bulk_quantity: if bulk_qty != none { bulk_qty } else { "" },
        bulk_price: if bulk_price != none { bulk_price } else { "" },
      ))
    }
  }
  ingredients
}

// Parse all preparation steps (up to 10)
#let parse_preparation_steps(content) = {
  let steps = ()
  for i in range(1, 11) {
    let step = parse_field(content, "preparation_step#" + str(i))
    if step != none {
      steps.push(step)
    }
  }
  steps
}

// Parse cooking information
#let parse_cooking(content) = {
  (
    time: parse_field(content, "cooking_time"),
    temperature: parse_field(content, "cooking_temperature"),
    recipient: parse_field(content, "cooking_recipient"),
    precautions: parse_field(content, "cooking_prior_precautions"),
    verification_during: parse_field(content, "cooking_verification_steps_during"),
    verification_end: parse_field(content, "cooking_verification_step_end"),
  )
}

// Parse serving information
#let parse_serving(content) = {
  (
    time_after: parse_field(content, "serving_time_after_cooking"),
    items: parse_field(content, "serving_number_of_items"),
    persons: parse_field(content, "serving_number_of_persons"),
  )
}

// Calculate total cost from ingredients
#let calculate_total_cost(ingredients, energy_cost: none) = {
  let total = 0.0

  for ing in ingredients {
    if ing.cost != "" and ing.cost != none {
      // Extract number from cost string (e.g., "0,51 euros" -> 0.51)
      let cost_str = ing.cost.replace("euros", "").replace("€", "").replace(",", ".").trim()
      // Try to convert to float
      let cost_val = float(cost_str)
      if cost_val != none {
        total = total + cost_val
      }
    }
  }

  // Add energy cost if provided
  if energy_cost != none {
    let energy_str = energy_cost.replace("euros", "").replace("€", "").replace(",", ".").trim()
    let energy_val = float(energy_str)
    if energy_val != none {
      total = total + energy_val
    }
  }

  // Format as currency
  str(total).replace(".", ",") + " €"
}

// Main parser function - reads and parses the entire informations file
#let parse_recipe_file(filepath) = {
  let content = read(filepath)

  let recipe_name = parse_field(content, "name")
  let ingredients = parse_ingredients(content)
  let steps = parse_preparation_steps(content)
  let cooking = parse_cooking(content)
  let serving = parse_serving(content)

  // Extract energy cost from comments
  let energy_pattern = "# energy price \\(electric oven\\):\\s*([^\\n]+)"
  let energy_matches = content.matches(regex(energy_pattern))
  let energy_cost = if energy_matches.len() > 0 {
    let val = energy_matches.at(0).captures.at(0).trim()
    if val != "[ ]" and val != "[]" { val } else { none }
  } else { none }

  let total_cost = calculate_total_cost(ingredients, energy_cost: energy_cost)

  (
    name: if recipe_name != none { recipe_name } else { "Recipe" },
    ingredients: ingredients,
    preparation_steps: steps,
    cooking: cooking,
    serving: serving,
    energy_cost: energy_cost,
    total_cost: total_cost,
  )
}
