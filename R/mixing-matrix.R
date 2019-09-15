#' Construct a graph object's mixing matrix.
#' 
#' Using a categorical vertex attribute, construct a matrix depicting network mixing
#' patterns.
#' 
#' @template param-g
#' @param row_attr Either the name of a node/vertex attribute or vector of same 
#' length as the number of nodes in `g`.
#' @param col_attr If not provided, the same as `row_attr`. Otherwise, a vector
#' of the same length as the number of nodes in `g`.
#' @template param-direction
#' 
#' @template author-bk
#' 
#' @examples 
#' as_mixing_matrix(jemmah_islamiyah, row_attr = "role")
#' 
#' data("sampson", package = "ergm")
#' as_mixing_matrix(samplike, row_attr = "vertex.names", col_attr = "group",
#'                  direction = "all")
#' as_mixing_matrix(samplike, row_attr = "vertex.names", col_attr = "group",
#'                  direction = "out")
#' as_mixing_matrix(samplike, row_attr = "vertex.names", col_attr = "group", 
#'                  direction = "in")
#' 
#' @importFrom Matrix diag t triu
#' @export
as_mixing_matrix <- function(g, row_attr, col_attr = NULL, 
                             direction = c("all", "out", "in")) {
  direction <- match.arg(direction, c("all", "out", "in"))
  if (.is_scalar_chr(row_attr)) {
    row_attr <- .get_node_attr(g, node_attr_name = row_attr)
  }
  if (is.null(col_attr)) {
    col_attr <- row_attr
  } else if (.is_scalar_chr(col_attr)) {
    col_attr <- .get_node_attr(g, node_attr_name = col_attr)
  }
  
  if (!is.atomic(row_attr) | length(row_attr) != .count_nodes(g)) {
    stop("`row_attr` is not the same length as the number of nodes in `g`.",
         call. = FALSE)
  }
  if (!is.atomic(row_attr) | length(col_attr) != .count_nodes(g)) {
    stop("`col_attr` is not the same length as the number of nodes in `g`.",
         call. = FALSE)
  }
  
  row_cats <- unique(row_attr)
  if (identical(row_attr, col_attr)) {
    col_cats <- row_cats
  } else {
    col_cats <- unique(col_attr)
  }
  
  el <- .as_edgelist(g)
  if (!.is_directed(g)) {
    el <- rbind(el, t(apply(el, 1L, rev)))
  } else if (!identical(row_attr, col_attr)) {
    el <- switch (direction,
      all = rbind(el, t(apply(el, 1L, rev))),
      out = el,
      `in` = t(apply(el, 1L, rev))
    )
  }

  out <- .as_contingency_table(
    factor(row_attr[el[, 1L]], levels = row_cats),
    factor(col_attr[el[, 2L]], levels = col_cats)
  )
  
  if (!.is_directed(g) & nrow(out) == ncol(out)) {
    out_diag <- diag(out)
    out[] <- out + t(out)
    diag(out) <- out_diag
    out <- triu(out)
  }
  
  out
}
