// This function gets your whole document as its `body` and formats
// it as an article in the style of a Poster.
#let poster(

  // Very crude placeholder: the fill height of the header background
  headerFillHeight: 10em,

  // The poster's width
  width: 48in,

  // The poster's height
  height: 36in,

  // (l)eft, (r)ight, (b)ottom, (t)op margins
  lmargin: 1cm,
  rmargin: 1cm,
  tmargin: 1cm,
  bmargin: 1cm,

  // The poster's title.
  title: "Poster Title",

  // An array of author names, or an array of arrays, each sub-array
  // containing an author's name and the numbers for their affiliation
  authors: (("Author One", 1), ("Author Two", 1, 2)),
  // authors: ("¹Author One", "²Author Two"),

  // Separator string for authors
  authorsSep: ", ",

  // Gap between title and authors
  titleAuthorsGap: 0em,

  // Affiliations
  affiliations: ("Affil1", "Affil2",),

  // the left and right area of the title/authors
  leftHeader: none,
  rightHeader: none,

  // Footer text.
  // For instance, Name of Conference, Date, Location.
  // or Course Name, Date, Instructor.
  footerText: "Footer Text",

  // Email IDs of the authors.
  // footerEmailIds: "Email IDs (separated by commas)",

  // Color of heading lines
  headingLineColor:  "#000000",

  // Color of heading text
  headingTextColor: "#000000",

  // Width of heading lines
  headingLineThickness: 2pt,

  // Lenth of heading lines
  headingLineLength: 100%,

  // Background color of the header
  headerFillColor: none,

  // Vertical padding at the bottom of the header
  // before drawing a horizontal line
  headerBottomPad: 0em,

  // Thickness of the line at the bottom of the header.
  // This will default to 2*headingLineThickness. Can be set to
  // 0pt, 0in, etc. to disable
  headerLineThickness: none,

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

  // spacing between columns
  columnGutter: 64pt,

  // Body font and size
  bodyFont: "Gotham",
  bodyFontSize: 36pt,

  // Title and authors' column size .
  titleColumnSize: 20in,

  // Poster title's font size .
  titleFontSize: 48pt,

  // Poster title's font color .
  titleFontColor: black,

  // Poster title's font weight
  titleFontWeight: 800,

  // Authors' font size .
  authorsFontSize: 36pt,

  // Authors' font color
  authorsFontColor: black,

  // Authors' font weight
  authorsFontWeight: 200,

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
  numColumns = int(numColumns)
  let headerLineThickness = if headerLineThickness == none { 2*headingLineThickness } else { headerLineThickness }

  let hs1 = if heading1Size == none { bodyFontSize * heading1Scale } else { heading1Size }
  let hs2 = if heading2Size == none { bodyFontSize * heading2Scale } else { heading2Size }
  let hs3 = if heading3Size == none { bodyFontSize * heading3Scale } else { heading3Size }

  // Configure the page.
  // This poster defaults to 36in x 24in.
  set page(
    width: width,
    height: height,
    margin: (top: tmargin, left: lmargin, right: rmargin, bottom: bmargin),
    footer: if footerText == none or footerText == "" { none } else [
      #set align(center)
      #set text(size: footerTextFontSize)
      #block(
        fill: footerColor,
        width: 100%,
        inset: 20pt,
        radius: 10pt,
        [
          #text(smallcaps(footerText))
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
  let leftLogosAreEmpty  = leftHeader  == none
  let rightLogosAreEmpty = rightHeader == none
  let headerColumns = if leftLogosAreEmpty and rightLogosAreEmpty { (0pt, 1fr, 0pt) }
  else if leftLogosAreEmpty  { (0pt, 1fr, auto) }
  else if rightLogosAreEmpty { (auto, 1fr, 0fr) }
  else                       { (auto, auto, auto) }

  // Title cell:
  // TITLE, AUTHORS, AFFILIATIONS
  let titleCell = {
    // Build the authorslist with superscripted affiliations if present
    let authorsList = ()
    for (i, elem) in authors.enumerate() {
      let name   = if type(elem) == array { elem.at(0) }                     else { elem }
      let supers = if type(elem) == array and elem.len() > 1 {
        let string = none
        for j in range(1, elem.len()) {
          let t = super(str(elem.at(j)))
          string = if string == none { t } else { string + super(",") + t }
        }
        string
      } else { none }
      let sep = if i < authors.len() - 1 {text(authorsSep)} else { none }
      let authorAndAffil = name + supers + sep
      authorsList += (authorAndAffil,)
    }
    let authorBlock = for (i, elem) in authorsList.enumerate() { box(elem) } // box to avoid newline in names
    // Add title and author block to the whole thing
    let members = (
      text(fill: titleFontColor, titleFontSize, weight: titleFontWeight,  title + "\n\n"),  // TITLE
      v(titleAuthorsGap), // SPACING
      text(fill: authorsFontColor, authorsFontSize, weight: authorsFontWeight, authorBlock), // AUTHORS
    )
    // Add the affiliations of the authors below
    if affiliations != () {
      let acc = none
      for (i, aff) in affiliations.enumerate() {
        let authorAndAffil = super(str(i + 1)) + h(8pt) + aff
        acc = if acc == none { authorAndAffil } else { acc + text("; ") + authorAndAffil }
      }
      members += (v(authorAffiliationGap),) // SPACING
      members += (text(fill: authorsFontColor, weight: authorsFontWeight, affiliationsFontSize, acc),) // AFFILIATIONS
    }
    // render them
    grid(columns: 1, ..members)
  }

  // Configure headings
  set heading(numbering: none)
  // headings
  show heading: it => {
    let lvl = it.level
    // =
    if lvl == 1 {
      set align(center)
      set text(size: hs1, weight: 400, fill: headingTextColor)
      smallcaps(it.body)
      v(-hs1)
      line(
        length: headingLineLength,
        stroke: (
          paint: headingLineColor,
          thickness: headingLineThickness,
          cap: "round"
        )
      )
    // ==
    } else if lvl == 2 {
      set text(style: "italic", size: hs2, weight: "regular")
      v(10pt, weak: true)
      underline(it.body)
      v(10pt, weak: true)
    // ===
    } else if lvl == 3 {
      set text(style: "italic", size: hs3, weight: "regular")
      it.body
    // ====[=[..]]
    } else if lvl > 3 {
      set text(style: "italic", size: bodyFontSize, weight: "regular")
      it.body
    }
  }

  // Wrapping grid of logos
  let headercontent= align(center,
    grid(
      rows: 1,
      columns: headerColumns,
      column-gutter: 0pt,
      row-gutter: 50pt,
      // left
      leftHeader,
      // Title
      titleCell,
      // right
      rightHeader,
    )
  )
  place(top + left)[
    #move(dx: -lmargin, dy: -tmargin)[
      #box(width:100%+lmargin+rmargin, height: headerFillHeight, fill: headerFillColor)
    ]
  ]
  headercontent
  v(headerBottomPad)
  move(dx: -10%)[
    #line(
      length: 120%,
      stroke: (
        paint: headingLineColor,
        thickness: headerLineThickness,
        cap: "round",
      )
    )
  ]

  // Start three column mode and configure paragraph properties.
  show: columns.with(numColumns, gutter: columnGutter)
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
