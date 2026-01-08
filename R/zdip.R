# Load null table
data(dip_null_table)


.mu_vec <- setNames(dip_null_table$mu_null,
                    as.character(dip_null_table$N))
.sigma_vec <- setNames(dip_null_table$sigma_null,
                       as.character(dip_null_table$N))
.max_N <- max(as.integer(names(.mu_vec)))

.compute_zdip_fast <- function(x, verbose = TRUE) {
  N <- length(x)
  d <- dip(x)
  
  if (N > .max_N) {
    
    if (verbose) {
      message(
        sprintf(
          "n = %d exceeds max N in null table (%d); using max N as asymptotic value.",
          N, .max_N
        )
      )
    }
    
    mu <- .mu_vec[[as.character(.max_N)]]
    sigma <- .sigma_vec[[as.character(.max_N)]]
    
  } else {
    mu <- .mu_vec[[as.character(N)]]
    sigma <- .sigma_vec[[as.character(N)]]
  }
  
  (d - mu) / sigma
}



.compute_zdip_downsampled <- function(x, N0 = 1000, nsim = 200, verbose = TRUE) {
  if (verbose && length(x) > .max_N) {
    message(
      sprintf(
        "n = %d exceeds max N in null table (%d); using max N as asymptotic value.",
        length(x), .max_N
      )
    )
  }
  mean(replicate(
    nsim,
    .compute_zdip_fast(sample(x, N0), verbose = FALSE)
  ))
}


#' Z-Dip statistic
#'
#' Z-normalized version of Hartigan's Dip statistic.
#'
#' @param x numeric vector
#' @param downsample logical; use downsampling for large samples
#' @param N0 subsample size (if downsample = TRUE)
#' @param nsim number of subsamples (if downsample = TRUE)
#' @param squash logical; apply squashing function 2 / (1 + exp(-.595 * z)) - 1, to bound z in [-1, +1]
#' @param verbose logical; print informational messages
#' @export
zdip <- function(x, downsample = FALSE, N0 = 1000, nsim = 200, squash = FALSE, verbose = TRUE) {
  x <- x[!is.na(x)]
  
  if (length(x) < 4) {
    stop("x must contain at least four observations")
  }
  
  z <- if (!downsample) {
    .compute_zdip_fast(x, verbose = verbose)
  } else {
    if (length(x) < N0) {
      stop("x must be at least N0 long for downsampling")
    }
    .compute_zdip_downsampled(x, N0, nsim, verbose = verbose)
  }
  
  if (squash) {
    if (verbose) {
      message("Applying squashing function. Significance threshold ≈ 0.5")
    }
    z <- 2 / (1 + exp(-.595 * z)) - 1
  } 
  z
}


