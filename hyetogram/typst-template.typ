  #let article(
  // The book's title.
  title: "Book title",

  // The book's author.
  author: "Author",

  // The book's author.
  species: "default species",

  // The file path
  filepath: none,

  // The paper size to use.
  paper: "a4",

  // The book's content.
  body,
) = {
  // Set the document's metadata.
  set document(title: title, author: author)

  // Set the body font.
  set text(font: "Source Sans Pro")

  // Configure the page properties.
  set page(
    paper: paper,
    background: place(
        top + left,
        rect(
            width: 2cm,
            height: 100%,
            fill: rgb("#0D2C54")
        )
    ),
    foreground: context [
      // Page numbering - horizontal at footer height
      #place(
        left + bottom,
        dx: 0.7cm,
        dy: -0.7cm,
        text(size: 10pt, fill: white, weight: "bold")[
          #counter(page).display("1/1", both: true)
        ]
      )
      // Filepath - rotated 90 degrees clockwise, centered in blue rectangle
      #place(
        top + left,
        dx: 1cm,
        dy: 2.5cm,
        rotate(
          90deg,
          origin: left,
          text(size: 8pt, fill: white)[
            #let fp = if filepath != none { filepath } else { document.title + ".pdf" }
            #fp.replace("\\_", "_")
          ]
        )
      )
    ],
    margin: (bottom: 1cm, top: 1cm, left: 2.5cm, right: 2.5cm),
    footer: none
  )

  // Links styling - blue text with dotted underline and external icon
  show link: it => {
    text(
      fill: rgb("#0066cc"),
      box(
        it,
        stroke: (bottom: (dash: "dotted", paint: rgb("#0066cc"), thickness: 0.5pt)),
        outset: (bottom: 2pt)
      )
    )
    // Add external link icon
    h(0.2em)
    text(fill: rgb("#0066cc"), size: 0.8em)[↗]
  }

  page(align(left + top)[
    #h(-1cm)
    #box(
        fill: rgb("#339989"),
        width: 0.7fr,
        inset: 10pt,
    )[
        #text(size: 2.5em, fill: white)[*#title*]
    ]
    #v(2em, weak: true)
    #body
  ])


}