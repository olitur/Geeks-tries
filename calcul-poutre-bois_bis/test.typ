// test.typ - GARANTIE SANS ERREUR
= Test Typst

// Simple calcul
#let b = 0.53
#let h = 0.62
#let L = 7.35

#grid(columns: (1fr, 1fr), gutter: 5mm,
  [Largeur], [#b m],
  [Hauteur], [#h m],
  [Portée], [#L m]
)

#text(red)[✅ Si ce PDF se compile, Typst est OK]