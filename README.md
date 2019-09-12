
<!-- README.Rmd generates README.md. -->

# `{homophily}`

<!-- badges: start -->

[![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![GitHub last
commit](https://img.shields.io/github/last-commit/knapply/homophily.svg)](https://github.com/knapply/homophily/commits/master)
[![Codecov test
coverage](https://codecov.io/gh/knapply/homophily/branch/master/graph/badge.svg)](https://codecov.io/gh/knapply/homophily?branch=master)
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

# Installation

``` r
# install.packages("remotes")
remotes::install_github("knapply/homophily")
```

# Usage

``` r
library(homophily)

ei_index(jemmah_islamiyah, node_attr_name = "role")
```

    #> [1] 0.3650794

``` r
ei_index(jemmah_islamiyah, node_attr_name = "role", scope = "group")
```

    #>             attribute external_ties internal_ties   ei_index
    #> 1          bomb maker             5            10 -0.3333333
    #> 2        command team            23             3  0.7692308
    #> 3 operation assistant            10             1  0.8181818
    #> 4      suicide bomber             5             0  1.0000000
    #> 5           Team Lima             0             6 -1.0000000

``` r
ei_index(jemmah_islamiyah, node_attr_name = "role", scope = "node")
```

    #>        node           attribute external_ties internal_ties   ei_index
    #> 1    MUKLAS        command team             7             2  0.5555556
    #> 2    AMROZI operation assistant             3             1  0.5000000
    #> 3     IMRON operation assistant             9             0  1.0000000
    #> 4   SAMUDRA        command team            13             2  0.7333333
    #> 5  DULMATIN          bomb maker             5             4  0.1111111
    #> 6     IDRIS        command team             8             2  0.6000000
    #> 7   MUBAROK operation assistant             2             1  0.3333333
    #> 8   AZAHARI          bomb maker             5             4  0.1111111
    #> 9     GHONI          bomb maker             5             4  0.1111111
    #> 10  ARNASAN      suicide bomber             5             0  1.0000000
    #> 11     RAUF           Team Lima             2             3 -0.2000000
    #> 12  OCTAVIA           Team Lima             2             3 -0.2000000
    #> 13  HIDAYAT           Team Lima             2             3 -0.2000000
    #> 14  JUNAEDI           Team Lima             2             3 -0.2000000
    #> 15    PATEK          bomb maker             5             4  0.1111111
    #> 16     FERI      suicide bomber             6             0  1.0000000
    #> 17   SARIJO          bomb maker             5             4  0.1111111
