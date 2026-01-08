# zdip

Z-Dip is a generalized and validated version of Hartigan’s Dip statistic for
quantifying multimodality as a standardized effect size. It comprises one function:

```r
zdip(x, downsample = FALSE, N0 = 1000, nsim = 200, squash = FALSE, verbose = TRUE)
```

that supports optional downsampling and squashing.

For more information check the paper: (to be updated soon!)

The precomputed null table of values can be loaded explicitly via:

```r
load_zdip_null(name = "dip_null_table")
```

## Installation

```r
remotes::install_github("EdoardoDima/zdip")
```
