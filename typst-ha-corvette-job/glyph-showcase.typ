#import "glyphs.typ": *

// Theme colors (from style.typ)
#let sea = rgb("#3b60a0")
#let cream = rgb("#fcfaf6")
#let inkl = rgb("#797979")
#let skyl = rgb("#eff3ff")
#let ink = rgb("#222222")

#set page(
  paper: "a4",
  margin: auto,
  fill: cream.darken(5%),
  footer: context [
    #align(center)[
      #text(size: 9pt, fill: inkl)[
        #counter(page).display() / #counter(page).final().first()
      ]
    ]
  ],
  numbering: "1"
)

#set text(font: ("Arial", "Calibri", "Segoe UI"), size: 10pt)
#set heading(numbering: none)

// Link styling (from philippe.typ)
#show link: it => box(
  it,
  stroke: (bottom: (dash: "dotted", paint: sea, thickness: 0.5pt)),
  outset: (bottom: 2pt)
)

#align(center)[
  #text(font: ("Orbitron", "Arial", "Calibri"), size: 18pt, weight: "bold")[Lancer Glyphs Showcase]
  #v(0.3em)
  #text(font: ("Barlow", "Arial", "Calibri", "Segoe UI"), size: 10pt, style: "italic")[
    All glyphs defined in #link("glyphs.typ")[glyphs.typ]
  ]
]

#v(1em)

// Unicode Resources Information Box
#align(center)[
  #block(
    width: 95%,
    fill: skyl,
    stroke: 0.5pt + sea,
    radius: 5pt,
    inset: 5pt,
    [
      #text(size: 10pt, weight: "bold", fill: sea)[About Unicode Glyphs & Resources]
      #v(0.1em)
      #text(size: 9pt, fill: ink)[
        The Lancer glyphs shown below use custom Unicode codepoints (U+E900–U+E96B) from a specialized icon font.
        For information about finding standard Unicode glyphs and accessing online Unicode databases,
        see the comprehensive resource guide and examples at the end of #link("glyphs.typ")[glyphs.typ]
        (lines 120-201). This guide includes links to unicode-table.com, FileFormat.info, Unicode.org,
        and examples from common Unicode blocks like Geometric Shapes, Arrows, Mathematical Operators,
        and more.
      ]
    ]
  )
]

#v(1em)

#let section(title) = {
  align(left)[
    #text(font: ("Atkinson Hyperlegible", "Arial", "Calibri", "Segoe UI"), size: 12pt, weight: "bold")[#title]
  ]
}

#let glyph-table(..entries) = {
  let items = entries.pos()
  table(
    columns: (auto, 1fr, auto, 1fr, auto, 1fr),
    align: (center + horizon, left + horizon, center + horizon, left + horizon, center + horizon, left + horizon),
    stroke: none,
    inset: (x: 5pt, y: 8pt),
    // Header row with underlines per pair
    table.header(
      box(stroke: (bottom: 0.5pt + inkl), outset: (bottom: 2pt), inset: (bottom: 3pt))[*Glyph*],
      box(stroke: (bottom: 0.5pt + inkl), outset: (bottom: 2pt), inset: (bottom: 3pt))[*Name*],
      box(stroke: (bottom: 0.5pt + inkl), outset: (bottom: 2pt), inset: (bottom: 3pt))[*Glyph*],
      box(stroke: (bottom: 0.5pt + inkl), outset: (bottom: 2pt), inset: (bottom: 3pt))[*Name*],
      box(stroke: (bottom: 0.5pt + inkl), outset: (bottom: 2pt), inset: (bottom: 3pt))[*Glyph*],
      box(stroke: (bottom: 0.5pt + inkl), outset: (bottom: 2pt), inset: (bottom: 3pt))[*Name*],
    ),
    // Data rows
    ..items.flatten()
  )
}

#let make-cells(name, glyph) = (
  box(height: 1.2em, baseline: 30%)[#text(size: 14pt)[#glyph]],
  box(height: 1.2em, baseline: 30%)[#text(font: ("Atkinson Hyperlegible", "Arial", "Calibri", "Segoe UI"), size: 9pt)[`#`#name]]
)

#section("NPC & Templates")
#glyph-table(
  ..make-cells("npcTemplate", npcTemplate),
  ..make-cells("npcFeature", npcFeature),
  ..make-cells("npcClass", npcClass),
  ..make-cells("npcTierCustom", npcTierCustom),
  ..make-cells("npcTier3", npcTier3),
  ..make-cells("npcTier2", npcTier2),
  ..make-cells("npcTier1", npcTier1),
  [], [], // empty cells to fill row
)

#section("Conditions")
#glyph-table(
  ..make-cells("conditionImmobilized", conditionImmobilized),
  ..make-cells("conditionSlow", conditionSlow),
  ..make-cells("conditionStunned", conditionStunned),
  ..make-cells("conditionShredded", conditionShredded),
  ..make-cells("conditionLockOn", conditionLockOn),
  ..make-cells("conditionJammed", conditionJammed),
  ..make-cells("conditionImpaired", conditionImpaired),
  [], [], // empty cells
)

