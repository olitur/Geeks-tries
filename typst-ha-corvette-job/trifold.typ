#import "glyphs.typ"

#set text(font: "Barlow", size: 10pt)
#set par(leading: 0.45em, spacing: 1.6em, justify: true)
#set heading(bookmarked: false)
#set page(
  paper: "us-letter",
  flipped: true,
  margin: (bottom: 0.5in, top: 0.25in, inside: 0.25in, outside: 0.25in),
)
#show heading.where(level: 1): head => block([
  #set par(justify: false)
  #set text(font: "Orbitron", size: 23pt, tracking: 0.05em, stretch: 75%)
  #smallcaps(head.body)
])
#show heading.where(level: 2): head => block([
  #set par(justify: false)
  #set text(font: "Barlow", size: 14pt, tracking: 0.05em, stretch: 75%, weight: "semibold")
  #smallcaps(head.body)
])
#show heading.where(level: 3): head => [
  #set par(justify: false, spacing: 0em)
  #set heading()
  #set text(font: "Barlow", size: 11pt, tracking: 0.05em, stretch: 75%, weight: "semibold")
  #smallcaps(head.body)
]
#let smalltext(body) = [
  #set text(size: 8pt)
  #body
]

// outside
#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 0.4in,
  grid(
    columns: (1fr),
    rows: (1fr, auto, 1fr, auto),
    [],
    grid.cell({
      block([
        == The Situation
        Harrison Armory Corvette _*Sigma*_ has disappeared somewhere over the jungle planet *Engiri*. The ship was scheduled to depart Engiri bearing valuable cargo destined for the planet's orbital platform, but after missing their scheduled check-in, the orbital platform confirmed that the corvette never left the planet.

        == The Job
        Harrison Armory representative *Kassandra Newton* (long black hair, non-nonsense attitude) has hired the PCs to retrieve a package inside of the crashed HA Corvette _Sigma_.
        The objective is a blue box bearing a red seal. Newton refuses to elaborate upon its contents, simply insisting that it be retrieved intact.

        == The Investigation
        While tracking down information about the corvette in *Engiri City*, the PCs can learn:
        - The citizens of the city are unfamiliar with Harrison Armory. In fact, the local government has embargoed HA entirely from the planet, and have negotiated with Union to enforce the embargo.
        - The are no signs of smoke from a crash, which would have made locating the crash site easier; this is unusual.
        - Locals are aware of a regular airship trade route over the jungles, carrying daily deliveries to and from a small town outside the city. However, since yesterday, no ships have come from or gone to the town.
        #par([Embrace random character traits for NPCs using tables from The Long Rim!])

        == Finding the Crash Site
        The jungles of Engiri are treacherous, and hostile toward mechs. Traversing the jungles along the trade route is a Skill Challenge (_Lancer_, p. 47). Upon failure, the PCs' mechs take *4#glyphs.kinetic*.

        This journey is a good opportunity for players to establish group dynamics, or flesh them out if they have already been established. Encourage this with prompts: What do you think of the Pegasus pilot you're teaming up with? Does the Lich scare your character? What do you think of this job?
      ])
    }),
    []
  ),
  grid(
    columns: (1fr),
    rows: (1fr, auto, 1fr, auto),
    [],
    grid.cell({
      block([
        == What's in the Corvette?
        table(
        columns: (10%, 1fr),
        stroke: 0pt,
        fill: (col, row) => if calc.even(row) {
          rgb(236, 236, 236)
        } else {
          white
        },
        table.cell(align: horizon + center, [1]),
        [A sealed metal box labeled “Paracausal Hardlight Generator - PROTOTYPE", plastered with warning symbols.
          Opening without care causes an energy explosion that deals *5#glyphs.energy\AP*.],
        table.cell(align: horizon + center, [2]),
        [A gene bank for a whole lot of HA elites. Absurdly valuable on the black market, as they could be used to clone someone and ransom them back for money.],
        table.cell(align: horizon + center, [3]),
        [Plans for a new general market frame from HA specializing in energy weapons. A
          keen eye may notice it is actually a “crypto plan”: it looks fine in practice but the
          technical details fall apart once you start to seriously think about it, instead
          revealing weird codewords in unexpected places.],
        table.cell(align: horizon + center, [4]),
        [Deeds for a planet far away from here, with plans to build a massive mega
          structure on it. A side note on the bottom right reads “Issue to solve: locals”.],
        table.cell(align: horizon + center, [5]),
        [An NHP in its coffin. Their class is unknown even to themselves, as is their
          purpose. They will only “activate” if the players decide to flip a switch; otherwise
          they will remain dormant. The NHP is obsessed with a “facility” that they demand to
          return to, and will loudly protest if the players attempt to take them back to their HA
          contact. If installed in a mech, they will try and force a hostile takeover to force
          said mech to go to “the facility”. They don’t know why they want to go back, only
          that they need to go there.],
        table.cell(align: horizon + center, [6]),
        [Enough guns to arm a small army, addressed to a location in the Dawnline Shore. Close inspection of these guns reveals
          they are shoddy and malfunctioning on purpose. The identity of the intended recipient is unclear.]
      )
      ])
    }),
    [],
    [
      #par(
        smalltext([The original idea for _The HA Corvette Job_ is credit Eld and edited by Elesday. Trifold layout and additional editing by Ben Torell.]),
      )
      #par(
        smalltext([The HA Corvette Job is not an official Lancer product; it is a third party work, and is not affiliated with Massif Press. The HA Corvette Job is published via the Lancer Third Party License. Lancer is copyright Massif Press.]),
      )
    ]
  ),
  {
    // front
    rect(width: 100%, height: 100%, inset: 0pt, stroke: 4pt, image("images/corvettejob.png", width: 100%, height: 100%))
    place(
      bottom,
      rect(
        stroke: 0pt,
        inset: 12pt,
        width: 100%,
        fill: black,
        text(
          fill: white,
          [
            = The HA Corvette Job
            #smallcaps(text(font: "Orbitron", weight: "bold", [A Lancer One-shot for 3-5 players]))
          ],
        ),
      ),
    )
    place(top + right, image("images/powered_by_Lancer-01.svg", width: 50%))
  },
)

