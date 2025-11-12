#!/usr/bin/env python3
"""
Génère les graphiques d'enveloppe des efforts (N, T, M)
Usage: python generate_graphics.py enveloppe_forces.csv
"""

import sys
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')  # Backend sans affichage pour génération automatique


def generate_force_envelopes(csv_file, output_prefix="enveloppe"):
    """Génère les graphiques des enveloppes N, T, M"""

    # Charger les données
    df = pd.read_csv(csv_file)

    # Créer figure avec 3 subplots
    fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(12, 10))
    fig.suptitle('Enveloppes des Efforts Internes (ELU)', fontsize=16, fontweight='bold')

    # 1. Effort Normal N(x)
    ax1.plot(df['x'], df['N'], 'g-', linewidth=2, label='N(x)')
    ax1.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
    ax1.set_xlabel('Position x (m)', fontsize=11)
    ax1.set_ylabel('Effort Normal N (kN)', fontsize=11)
    ax1.set_title('Effort Normal', fontsize=12, fontweight='bold')
    ax1.grid(True, alpha=0.3)
    ax1.legend()

    # 2. Effort Tranchant V(x)
    ax2.plot(df['x'], df['V'], 'b-', linewidth=2, label='V(x)')
    ax2.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
    ax2.fill_between(df['x'], 0, df['V'], alpha=0.3, color='blue')
    ax2.set_xlabel('Position x (m)', fontsize=11)
    ax2.set_ylabel('Effort Tranchant V (kN)', fontsize=11)
    ax2.set_title('Effort Tranchant', fontsize=12, fontweight='bold')
    ax2.grid(True, alpha=0.3)

    # Annotations min/max
    v_max = df['V'].max()
    v_min = df['V'].min()
    x_vmax = df.loc[df['V'].idxmax(), 'x']
    x_vmin = df.loc[df['V'].idxmin(), 'x']
    ax2.annotate(f'V_max = {v_max:.2f} kN', xy=(x_vmax, v_max),
                xytext=(x_vmax + 0.5, v_max + 2),
                arrowprops=dict(arrowstyle='->', color='blue'),
                fontsize=9, color='blue')
    ax2.annotate(f'V_min = {v_min:.2f} kN', xy=(x_vmin, v_min),
                xytext=(x_vmin - 1.5, v_min - 2),
                arrowprops=dict(arrowstyle='->', color='blue'),
                fontsize=9, color='blue')
    ax2.legend()

    # 3. Moment Fléchissant M(x)
    ax3.plot(df['x'], df['M'], 'r-', linewidth=2, label='M(x)')
    ax3.fill_between(df['x'], 0, df['M'], alpha=0.3, color='red')
    ax3.axhline(y=0, color='k', linestyle='-', linewidth=0.5)
    ax3.set_xlabel('Position x (m)', fontsize=11)
    ax3.set_ylabel('Moment Fléchissant M (kNm)', fontsize=11)
    ax3.set_title('Moment Fléchissant', fontsize=12, fontweight='bold')
    ax3.grid(True, alpha=0.3)

    # Annotation moment max
    m_max = df['M'].max()
    x_mmax = df.loc[df['M'].idxmax(), 'x']
    ax3.annotate(f'M_max = {m_max:.2f} kNm', xy=(x_mmax, m_max),
                xytext=(x_mmax + 0.5, m_max + m_max*0.1),
                arrowprops=dict(arrowstyle='->', color='red', lw=1.5),
                fontsize=10, color='red', fontweight='bold')
    ax3.legend()

    plt.tight_layout()

    # Sauvegarder
    output_file = f"{output_prefix}_complet.png"
    plt.savefig(output_file, dpi=150, bbox_inches='tight')
    plt.close()

    print(f"✅ Graphique créé : {output_file}")
    print(f"   - N max = {df['N'].abs().max():.2f} kN")
    print(f"   - V max = {v_max:.2f} kN, V min = {v_min:.2f} kN")
    print(f"   - M max = {m_max:.2f} kNm à x = {x_mmax:.2f} m")

    # Générer aussi graphiques individuels
    # Moment seul
    fig_m, ax_m = plt.subplots(figsize=(10, 5))
    ax_m.plot(df['x'], df['M'], 'r-', linewidth=2.5)
    ax_m.fill_between(df['x'], 0, df['M'], alpha=0.3, color='red')
    ax_m.axhline(y=0, color='k', linestyle='-', linewidth=0.8)
    ax_m.set_xlabel('Position x (m)', fontsize=12)
    ax_m.set_ylabel('Moment M (kNm)', fontsize=12)
    ax_m.set_title('Diagramme du Moment Fléchissant M(x)', fontsize=14, fontweight='bold')
    ax_m.grid(True, alpha=0.3)
    ax_m.annotate(f'M_max = {m_max:.2f} kNm', xy=(x_mmax, m_max),
                 xytext=(x_mmax + 0.5, m_max - m_max*0.15),
                 arrowprops=dict(arrowstyle='->', color='darkred', lw=2),
                 fontsize=11, color='darkred', fontweight='bold',
                 bbox=dict(boxstyle='round,pad=0.5', facecolor='yellow', alpha=0.7))
    plt.tight_layout()
    plt.savefig(f"{output_prefix}_moment.png", dpi=150, bbox_inches='tight')
    plt.close()

    print(f"✅ Graphique moment créé : {output_prefix}_moment.png")

    # Effort tranchant seul
    fig_v, ax_v = plt.subplots(figsize=(10, 5))
    ax_v.plot(df['x'], df['V'], 'b-', linewidth=2.5)
    ax_v.fill_between(df['x'], 0, df['V'], where=(df['V'] >= 0), alpha=0.3, color='blue', label='Positif')
    ax_v.fill_between(df['x'], 0, df['V'], where=(df['V'] < 0), alpha=0.3, color='cyan', label='Négatif')
    ax_v.axhline(y=0, color='k', linestyle='-', linewidth=0.8)
    ax_v.set_xlabel('Position x (m)', fontsize=12)
    ax_v.set_ylabel('Effort Tranchant V (kN)', fontsize=12)
    ax_v.set_title('Diagramme de l\'Effort Tranchant V(x)', fontsize=14, fontweight='bold')
    ax_v.grid(True, alpha=0.3)
    ax_v.legend()
    plt.tight_layout()
    plt.savefig(f"{output_prefix}_tranchant.png", dpi=150, bbox_inches='tight')
    plt.close()

    print(f"✅ Graphique tranchant créé : {output_prefix}_tranchant.png")

    return {
        'N_max': float(df['N'].abs().max()),
        'V_max': float(v_max),
        'V_min': float(v_min),
        'M_max': float(m_max),
        'x_Mmax': float(x_mmax)
    }


def main():
    if len(sys.argv) < 2:
        print("Usage: python generate_graphics.py enveloppe_forces.csv [output_prefix]")
        sys.exit(1)

    csv_file = sys.argv[1]
    output_prefix = sys.argv[2] if len(sys.argv) > 2 else "enveloppe"

    stats = generate_force_envelopes(csv_file, output_prefix)

    print("\n📊 Statistiques des efforts :")
    print(f"   N max  = {stats['N_max']:.2f} kN")
    print(f"   V max  = {stats['V_max']:.2f} kN")
    print(f"   V min  = {stats['V_min']:.2f} kN")
    print(f"   M max  = {stats['M_max']:.2f} kNm (à x = {stats['x_Mmax']:.2f} m)")


if __name__ == "__main__":
    main()
