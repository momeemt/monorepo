#let themes = (
  momeemt: (
    main: rgb("#9c7e5a"),
    sub: rgb("#ceb593"),
  ),
  nix: (
    main: rgb("#4b6cb1"),
    sub: rgb("#7db1dd"),
  ),
  sakura: (
    main: rgb("#cf646b"),
    sub: rgb("#f1969c"),
  )
)

#let icons = (
  momeemt: "assets/momeemt.png",
  ehomaki: "assets/ehomaki.jpeg",
  sakura: "assets/sakura.jpg",
)

#let make(
  theme: "momeemt",
  icon: "momeemt",
) = {
  let colors = themes.at(theme, default: none)
  if colors == none {
    panic("Unknown theme: " + theme)
  }

  let icon = icons.at(icon, default: none)
  if icon == none {
    panic("Unknown icon: " + icon)
  }

  let master = (
    colors: colors,
    icon: icon
  )

  let styling(it) = {
    set page(
      paper: "presentation-16-9",
      margin: 0cm,
    )

    set text(
      font: ("Hiragino Kaku Gothic Pro", "Noto Sans CJK JP"),
      weight: 600,
      size: 24pt,
      lang: "ja",
      top-edge: 0.88em,
    )

    set heading(numbering: "1.")
    show heading.where(level: 1): it => {
      let n = counter(heading).at(it.location()).at(0)
      text(size: 28pt, fill: master.colors.main, tracking: 2pt)[
        #n. #it.body
      ]
    }
    show heading.where(level: 2): it => text(size: 28pt, fill: master.colors.main)[#it.body]

    it
  }

  let drawBorder(
    width,
    color1: master.colors.main,
    color2: master.colors.sub,
  ) = {
    let borderMaster = (
      long: 50%,
      short: width,
      dx: 0mm,
      dy: 0mm,
      colors: (
        main: color1,
        sub: color2,
      ),
    )
    let make_row(y, colors) = (left, right)
      .zip(colors)
      .map(((x, color)) => place(
        y + x,
        dx: borderMaster.dx,
        dy: borderMaster.dy,
        rect(
          width: borderMaster.long,
          height: borderMaster.short,
          fill: color,
        ),
      ))
    let make_col(y, colors) = (top, bottom)
      .zip(colors)
      .map(((x, color)) => place(
        y + x,
        dx: borderMaster.dx,
        dy: borderMaster.dy,
        rect(
          width: borderMaster.short,
          height: borderMaster.long,
          fill: color,
        ),
      ))
    let colors = (borderMaster.colors.main, borderMaster.colors.sub)
    let all = (
      make_row(top, colors) + make_row(bottom, colors.rev()) + make_col(left, colors) + make_col(right, colors.rev())
    )
    for it in all {
      it
    }
  }

  let slide(page-number: true, body) = {
    pagebreak(weak: true)
    set page(
      foreground: [
        #drawBorder(6mm)

        #if page-number == true {
          place(right + bottom, dx: -15mm, dy: -15mm)[
            #text(size: 12pt, fill: master.colors.main)[
              #context counter(page).display() / #context counter(page).final().first()
            ]
          ]
        }
      ],
    )
    body
  }

  let description-slide(
    title: none,
    show-toc: true,
    description,
  ) = {
    if title == none {
      panic("Title is required for description slide.")
    }
    let pad_width = 11mm
    slide(
      pad(left: pad_width, right: pad_width, top: pad_width)[
        #place(
          top + left,
          dx: 5mm,
          dy: 5mm,
          rect(
            width: 3mm,
            height: 14mm,
            fill: master.colors.main,
          ),
        )
        #pad(left: 15mm, top: 7.2mm, right: 20mm)[
          #if show-toc {
            heading(level: 2)[#title]
          } else {
            text(size: 28pt, fill: master.colors.main)[#title]
          }
          #v(0mm)
          #text(size: 20pt, fill: master.colors.main)[
            #description
          ]
        ]
      ],
    )
  }

  let dash-grid() = {
    for r in range(0, 5) {
      for c in range(0, 9) {
        place(
          top + left,
          dx: c * 7mm,
          dy: r * 7.8mm,
        )[
          #rotate(-45deg)[
            #line(length: 6.5mm, stroke: (paint: master.colors.sub, thickness: 1.8pt))
          ]
        ]
      }
    }
  }

  let toc-slide(title: "目次", depth: 1) = {
    let pad_width = 11mm
    slide(
      page-number: false,
      pad(left: pad_width, right: pad_width, top: pad_width, bottom: pad_width)[
        #place(top + left, dx: 5mm, dy: 5mm, rect(width: 3mm, height: 14mm, fill: master.colors.main))
        #pad(left: 15mm, top: 7.2mm, right: 20mm)[
          #text(size: 28pt, fill: master.colors.main)[#title]
          #v(8mm)
          #text(size: 18pt, fill: master.colors.main)[
            #outline(depth: depth, title: none, indent: 10mm)
          ]
        ]
      ],
    )
  }

  let chapter-slide(title: none) = {
    if title == none { panic("Title is required for chapter slide.") }
    slide(
      page-number: false,
      [
        #place(horizon + center)[
          #stack(dir: ltr, spacing: 8mm)[
            #rect(
              width: 3mm,
              height: 12mm,
              fill: master.colors.main,
            )
          ][
            #heading(level: 1)[#title]
          ]
        ]
      ],
    )
  }

  let title-slide(
    title: none,
    subtitle: none,
    author: none,
    affiliation: none,
    date: none,
  ) = {
    if title == none {
      panic("Title is required for title slide.")
    }
    if author == none {
      panic("Author is required for title slide.")
    }
    if date == none {
      panic("Date is required for title slide.")
    }
    slide(
      page-number: false,
      [
        #place(top + left, dx: 30mm, dy: 42mm)[
          #text(size: 28pt, fill: master.colors.main, tracking: 2pt)[
            #title
          ]
          #if subtitle != none {
            v(2mm)
            text(size: 18pt, fill: master.colors.sub)[
              #subtitle
            ]
          }
        ]
        #place(top + left, dx: 30mm, dy: 90mm)[
          #dash-grid()
        ]
        #place(top + right, dx: -40mm, dy: 42mm)[
          #align(center)[
            #box(
              width: 50mm,
              height: 50mm,
              clip: true,
              radius: 50%,
            )[
              #image(
                master.icon,
                width: 50mm,
                height: 50mm,
                fit: "cover",
              )
            ]
            #v(6mm)
            #text(size: 22pt, fill: master.colors.main)[
              #author
            ]
            #if affiliation != none {
              v(-5mm)
              text(size: 15pt, fill: master.colors.main)[
                #affiliation
              ]
            }
          ]
        ]
        #place(top + left, dx: 30mm, dy: 145mm)[
          #text(size: 12pt, fill: master.colors.sub)[
            #date
          ]
        ]
      ],
    )
  }

  (
    theme: theme,
    master: master,
    styling: styling,
    drawBorder: drawBorder,
    slide: slide,
    description-slide: description-slide,
    dash-grid: dash-grid,
    toc-slide: toc-slide,
    chapter-slide: chapter-slide,
    title-slide: title-slide,
  )
}
