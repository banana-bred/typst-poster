// This function gets your whole document as its `body` and formats
// it as an article in the style of a Poster.
#let poster(

  // The poster's width
  width: 48in,

  // The poster's height
  height: 36in,

  // The poster's title.
  title: "Poster Title",

  // A string of author names.
  authors: "¹Author One, ²Author Two",

  // Affiliations
  affiliations: ("Affil1", "Affil2",),

  // filepaths for logos to the left/right of the authors
  leftLogos: (),      // filepaths
  rightLogos: (),     // filepaths

  // number of columns for logos to the left/right of the authos
  leftLogoCols: 2,    // # columns
  rightLogoCols: 2,   // # columns

  // arrays of scaling for each logo to the left/right of the authors (%)
  // This will override the default value given by logoScale, which applies
  // to all logos
  leftLogoScales: (),
  rightLogoScales: (),

  // The alignment of the logos
  leftLogoAlign:  center,
  rightLogoAlign: center,

  // vertical scpacing between logo rows
  logoRowVgap: 8pt,

  // horizontal spacing between logos in a row
  logoGap: 12pt,

  // Default logo scale for all logos (%, overridden by left/rightLogoScales)
  logoScale: "100",

  // Base width for logos
  logoBaseWidth: 12in,


  // Footer text.
  // For instance, Name of Conference, Date, Location.
  // or Course Name, Date, Instructor.
  footerText: "Footer Text",

  // Email IDs of the authors.
  // footerEmailIds: "Email IDs (separated by commas)",

  // Color of header lines
  headerLineColor:  "#000000",

  // Width of header lines
  headerLineThickness: 2pt,

  // Lenth of the header line
  headerLineLength: 100%,

  // Color of the footer.
  footerColor: "#000000",

  // DEFAULTS
  // ========
  // For 3-column posters, these are generally good defaults.
  // Tested on 36in x 24in, 48in x 36in, and 36in x 48in posters.
  // For 2-column posters, you may need to tweak these values.
  // See ./examples/example_2Column_18_24.typ for an example.

  // Any keywords or index terms that you want to highlight at the beginning.
  keywords: (),
  keywordsFontSize: 24pt,

  // Number of columns in the poster.
  numColumns: "3",

  // Body font and size
  bodyFont: "Consolas",
  bodyFontSize: 36pt,

  // University logo's column size .
  logoColumnSize: 10in,

  // Title and authors' column size .
  titleColumnSize: 20in,

  // Poster title's font size .
  titleFontSize: 48pt,

  // Authors' font size .
  authorsFontSize: 36pt,

  // [ sub [sub] ] heading size
  heading1Size: none,
  heading2Size: none,
  heading3Size: none,

  // scaling of [sub [sub]] headers relative to body font size (overridden by heading{1,2,3}Size if supplied)
  heading1Scale: 1.6,
  heading2Scale: 1.15,
  heading3Scale: 1,

  // Gap between authors and affiliations
  authorAffiliationGap: 12pt,

  // Author affiliation font size
  affiliationsFontSize: 30pt,

  // Footer's text font size .
  footerTextFontSize: 40pt,


  // The poster's content.
  body
) = {
  // Parse certain options in the proper format
  set text(font: bodyFont, size: bodyFontSize)
  logoScale          = int(logoScale) * 1%
  leftLogoCols       = int(leftLogoCols)
  rightLogoCols      = int(rightLogoCols)
  numColumns         = int(numColumns)

  let hs1 = if heading1Size == none { bodyFontSize * heading1Scale } else { heading1Size }
  let hs2 = if heading2Size == none { bodyFontSize * heading2Scale } else {heading2Size}
  let hs3 = if heading3Size == none { bodyFontSize * heading3Scale } else {heading3Size}

  // Configure the page.
  // This poster defaults to 36in x 24in.
  set page(
    width: width,
    height: height,
    margin:
      (top: 1in, left: 2in, right: 2in, bottom: 2in),
    footer: [
      #set align(center)
      #set text(32pt)
      #block(
        fill: footerColor,
        width: 100%,
        inset: 20pt,
        radius: 10pt,
        [
          #text(size: footerTextFontSize, smallcaps(footerText))
        ]
      )
    ]
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  // show math.equation: set block(spacing: 0.65em)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Determine number of header columns based on the presence of left/right logos
  let leftLogosAreEmpty  = leftLogos == ()
  let rightLogosAreEmpty = rightLogos == ()
  let headerColumns = if leftLogosAreEmpty and rightLogosAreEmpty { (0pt, 1fr, 0pt) }
  else if leftLogosAreEmpty  { (0pt, 1fr, auto) }
  else if rightLogosAreEmpty { (auto, 1fr, 0fr) }
  else                       { (auto, titleColumnSize, auto) }

  // Title cell
  let titleCell = {
    // TITLE, AUTHORS, AFFILIATIONS
    let members = (
      text(titleFontSize, title + "\n\n"),  // TITLE
      text(authorsFontSize, emph(authors)), // AUTHORS
    )
    // AFFILIATIONS
    if affiliations != () {
      let acc = none
      for (i, aff) in affiliations.enumerate() {
        let piece = super(str(i + 1)) + h(8pt) + aff
        acc = if acc == none { piece } else { acc + text("; ") + piece }
      }
      // some spacing
      members += (v(authorAffiliationGap),)
      members += (text(affiliationsFontSize, acc),)
    }
    // render them
    grid(columns: 1, ..members)
  }

  // Configure headings
  set heading(numbering: none)
  // headings
  show heading: it => {
    let lvl = it.level
    if lvl == 1 {
      set align(center)
      set text(size: hs1, weight: 400)
      smallcaps(it.body)
      v(-hs1)
      line(
        length: headerLineLength,
        stroke: (
          paint: headerLineColor,
          thickness: headerLineThickness,
          cap: "round"
        )
      )
    } else if lvl == 2 {
      set text(size: hs2)
      v(10pt, weak: true)
      it.body
      v(10pt, weak: true)
    } else if lvl == 3 {
      set text(style: "italic", size: hs3)
      it.body
    } else if lvl > 3 {
      set text(style: "italic", size: bodyFintSize)
      it.body
    }
  }

  // Wrapping grid of logos
  let logoRow = (logos, side, ncols, scales) => {
    if logos == () { none } else {
      // if we get a single string, append a comma to enforce list
      let seq = if type(logos) == str { (logos,) } else { logos }
      let kids = ()
      for i in range(0, seq.len()) {
        let item = seq.at(i)
        let path = if type(item) == array { item.at(0)  } else { item }
        // let wid  = if type(item) == array and item.len() >= 2 { item.at(1) }
        //   else if scales != () and i < scales.len() {
        //     let scale = scales.at(i)
        //     if type(scale) == int { scale * 1%  } else { scale } // int → percent
        //   } else { logoScale }
        let wid = if type(item) == array and item.len() >= 2 {
          item.at(1)
        } else if scales != () and i < scales.len() {
          let scale = scales.at(i)
          if      type(scale) == int    { (scale*1%) * logoBaseWidth }
          else if type(scale) == ratio  { scale      * logoBaseWidth }
          else if type(scale) == length { scale }
          else                          { logoScale  * logoBaseWidth }
        } else {
          logoScale * logoBaseWidth
        }
        // kids += (image(path, width: wid),)
        kids += (align(
          if side == "left" { leftLogoAlign } else { rightLogoAlign },
          image(path, width: wid)
        ),)
        // kids += (grid(
        //   columns: 1,
        //   rows: (1fr, auto, 1fr),
        //   v(1pt),
        //   align(center, image(path, width: wid)),
        //   v(1pt)
        // ),)
      }
      // align the logos within their left/right logo column
      align(
        if side == "left" { leftLogoAlign }
        else if side == "right" { rightLogoAlign }
        else { none },
        box(
          grid(
            columns: ncols,
            column-gutter: logoGap,   // hgap between logos
            row-gutter: logoRowVgap,  // vgap b/w rows
            align: center,
            ..kids                    // spread children into grid
          )
      )
      )
    }
  }
  align(center,
    grid(
      rows: 1,
      // columns: (1fr, titleColumnSize, 1fr),
      columns: headerColumns,
      // columns: (logoColumnSize, titleColumnSize, logoColumnSize),
      column-gutter: 0pt,
      row-gutter: 50pt,
      // left logos
      logoRow(leftLogos, "left", leftLogoCols, leftLogoScales),
      // Title
      titleCell,
      // right logos
      logoRow(rightLogos, "right", rightLogoCols, rightLogoScales)
    )
  )

  // Start three column mode and configure paragraph properties.
  show: columns.with(numColumns, gutter: 64pt)
  set par(justify: true, first-line-indent: 0em)
  // show par: set block(spacing: 0.65em)

  // Display the keywords.
  if keywords != () [
      #set text(keywordsFontSize, weight: 400)
      #show "Keywords": smallcaps
      *Keywords* --- #keywords.join(", ")
  ]

  // Display the poster's contents.
  body
}