// inside
#grid(
  columns: (1fr, 1fr, 1fr),
  rows: (auto, 3em, auto),
  column-gutter: 0.4in,
  grid.cell(
    rowspan: 3,
    grid(
      rows: (auto, 1fr),
      row-gutter: 1em,
      block([
        == The Crash Site
        #par([The corvette crash-landed in the middle of the forest, providing plenty of opportunity for soft cover (trees and bushes) and hard cover (bits and pieces of the corvette, rocks, big trees).])
        - *Gray*: Rocks, provide hard cover
        - *Black*: Corvette wreck
        - *Dark Green*: Forest
        - *Light Green*: Grass
        - *Skin pink*: Trail the corvette left while crashing
        - *Blue*: Strange liquid, deals #glyphs.energy as Dangerous Terrain (_Lancer_ p. 62)

        == Opponents
        The players will find that some looters are pillaging the crashed ship. Who they are exactly is up to you, but I would recommend making them outright hostile. Here are a few ideas:

        - They are pirates who shot down the corvette.
        - They are a group of scientists who are here to get whatever they can to sell it back to HA at a price that is way too high.
        - The are mercs hired to also look for this ship, but they were ordered to shoot anyone on sight.

        == Combat
        The NPCs want to lay claim to and defend the ship. Use a Control sitrep (_Lancer_, p. 268) and put the control points near the shipwreck, probably in a position that is closer to the Opponents than to the players, then make the players deploy on the northern extremity of the map.
      ]),
      grid.cell(
        align: center,
        box(image("images/box.png", width: 100%, fit: "stretch")),
      )
    ),
  ),
  grid.cell(colspan: 2, image("images/ha-corvette-job-map.png")),[],[],
  grid.cell({
    block([
      == NPCs
      table(
      columns: (20%, 1fr),
      stroke: 0pt,
      fill: (col, row) => if row == 0 {
        rgb(199, 199, 199)
      } else if calc.even(row) {
        rgb(236, 236, 236)
      } else {
        white
      },
      table.header(
        table.cell(align: horizon + center, [*Players*]),
        table.cell(align: horizon + center, [*NPCs*]),
      ),
      table.cell(align: horizon + center, rowspan: 4, [3]),
      [1x *Bastion* (Fearless Defender)],
      [1x *Assault* (Rank Discipline)],
      [1x *Hive* (Driving Swarm)],
      [1x *Archer*],
      table.hline(stroke: 0.5pt),
      table.cell(align: horizon + center, rowspan: 2, [4]),
      [+1 *Assault* (Rank Discipline)],
      [+1 *Priest* (Greater Investiture)],
      table.hline(stroke: 0.5pt),
      table.cell(align: horizon + center, rowspan: 2, [5]),
      [+1 *Bastion* (Fearless Defender)],
      [+1 *Archer*],
      )
      ])
    }),
  grid.cell({
    block([
      == NPC Game Plan
      - The Hive should try to put down its swarms in as many control points as possible while shooting at people through walls thanks to its seeking weapon.
      - The Assault(s) should try to contest zones if they can, and occupy them if they can. Try to place them in cover to shoot down people on certain points to get them off from them.
      - The Bastion, Hive and Archer(s) should try to lock down one of the two “alleyways” on the map. Archers can take cover behind the Bastion, and the Priest (if present) can grant its Greater Investiture on the Bastion while staying in cover. The Bastion can use its Fearless Defender reaction if an Assault is near enough to warrant it.
    ])
  }),
)