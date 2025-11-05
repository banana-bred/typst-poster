#import "poster.typ": *
#let color1=rgb("#C2CCF9")
#let color2=rgb("#E85B3A")
#show: poster.with(
  width: 36in,
  height: 24in,
  title: lorem(8),
  authors: (
    ("A. Smith", 1, 2),
    "B. Jones",
    ("C. Brown", 3),
    ("D. Miller", 1),
  ),
  affiliations: ("Affil1", "Affil2", "Affil3"),
  leftHeader: [
    #set align(left)
    #move(dx:-3em)[#grid(
      columns: (12em, 12em),
      column-gutter: 4em,
      align: center + horizon,
      image( "./images/deer1.jpg", height: 8em),
      image( "./images/deer2.jpg", height: 8em),
    )
  ]],
  rightHeader: [
    #set align(center + horizon)
    #grid(columns: (8em), align: center+horizon, column-gutter: 4em)[
      #move(dx:3em)[#rotate(-90deg, image("./images/raccoon.jpg", height: 8em))]
  ]],
  footerText: "Conference on Typesetting Systems, 2000",
  footerTextFontSize: 22pt,
  footerColor: color1,
  keywords: ("Typesetting", "Scientific Writing", "Typst"),
  titleAuthorsGap: -18pt,
  authorAffiliationGap: 38pt,
  bodyFontSize: 24pt,
  bmargin: 1cm,
  headerFillColor: color1,
  headingLineColor: color2,
  headerFillHeight: 10.5em,
)

= #lorem(3)
#lorem(60)
#figure(
  image("images/Monet.cliffWalkAtPourville.jpg",
        width: 50%),
  caption: [#lorem(10)]
)

+ #lorem(10)
+ #lorem(10)
+ #lorem(10)


= #lorem(2)
#lorem(30)


#lorem(50)

#colbreak()

#set align(center)
#table(
  columns:(auto, auto, auto),
  inset:(10pt),
 [#lorem(4)], [#lorem(2)], [#lorem(2)],
 [#lorem(3)], [#lorem(2)], [$alpha$],
 [#lorem(2)], [#lorem(1)], [$beta$],
 [#lorem(1)], [#lorem(1)], [$gamma$],
 [#lorem(2)], [#lorem(3)], [$theta$],
)

#set align(left)
== #lorem(5)
#lorem(80)
$ mat(
  1, 2, ..., 8, 9, 10;
  2, 2, ..., 8, 9, 10;
  dots.v, dots.v, dots.down, dots.v, dots.v, dots.v;
  10, 10, ..., 10, 10, 10;
) $


= #lorem(3)

#block(
  fill: luma(230),
  inset: 8pt,
  radius: 4pt,
  [
    #lorem(110),
    - #lorem(10),
    - #lorem(10),
    - #lorem(10),
  ]
)

#colbreak()

#lorem(75)
```Fortran
pure elemental module function factorial(i) result(res)
  use, intrinsic :: iso_fortran_env, only: dp => real64
  implicit none
  integer, intent(in) :: i
  real(dp) :: res
  res = gamma(real(i+1, kind = dp))
end function factorial
```

= #lorem(5)
#lorem(130)
- #lorem(10)
  - #lorem(5)
  - #lorem(8)
- #lorem(15)
  - #lorem(9)
  - #lorem(7)

$ sum_(k=1)^n k = (n(n+1)) / 2 = (n^2 + n) / 2 $
