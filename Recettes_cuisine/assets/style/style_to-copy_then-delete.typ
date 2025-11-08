// ============================================================
// Le Grand Continent - Interview Style Template
// ============================================================

// ============================================================
// Metadata Configuration
// To be set in each article file before importing style.typ
// ============================================================
// #let article-title = "Article Title"
// #let article-subtitle = "Article Subtitle"
// #let article-date = "1er novembre 2025"
// #let article-theme = "Theme Name"
// #let article-url = "https://legrandcontinent.eu/..."
// #let article-promo = [Promotional text with links]
//
// #let interviewer = (
//   name: "Antoine Levy",
//   initials: "A.L.",
//   url: "https://legrandcontinent.eu/fr/p/antoine-levy/"
// )
//
// #let speaker = (
//   name: "Philippe Aghion",
//   initials: "P.A.",
//   title: "Prix Nobel d'Économie 2025" // Optional
// )
// ============================================================

// / Theme Colors
#let sea = rgb("#3b60a0")
#let sky = rgb("#bdd0f1")
#let skyl = rgb("#eff3ff")
#let skyll = rgb("#f4f9ff")
#let paper = rgb("#f5f6f8")
#let ink = rgb("#222222")
#let inkl = rgb("#797979")
#let cream = rgb("#fcfaf6")

// Page setup (will be overridden in article file with article-theme)
// This is just a fallback/default
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 1.5cm),
  fill: cream.darken(0%)
)

// Text settings
#set text(
  font: "Alegreya",
  lang: "fr",
  size: 11pt,
)

// Paragraph settings
#set par(
  justify: true,
  leading: 0.52em,
)

// Disable built-in footnotes (we use manual endnotes instead)
#show footnote.entry: none

// ============================================================
// Helper Functions
// ============================================================

// Title table with photo
#let title_block(title, subtitle, image_path, speaker_name: none) = {
  table(
    columns: (1fr, 1fr),
    stroke: none,
    inset: 0.5em,
    // Row 1: Title spanning both columns
    table.cell(
      colspan: 2,
      [
        #text(size: 18pt, weight: "bold", fill: ink)[
          #if speaker_name != none [
            #smallcaps[#speaker_name] : #title
          ] else [
            #title
          ]
        ]
      ]
    ),
    // Row 2, Column 1: Subtitle
    table.cell(
      align: left + horizon,
      [
        #text(size: 13pt, style: "italic", fill: inkl)[
          #subtitle
        ]
      ]
    ),
    // Row 2, Column 2: Photo
    table.cell(
      rowspan: 1,
      [
        #image(image_path, width: 100%)
      ]
    ),
  )
}

// Info table with author/date and journal promotion
#let info_block(author, date, theme, promo_text, authors: none) = {
  // Handle multiple authors if provided
  let author_text = if authors != none and type(authors) == array {
    // Multiple authors
    authors.map(a => a.name).join(", ")
  } else {
    // Single author (backward compatibility)
    author
  }

  table(
    columns: (1fr, 1fr),
    stroke: none,
    inset: 0.5em,
    // Row 1, Column 1: Author and date
    [
      #text(size: 10pt)[
        *Auteur#if authors != none and authors.len() > 1 [s] :* #author_text \
        *Date :* #date \
        *Thème :* #theme
      ]
    ],
    // Row 1, Column 2: Journal info
    [
      #text(size: 9pt, fill: inkl)[
        #align(right)[
          _Le Grand Continent_ — Analyses géopolitiques \
          legrandcontinent.eu | Entretiens
        ]
      ]
    ],
    // Row 2: Promotional info
    table.cell(
      colspan: 2,
      [
        #v(0.5em)
        #text(size: 9pt, fill: inkl)[
          #promo_text
        ]
      ]
    ),
  )
}

// Question styling helper
#let question(interviewer: none, initials: "", body) = [
  #v(1em)
  == #text(weight: "bold", fill: ink)[#body]
  #v(0.5em)
]

// Answer styling helper
// Uses speaker metadata if available, otherwise falls back to provided name
#let answer(speaker: none, name: "", body) = {
  let prefix = if type(speaker) == dictionary {
    speaker.name + " — "
  } else if name != "" {
    name + " — "
  } else {
    ""
  }
  set par(first-line-indent: 1em, justify: true)
  [
    #text(weight: "bold", fill: sea)[#prefix]#text(fill: ink)[#body]
    #v(1em)
  ]
}

// Citation/pull quote styling helper
#let citation(quote, author) = [
  #v(0.5em)
  #align(right)[
    #block(
      width: 90%,
      [
        #text(size: 16pt, style: "italic", fill: sea)[
          « #quote »
        ]
        #v(0.1em)
        #text(size: 10pt, weight: "bold", fill: inkl)[
          — #author
        ]
      ]
    )
  ]
  #v(0.5em)
]

// Chapeau/introduction paragraph
#let chapeau(body) = [
  #text(size: 11pt, weight: "bold")[#body]
  #v(1.5em)
]

// Conference header with title and subtitle
#let conference_header(title, subtitle) = [
  #v(1.5em)
  #align(center)[
    #text(size: 14pt, weight: "bold", fill: ink)[#title]
    #v(0.5em)
    #text(size: 10pt, style: "italic", fill: inkl)[#subtitle]
  ]
  #v(1em)
  #line(length: 100%, stroke: 0.5pt + inkl)
  #v(1em)
]

// Side-by-side images helper
#let image_pair(left_path, right_path, left_caption: "", right_caption: "") = {
  table(
    columns: (1fr, 1fr),
    stroke: none,
    inset: 0.3em,
    align: center,
    [
      #image(left_path, width: 95%)
      #if left_caption != "" [
        #v(0.1em)
        #text(size: 8pt, style: "italic", fill: inkl)[#left_caption]
      ]
    ],
    [
      #image(right_path, width: 95%)
      #if right_caption != "" [
        #v(0.1em)
        #text(size: 8pt, style: "italic", fill: inkl)[#right_caption]
      ]
    ]
  )
  v(1em)
}

// Endnote reference in body text (with circled number and label for back-linking)
#let endnote_ref(num) = [
  #box(
    circle(
      radius: 0.45em,
      stroke: 0.5pt + sea,
      inset: 0.1em,
      text(size: 0.7em, fill: sea, weight: "bold")[#num]
    )
  )#label("note-ref-" + str(num))
]

// Endnote entry in notes section with back-link
#let endnote_entry(num, content) = [
  #v(0.1em)
  #box(
    circle(
      radius: 0.45em,
      stroke: 0.5pt + sea,
      inset: 0.1em,
      text(size: 0.7em, fill: sea, weight: "bold")[#num]
    )
  )#label("note-" + str(num))
  #h(0.3em)
  #text(size: 9pt)[#content #h(0.5em) #link(label("note-ref-" + str(num)))[#text(fill: sea, size: 10pt)[↩]]]
]

// Endnotes section
#let endnotes(notes_content) = [
  // #pagebreak()
  #v(.5em)
  #text(size: 16pt, weight: "bold", fill: ink)[Notes]
  #v(.5em)
  #notes_content
]

// Article footer
#let article_footer(url) = [
  #v(2em)
  #line(length: 100%, stroke: 0.5pt)
  #v(0.5em)
  #align(center)[
    #text(size: 8pt, fill: inkl, style: "italic")[
      Article original : #link(url) \
      #v(0.2em)
      Document généré le #datetime.today().display("[day]/[month]/[year]") avec #link("https://typst.app/")[Typst]
    ]
  ]
]
