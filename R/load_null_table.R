#' Load Z-Dip null table into the global environment if one so chooses
#'
#' Loads the precomputed null moments used by Z-Dip into the user's
#' global environment as `dip_null_table`.
#'
#' @return Invisibly returns the null table.
#' @param name Name to assign to the table in the user's environment
#' @export
load_zdip_null <- function(name = "dip_null_table") {
  data("dip_null_table", package = "zdip", envir = .GlobalEnv)
  if (name != "dip_null_table") {
    assign(name,
           get("dip_null_table", envir = .GlobalEnv),
           envir = .GlobalEnv)
    rm("dip_null_table", envir = .GlobalEnv)
  }
  invisible(get(name, envir = .GlobalEnv))
}
