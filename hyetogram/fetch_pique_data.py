#!/usr/bin/env python3
"""
Fetch real hydrometric data for La Pique at Bagnères-de-Luchon
Station: O004402001
"""

import requests
import pandas as pd
import json

# Fetch water level data from Hub'Eau API
url = "https://hubeau.eaufrance.fr/api/v2/hydrometrie/obs_elab"
params = {
    "code_entite": "O004402001",
    "grandeur_hydro": "H",  # H for water height
    "date_debut_obs_elab": "2024-01-01",
    "date_fin_obs_elab": "2024-12-31",
    "size": 5000
}

print("Fetching water level data from Hub'Eau API...")
response = requests.get(url, params=params)
response.raise_for_status()

data_json = response.json()
print(f"Retrieved {len(data_json['data'])} observations")

# Filter for daily averages (HIXnJ)
daily_data = [obs for obs in data_json['data'] if obs['grandeur_hydro_elab'] == 'HIXnJ']
print(f"Found {len(daily_data)} daily average observations")

# Convert to DataFrame
df = pd.DataFrame(daily_data)
df['date'] = pd.to_datetime(df['date_obs_elab'])
df['water_level_mm'] = df['resultat_obs_elab']

# Convert mm to meters
df['water_level_m'] = df['water_level_mm'] / 1000

# Sort by date
df = df.sort_values('date')

# For now, add placeholder rainfall data (to be replaced with real data)
# Using seasonal patterns typical for Pyrenees
import numpy as np
np.random.seed(42)

# Create realistic rainfall patterns
rainfall = []
for month in df['date'].dt.month:
    # Pyrenees precipitation patterns: wet winter/spring, dry summer, autumn storms
    if month in [1, 2, 11, 12]:  # Winter
        base = 3.5
        events = np.random.exponential(8) if np.random.random() > 0.7 else 0
    elif month in [3, 4, 5]:  # Spring
        base = 2.8
        events = np.random.exponential(10) if np.random.random() > 0.65 else 0
    elif month in [6, 7, 8]:  # Summer
        base = 1.2
        events = np.random.exponential(15) if np.random.random() > 0.8 else 0
    else:  # Autumn
        base = 3.2
        events = np.random.exponential(12) if np.random.random() > 0.6 else 0

    total = base + events
    rainfall.append(round(max(0, total), 1))

df['rainfall_mm'] = rainfall

# Select final columns
output_df = df[['date', 'water_level_m', 'rainfall_mm']].copy()
output_df['date'] = output_df['date'].dt.strftime('%Y-%m-%d')

# Save to CSV
output_file = "pique_data_2024.csv"
output_df.to_csv(output_file, index=False)

print(f"\nData saved to {output_file}")
print(f"\nFirst few rows:")
print(output_df.head(10))
print(f"\nStatistics:")
print(f"Water level range: {output_df['water_level_m'].min():.3f} - {output_df['water_level_m'].max():.3f} m")
print(f"Total rainfall (simulated): {output_df['rainfall_mm'].sum():.1f} mm")
