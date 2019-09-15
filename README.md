
<!-- README.Rmd generates README.md. -->

# `{homophily}`

<!-- badges: start -->

[![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![GitHub last
commit](https://img.shields.io/github/last-commit/knapply/homophily.svg)](https://github.com/knapply/homophily/commits/master)
<!-- [![Codecov test coverage](https://codecov.io/gh/knapply/homophily/branch/master/graph/badge.svg)](https://codecov.io/gh/knapply/homophily?branch=master) -->
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/knapply/homophily?branch=master&svg=true)](https://ci.appveyor.com/project/knapply/homophily)
[![Travis-CI Build
Status](https://travis-ci.org/knapply/homophily.svg?branch=master)](https://travis-ci.org/knapply/homophily)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Depends](https://img.shields.io/badge/Depends-GNU_R%3E=3.6-blue.svg)](https://www.r-project.org/)
[![GitHub code size in
bytes](https://img.shields.io/github/languages/code-size/knapply/homophily.svg)](https://github.com/knapply/homophily)
[![HitCount](http://hits.dwyl.io/knapply/homophily.svg)](http://hits.dwyl.io/knapply/homophily)
<!-- badges: end -->

<center>

<h4>

<i> They say that “birds of a feather flock together”… but let’s not
take their word for it. </i>

</h4>

</center>

<br>

Homophily refers to the tendency of actors to share positive ties with
other similar actors. The `{homophily}` package provides flexible,
generic routines to measure this phenomenon on objects of class
`<igraph>` or `<network>`.

# Installation

``` r
# install.packages("remotes")
remotes::install_github("knapply/homophily")
```

# Usage

``` r
library(homophily)
```

``` r
# undirected <igraph>
data("jemmah_islamiyah", package = "homophily")
# directed <network>
data("sampson", package = "ergm")
```

## Mixing Matrix

We can easily build classical mixing matrices for undirected and
directed graphs.

``` r
as_mixing_matrix(jemmah_islamiyah, row_attr = "role")
```

    #> 5 x 5 Matrix of class "dtrMatrix"
    #>                      
    #>                       command team operation assistant bomb maker suicide bomber Team Lima
    #>   command team                   6                  16         30              2         8
    #>   operation assistant            .                   2         10              2         0
    #>   bomb maker                     .                   .         20             10         0
    #>   suicide bomber                 .                   .          .              0         8
    #>   Team Lima                      .                   .          .              .        12

``` r
as_mixing_matrix(samplike, row_attr = "group")
```

    #> 3 x 3 Matrix of class "dgeMatrix"
    #>           
    #>            Turks Outcasts Loyal
    #>   Turks       30        1     5
    #>   Outcasts     7       10     1
    #>   Loyal        9        2    23

We can also build *generalized* mixing matrices to explore homophily
beyond the topographic level.

For example, if we want to explore ties between each individual node and
a group attribute, we can provide arguments to both `row_attr=` and
`col_attr=`.

``` r
as_mixing_matrix(samplike, row_attr = "vertex.names", col_attr = "group")
```

    #> 18 x 3 Matrix of class "dgeMatrix"
    #>              
    #>               Turks Outcasts Loyal
    #>   John Bosco      9        3     5
    #>   Gregory        11        3     1
    #>   Basil           3        5     0
    #>   Peter           0        0     9
    #>   Bonaventure     3        2     8
    #>   Berthold        1        0     5
    #>   Mark            8        2     1
    #>   Victor          4        0     7
    #>   Ambrose         2        0     6
    #>   Romauld         1        1     6
    #>   Louis           3        0     5
    #>   Winfrid        10        0     1
    #>   Amand           1        4     3
    #>   Hugh            8        0     3
    #>   Boniface        8        0     1
    #>   Albert          6        0     2
    #>   Elias           1        5     0
    #>   Simplicius      3        6     0

We can even explore homophily *across* group attributes.

``` r
as_mixing_matrix(samplike, row_attr = "cloisterville", col_attr = "group")
```

    #> 2 x 3 Matrix of class "dgeMatrix"
    #>        
    #>         Turks Outcasts Loyal
    #>   TRUE     34       15    24
    #>   FALSE    48       16    39

For directed graphs, the default behavior considers both outgoing and
inbound ties, but you can provide `"out"` or `"in"` to `direction=` as
desired.

``` r
as_mixing_matrix(samplike, row_attr = "cloisterville", col_attr = "group",
                 direction = "out")
```

    #> 2 x 3 Matrix of class "dgeMatrix"
    #>        
    #>         Turks Outcasts Loyal
    #>   TRUE     15        5    10
    #>   FALSE    31        8    19

``` r
as_mixing_matrix(samplike, row_attr = "cloisterville", col_attr = "group",
                 direction = "in")
```

    #> 2 x 3 Matrix of class "dgeMatrix"
    #>        
    #>         Turks Outcasts Loyal
    #>   TRUE     19       10    14
    #>   FALSE    17        8    20

## E-I Index

``` r
ei_index(jemmah_islamiyah, node_attr_name = "role")
```

    #> [1] 0.3650794

``` r
ei_index(jemmah_islamiyah, node_attr_name = "role", scope = "group")
```

    #>        command team operation assistant          bomb maker      suicide bomber           Team Lima 
    #>           0.8064516           0.7142857          -0.3333333           1.0000000          -1.0000000

``` r
ei_index(jemmah_islamiyah, node_attr_name = "role", scope = "node")
```

    #>     MUKLAS     AMROZI      IMRON    SAMUDRA   DULMATIN      IDRIS    MUBAROK    AZAHARI      GHONI 
    #>  0.5555556  0.5000000  1.0000000  0.7333333  0.1111111  0.6000000  0.3333333  0.1111111  0.1111111 
    #>    ARNASAN       RAUF    OCTAVIA    HIDAYAT    JUNAEDI      PATEK       FERI     SARIJO 
    #>  1.0000000 -0.2000000 -0.2000000 -0.2000000 -0.2000000  0.1111111  1.0000000  0.1111111

``` r
ei_index(samplike, node_attr_name = "group")
```

    #> [1] -0.4318182

``` r
ei_index(samplike, node_attr_name = "group", scope = "group")
```

    #>      Turks   Outcasts      Loyal 
    #> -0.6666667 -0.8181818 -1.0000000

``` r
ei_index(samplike, node_attr_name = "group", scope = "node")
```

    #>  John Bosco     Gregory       Basil       Peter Bonaventure    Berthold        Mark      Victor 
    #> -0.05882353 -0.46666667 -0.25000000 -1.00000000 -0.23076923 -0.66666667 -0.45454545 -0.27272727 
    #>     Ambrose     Romauld       Louis     Winfrid       Amand        Hugh    Boniface      Albert 
    #> -0.50000000 -0.50000000 -0.25000000 -0.81818182  0.00000000 -0.45454545 -0.77777778 -0.50000000 
    #>       Elias  Simplicius 
    #> -0.66666667 -0.33333333

## Assortativity

``` r
assortativity_attr(jemmah_islamiyah, node_attr_name = "role")
```

    #> [1] 0.09078704

``` r
assortativity_attr(samplike, node_attr_name = "group")
```

    #> [1] 0.5445606

# Cite

``` r
citation("homophily")
```

    #> 
    #> To cite homophily use:
    #> 
    #>   Knapp, B. G. (2019). homophily: Measuring Network Homophily Data. R package version
    #>   0.0.0.9 Retrieved from https://knapply.github.io/homophily
    #> 
    #> A BibTeX entry for LaTeX users is
    #> 
    #>   @Manual{homophily-package,
    #>     title = {homophily: Measuring Network Homophily},
    #>     author = {Brendan Knapp},
    #>     year = {2019},
    #>     note = {R package version 0.0.0.9},
    #>     url = {https://knapply.github.io/homophily},
    #>   }

# `R CMD Check`

``` r
devtools::check(quiet = TRUE)
```

    #> Writing NAMESPACE
    #> Writing NAMESPACE

    #> -- R CMD check results --------------------------------------------------- homophily 0.0.0.9000 ----
    #> Duration: 35.4s
    #> 
    #> 0 errors v | 0 warnings v | 0 notes v
