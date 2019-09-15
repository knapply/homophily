#' Construct a graph object's mixing matrix.
#' 
#' Using a categorical vertex attribute, construct a matrix depicting network mixing
#' patterns.
#' 
#' @template param-g
#' @param dim1 Either the name of a node/vertex attribute or vector of same 
#' length as the number of nodes in `g`.
#' @param dim2 If not provided, the same as `dim1`. Otherwise, a vector
#' of the same length as the number of nodes in `g`.
#' @template param-direction
#' 
#' @details 
#' * If `g` is undirected, `dim1` corresponds to the rows of the returned 
#' mixing matrix and `dim2` corresponds to the columns.
#'   + If `dim1` and `dim2` refer to the same dimension/attribute, only the
#'   upper triangle of the returned mixing matrix is used.
#' * If `g` is directed, the rows of the returned mixing matrix correspond
#' to the source of ties while the columns correspond to the target of ties.
#' 
#' @return 
#' * `<dtrMatrix>`
#'   + `g` is undirected and `dim1` and `dim2` refer to same dimension.
#' * `<dgeMatrix>`
#'   + `g` is directed or `dim1` and `dim2` refer to different dimensions.
#' * `<ddiMatrix>`
#'   + `g` exhibits 100% homophily.
#' 
#' @template author-bk
#' 
#' @examples 
#' as_mixing_matrix(jemmah_islamiyah, dim1 = "role")
#' as_mixing_matrix(jemmah_islamiyah, dim1 = "name", dim2 = "role")
#' 
#' data("sampson", package = "ergm")
#' as_mixing_matrix(samplike, dim1 = "vertex.names", dim2 = "group",
#'                  direction = "all")
#' as_mixing_matrix(samplike, dim1 = "vertex.names", dim2 = "group",
#'                  direction = "out")
#' as_mixing_matrix(samplike, dim1 = "vertex.names", dim2 = "group", 
#'                  direction = "in")
#' 
#' @importFrom Matrix diag t triu
#' @export
as_mixing_matrix <- function(g, dim1, dim2 = NULL, 
                             direction = c("all", "out", "in")) {
  direction <- match.arg(direction, c("all", "out", "in"))

  if (.is_scalar_chr(dim1)) {
    dim1 <- .get_node_attr(g, node_attr_name = dim1)
  }
  if (is.null(dim2)) {
    dim2 <- dim1
  } else if (.is_scalar_chr(dim2)) {
    dim2 <- .get_node_attr(g, node_attr_name = dim2)
  }
  
  if (!is.atomic(dim1) | length(dim1) != .count_nodes(g)) {
    stop("`dim1` is not the same length as the number of nodes in `g`.",
         call. = FALSE)
  }
  if (!is.atomic(dim1) | length(dim2) != .count_nodes(g)) {
    stop("`dim2` is not the same length as the number of nodes in `g`.",
         call. = FALSE)
  }
  
  row_cats <- unique(dim1)
  if (identical(dim1, dim2)) {
    col_cats <- row_cats
  } else {
    col_cats <- unique(dim2)
  }
  
  el <- .as_edgelist(g)
  if (!.is_directed(g)) {
    el <- rbind(el, t(apply(el, 1L, rev)))
  } else if (!identical(dim1, dim2)) {
    el <- switch (direction,
      all = rbind(el, t(apply(el, 1L, rev))),
      out = el,
      `in` = t(apply(el, 1L, rev))
    )
  }

  out <- .as_contingency_table(
    factor(dim1[el[, 1L]], levels = row_cats),
    factor(dim2[el[, 2L]], levels = col_cats)
  )
  
  if (!.is_directed(g) & nrow(out) == ncol(out)) {
    out_diag <- diag(out)
    out[] <- out + t(out)
    diag(out) <- out_diag
    out <- triu(out)
  }
  
  if (.is_directed(g) && direction == "in") {
    out <- t(out)
  }

  out
}