#section("Status Effects")
#glyph-table(
  ..make-cells("statusDownAndOut", statusDownAndOut),
  ..make-cells("statusShutDown", statusShutDown),
  ..make-cells("statusProne", statusProne),
  ..make-cells("statusInvisible", statusInvisible),
  ..make-cells("statusHidden", statusHidden),
  ..make-cells("statusExposed", statusExposed),
  ..make-cells("statusEngaged", statusEngaged),
  ..make-cells("statusDangerZone", statusDangerZone),
)

#section("Actions & Activations")
#glyph-table(
  ..make-cells("activationFull", activationFull),
  ..make-cells("activationQuick", activationQuick),
  ..make-cells("freeAction / free", freeAction),
  ..make-cells("reaction", reaction),
  ..make-cells("activate", activate),
  ..make-cells("deactivate", deactivate),
)

#section("Tech Actions")
#glyph-table(
  ..make-cells("techFull / fullTech", techFull),
  ..make-cells("techQuick / quickTech / invade", techQuick),
  [], [], [], [], // empty cells to fill rows
)

#section("Reserves")
#glyph-table(
  ..make-cells("reserveTactical", reserveTactical),
  ..make-cells("reserveMech", reserveMech),
  ..make-cells("reserveResource", reserveResource),
  ..make-cells("reserveBonus / accuracy", reserveBonus),
  [], [], // empty cells
)

#section("Damage Types")
#glyph-table(
  ..make-cells("burn", burn),
  ..make-cells("energy", energy),
  ..make-cells("explosive", explosive),
  ..make-cells("heat", heat),
  ..make-cells("kinetic", kinetic),
  ..make-cells("variable", variable),
)

#section("Area Effects")
#glyph-table(
  ..make-cells("blast", blast),
  ..make-cells("burst", burst),
  ..make-cells("cone", cone),
  ..make-cells("line", line),
  ..make-cells("barrage", barrage),
  [], [], // empty cells
)

#section("Weapon Types")
#glyph-table(
  ..make-cells("weapon / mechWeapon", weapon),
  ..make-cells("melee", melee),
  ..make-cells("thrown", thrown),
  ..make-cells("range", range),
  ..make-cells("weaponProfile", weaponProfile),
  ..make-cells("weaponMod", weaponMod),
  ..make-cells("grenade", grenade),
  ..make-cells("mine", mine),
  ..make-cells("largeBeam", largeBeam),
)

#section("Pilot & Mech")
#glyph-table(
  ..make-cells("pilot", pilot),
  ..make-cells("frame", frame),
  ..make-cells("reactor", reactor),
  ..make-cells("system / mechSystem", system),
  ..make-cells("systemPoint", systemPoint),
  ..make-cells("coreBonus", coreBonus),
  ..make-cells("overcharge", overcharge),
  ..make-cells("structure", structure),
)

#section("Roles")
#glyph-table(
  ..make-cells("roleArtillery", roleArtillery),
  ..make-cells("roleController", roleController),
  ..make-cells("roleStriker", roleStriker),
  ..make-cells("roleSupport", roleSupport),
  ..make-cells("roletank / roleDefender", roletank),
  [], [], // empty cells
)

#section("Sizes")
#glyph-table(
  ..make-cells("sizeHalf", sizeHalf),
  ..make-cells("size1", size1),
  ..make-cells("size2", size2),
  ..make-cells("size3", size3),
  ..make-cells("size4", size4),
  [], [], // empty cells
)

#section("Ranks")
#glyph-table(
  ..make-cells("rank1", rank1),
  ..make-cells("rank2", rank2),
  ..make-cells("rank3", rank3),
)

#section("Stats & Attributes")
#glyph-table(
  ..make-cells("edef", edef),
  ..make-cells("evasion", evasion),
  ..make-cells("save", save),
  ..make-cells("sensor", sensor),
  ..make-cells("difficulty", difficulty),
  ..make-cells("threat", threat),
  ..make-cells("repair", repair),
  [], [], // empty cells
)

#section("Items & Equipment")
#glyph-table(
  ..make-cells("genericItem", genericItem),
  ..make-cells("skill", skill),
  ..make-cells("talent", talent),
  ..make-cells("trait", trait),
  ..make-cells("protocol", protocol),
  ..make-cells("drone", drone),
  ..make-cells("deployable", deployable),
  ..make-cells("ammo", ammo),
)

#section("Management")
#glyph-table(
  ..make-cells("license", license),
  ..make-cells("manufacturer", manufacturer),
  ..make-cells("squad", squad),
  ..make-cells("downtime", downtime),
  ..make-cells("contentManager", contentManager),
  ..make-cells("campaign", campaign),
  ..make-cells("encounter", encounter),
  ..make-cells("compendium", compendium),
)

#section("Vehicles")
#glyph-table(
  ..make-cells("ship", ship),
  ..make-cells("vehicle", vehicle),
  [], [], [], [], // empty cells
)

#section("Special Icons")
#glyph-table(
  ..make-cells("nestedHexagons", nestedHexagons),
  ..make-cells("orbit", orbit),
  ..make-cells("orbital", orbital),
  ..make-cells("burning", burning),
  ..make-cells("balance", balance),
  ..make-cells("reticule", reticule),
  ..make-cells("spikes", spikes),
  ..make-cells("eclipse", eclipse),
  ..make-cells("swordArray", swordArray),
  ..make-cells("marker", marker),
  [], [], // empty cells
)
