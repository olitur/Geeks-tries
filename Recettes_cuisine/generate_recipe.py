#!/usr/bin/env python3
"""
Recipe Generator - Generates Typst PDF files from recipe metadata
Author: Claude
Date: 2025-11-08

Usage:
    python generate_recipe.py <recipe_folder>

Example:
    python generate_recipe.py Madeleines
"""

import re
import sys
from pathlib import Path
from typing import Dict, List, Optional


def parse_info_file(info_path: Path) -> Dict:
    """
    Parse informations_*.txt file and extract all metadata.

    Returns a dictionary with all recipe information:
    - name: recipe name
    - ingredients: list of {name, quantity, price, bulk_qty, bulk_price, cost}
    - preparation_steps: list of steps
    - cooking: {time, temp, recipient, precautions, verification_during, verification_end}
    - serving: {time_after, items, persons}
    - prices: {ingredients, energy, total}
    """
    data = {
        'name': '',
        'ingredients': [],
        'preparation_steps': [],
        'cooking': {},
        'serving': {},
        'prices': {}
    }

    with open(info_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Parse recipe name
    name_match = re.search(r'^name:\s*(.+)$', content, re.MULTILINE)
    if name_match:
        data['name'] = name_match.group(1).strip()

    # Parse ingredients (up to 10)
    for i in range(1, 11):
        ingredient = {}

        # Extract ingredient fields
        name_pattern = rf'^ingredient#{i}_name:\s*(.+)$'
        qty_pattern = rf'^ingredient#{i}_quantity:\s*(.+)$'
        price_pattern = rf'^ingredient#{i}_price:\s*(.+)$'

        name_match = re.search(name_pattern, content, re.MULTILINE)
        qty_match = re.search(qty_pattern, content, re.MULTILINE)
        price_match = re.search(price_pattern, content, re.MULTILINE)

        if name_match:
            ing_name = name_match.group(1).strip()
            # Skip if empty or [ ]
            if ing_name and ing_name not in ['[ ]', '[]']:
                ingredient['name'] = ing_name
                ingredient['quantity'] = qty_match.group(1).strip() if qty_match else ''
                ingredient['price'] = price_match.group(1).strip() if price_match else ''

                # Extract bulk info and cost from comments
                # Look for comments between this ingredient and the next
                section_pattern = rf'# ingredient#{i} -+(.+?)(?=# ingredient#{i+1}|# Preparation|$)'
                section_match = re.search(section_pattern, content, re.DOTALL)
                if section_match:
                    section = section_match.group(1)

                    # Extract bulk quantity and price
                    bulk_qty = re.search(r'# bulk quantity:\s*(.+)$', section, re.MULTILINE)
                    bulk_price = re.search(r'# bulk price:\s*(.+)$', section, re.MULTILINE)
                    ing_cost = re.search(r'# resulting cost:\s*(.+)$', section, re.MULTILINE)

                    ingredient['bulk_quantity'] = bulk_qty.group(1).strip() if bulk_qty else ''
                    ingredient['bulk_price'] = bulk_price.group(1).strip() if bulk_price else ''
                    ingredient['cost'] = ing_cost.group(1).strip() if ing_cost else ''

                data['ingredients'].append(ingredient)

    # Parse preparation steps (up to 10)
    for i in range(1, 11):
        step_pattern = rf'^preparation_step#{i}:\s*(.+)$'
        step_match = re.search(step_pattern, content, re.MULTILINE)
        if step_match:
            step = step_match.group(1).strip()
            if step and step not in ['[ ]', '[]']:
                data['preparation_steps'].append(step)

    # Parse cooking info
    cooking_fields = {
        'time': r'^cooking_time:\s*(.+)$',
        'temperature': r'^cooking_temperature:\s*(.+)$',
        'recipient': r'^cooking_recipient:\s*(.+)$',
        'precautions': r'^cooking_prior_precautions:\s*(.+)$',
        'verification_during': r'^cooking_verification_steps_during:\s*(.+)$',
        'verification_end': r'^cooking_verification_step_end:\s*(.+)$',
    }

    for key, pattern in cooking_fields.items():
        match = re.search(pattern, content, re.MULTILINE)
        if match:
            value = match.group(1).strip()
            if value and value not in ['[ ]', '[]']:
                data['cooking'][key] = value

    # Parse serving info
    serving_fields = {
        'time_after': r'^serving_time_after_cooking:\s*(.+)$',
        'items': r'^serving_number_of_items:\s*(.+)$',
        'persons': r'^serving_number_of_persons:\s*(.+)$',
    }

    for key, pattern in serving_fields.items():
        match = re.search(pattern, content, re.MULTILINE)
        if match:
            value = match.group(1).strip()
            if value and value not in ['[ ]', '[]']:
                data['serving'][key] = value

    # Calculate total ingredient cost
    total_ingredients = 0.0
    for ing in data['ingredients']:
        if ing.get('cost'):
            # Extract numeric value from cost (e.g., "0,51 euros" -> 0.51)
            cost_str = ing['cost'].replace(',', '.').replace('euros', '').strip()
            try:
                cost_val = float(cost_str)
                total_ingredients += cost_val
            except ValueError:
                pass

    # Extract energy cost
    energy_match = re.search(r'# energy price \(electric oven\):\s*(.+)$', content, re.MULTILINE)
    energy_cost = 0.0
    if energy_match:
        energy_str = energy_match.group(1).strip().replace(',', '.').replace('euros', '').replace('[ ]', '0').strip()
        try:
            energy_cost = float(energy_str)
        except ValueError:
            pass

    data['prices'] = {
        'ingredients_total': f"{total_ingredients:.2f} €".replace('.', ','),
        'energy': f"{energy_cost:.2f} €".replace('.', ',') if energy_cost > 0 else None,
        'total': f"{(total_ingredients + energy_cost):.2f} €".replace('.', ',')
    }

    return data


def generate_recipe_typst(data: Dict, recipe_folder: Path, output_path: Path):
    """Generate the main recipe Typst file."""

    recipe_name = data['name']

    # Check if image exists
    image_path = recipe_folder / "images" / f"{recipe_folder.name}.jpg"
    if not image_path.exists():
        # Try other common image extensions
        for ext in ['.jpeg', '.png', '.jpg']:
            test_path = recipe_folder / "images" / f"{recipe_folder.name}{ext}"
            if test_path.exists():
                image_path = test_path
                break

    image_relative = f"images/{image_path.name}" if image_path.exists() else None

    # Build image parameter
    if image_relative:
        image_param = f'"{image_relative}"'
    else:
        image_param = "none"

    typst_content = f"""// ============================================================
// Recette : {recipe_name}
// ============================================================
// Fichier généré automatiquement par generate_recipe.py
// ============================================================

#import "../assets/style/style_recettes.typ": *

// ============================================================
// RECETTE
// ============================================================

#recipe_title(
  "{recipe_name}",
  {image_param}
)

// Ingrédients
#ingredients_section((
"""

    # Add ingredients
    for ing in data['ingredients']:
        typst_content += f'  (name: "{ing["name"]}", quantity: "{ing["quantity"]}"),\n'

    typst_content += """))

// Préparation
#preparation_section((
"""

    # Add preparation steps
    for step in data['preparation_steps']:
        # Escape quotes in steps
        step_escaped = step.replace('"', '\\"')
        typst_content += f'  "{step_escaped}",\n'

    typst_content += "))\n\n"

    # Add cooking info
    if data['cooking']:
        cooking = data['cooking']
        typst_content += f"""// Cuisson
#cooking_info(
  "{cooking.get('time', '')}",
  "{cooking.get('temperature', '')}",
  "{cooking.get('recipient', '')}",
"""
        if cooking.get('precautions'):
            prec_escaped = cooking['precautions'].replace('"', '\\"')
            typst_content += f'  precautions: "{prec_escaped}"\n'
        typst_content += ")\n\n"

    # Add serving info
    if data['serving']:
        serving = data['serving']
        persons = serving.get('persons', '')
        items = serving.get('items', '')
        time_after = serving.get('time_after', '')

        typst_content += f"""// Service
#serving_info(
  "{persons}",
"""
        if items:
            typst_content += f'  items: "{items}",\n'
        if time_after:
            time_escaped = time_after.replace('"', '\\"')
            typst_content += f'  time_after: "{time_escaped}"\n'
        typst_content += ")\n\n"

    # Add exercises section for children
    typst_content += """// ============================================================
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
    Si la recette est pour """ + data['serving'].get('persons', '6') + """ personnes, combien faut-il d'ingrédients pour """ + str(int(data['serving'].get('persons', '6').split()[0]) * 2 if data['serving'].get('persons') else '12') + """ personnes ?

    #v(0.5em)
    _Multiplie chaque quantité par 2 !_
  ]
)

#tips_box[
  N'oublie pas de toujours demander l'aide d'un adulte pour utiliser le four ! 👨‍👩‍👧‍👦
]
"""

    # Write to file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(typst_content)

    print(f"✅ Generated: {output_path}")


def generate_cost_typst(data: Dict, recipe_folder: Path, output_path: Path):
    """Generate the cost analysis Typst file."""

    recipe_name = data['name']

    typst_content = f"""// ============================================================
// Coût de revient : {recipe_name}
// ============================================================
// Fichier généré automatiquement par generate_recipe.py
// ============================================================

#import "../assets/style/style_recettes.typ": *

// ============================================================
// ANALYSE DES COÛTS
// ============================================================

#align(center)[
  #v(2em)
  #text(size: 24pt, weight: "bold", fill: orange)[
    Coût de revient
  ]
  #v(0.5em)
  #text(size: 18pt, fill: lightbrown)[
    {recipe_name}
  ]
  #v(2em)
]

= Récapitulatif de la recette

#box(
  fill: cream.darken(5%),
  stroke: 1pt + orange,
  radius: 0.5em,
  inset: 1em,
  width: 100%
)[
  *Nom :* {recipe_name} \
  *Pour :* {data['serving'].get('persons', 'N/A')} \
"""

    if data['serving'].get('items'):
        typst_content += f"  *Nombre de pièces :* {data['serving']['items']} \\\n"

    if data['cooking'].get('time'):
        typst_content += f"  *Temps de cuisson :* {data['cooking']['time']}\n"

    typst_content += "]\n\n"

    # Detailed cost breakdown
    typst_content += """= Détail des coûts par ingrédient

#table(
  columns: (2fr, 1fr, 1fr, 1fr, 1fr),
  align: (left, center, center, center, right),
  stroke: 0.5pt + inkl,
  fill: (col, row) => if row == 0 { orange.lighten(70%) },
  inset: 0.7em,

  // Header
  [*Ingrédient*], [*Quantité achetée*], [*Prix d'achat*], [*Quantité utilisée*], [*Coût*],

  // Rows
"""

    # Add ingredient rows
    for ing in data['ingredients']:
        name = ing['name']
        bulk_qty = ing.get('bulk_quantity', '—')
        bulk_price = ing.get('bulk_price', '—')
        quantity = ing['quantity']
        cost = ing.get('cost', '—')

        typst_content += f'  [{ name}], [{bulk_qty}], [{bulk_price}], [{quantity}], [*{cost}*],\n'

    typst_content += ")\n\n"

    # Summary table
    typst_content += f"""= Résumé des coûts

#cost_table(
  (
"""

    for ing in data['ingredients']:
        typst_content += f'    (name: "{ing["name"]}", quantity: "{ing["quantity"]}", price: "{ing.get("cost", "—")}"),\n'

    energy = data['prices'].get('energy')
    total = data['prices']['total']

    typst_content += "  ),\n"
    if energy:
        typst_content += f'  energy_cost: "{energy}",\n'
    typst_content += f'  total: "{total}"\n'
    typst_content += ")\n\n"

    # Cost per serving
    if data['serving'].get('persons'):
        try:
            persons = int(data['serving']['persons'].split()[0])
            total_val = float(total.replace('€', '').replace(',', '.').strip())
            cost_per_person = total_val / persons
            typst_content += f"""= Coût par personne

#align(center)[
  #box(
    fill: green.lighten(80%),
    stroke: 2pt + green,
    radius: 0.8em,
    inset: 1.5em,
  )[
    #text(size: 18pt, weight: "bold", fill: green)[
      {cost_per_person:.2f} € par personne
    ]
  ]
]

#v(1em)

""".replace('.', ',')
        except:
            pass

    # Savings tips
    typst_content += """= Astuces pour économiser

#tips_box[
  - Acheter les ingrédients en plus grande quantité permet souvent de réduire le coût unitaire
  - Comparer les prix entre différents magasins
  - Privilégier les produits de saison
  - Éviter le gaspillage en pesant précisément les quantités
]

#fun_fact[
  En cuisinant toi-même, tu économises souvent 50% par rapport aux produits tout faits du commerce !
]
"""

    # Write to file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(typst_content)

    print(f"✅ Generated: {output_path}")


def main():
    if len(sys.argv) < 2:
        print("Usage: python generate_recipe.py <recipe_folder>")
        print("Example: python generate_recipe.py Madeleines")
        sys.exit(1)

    recipe_folder_name = sys.argv[1]
    script_dir = Path(__file__).parent
    recipe_folder = script_dir / recipe_folder_name

    if not recipe_folder.exists():
        print(f"❌ Error: Recipe folder not found: {recipe_folder}")
        sys.exit(1)

    # Find informations file
    info_files = list(recipe_folder.glob("informations_*.txt"))
    if not info_files:
        print(f"❌ Error: No informations_*.txt file found in {recipe_folder}")
        sys.exit(1)

    info_file = info_files[0]
    print(f"📄 Reading: {info_file}")

    # Parse metadata
    data = parse_info_file(info_file)
    print(f"📋 Recipe: {data['name']}")
    print(f"   - {len(data['ingredients'])} ingredients")
    print(f"   - {len(data['preparation_steps'])} preparation steps")

    # Generate recipe typst file
    recipe_output = recipe_folder / f"recette_{recipe_folder_name}.typ"
    generate_recipe_typst(data, recipe_folder, recipe_output)

    # Generate cost analysis typst file
    cost_output = recipe_folder / f"cout-revient_{recipe_folder_name}.typ"
    generate_cost_typst(data, recipe_folder, cost_output)

    print("\n✅ Generation complete!")
    print(f"\nTo compile:")
    print(f"  cd {recipe_folder}")
    print(f"  typst compile {recipe_output.name}")
    print(f"  typst compile {cost_output.name}")


if __name__ == "__main__":
    main()
