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
#' @importFrom Matrix diag t triu
#' @export
as_mixing_matrix <- function(g, row_attr, col_attr = row_attr, 
                             direction = c("all", "out", "in")) {
  direction <- match.arg(direction, c("all", "out", "in"))
  if (.is_scalar_chr(row_attr)) {
    row_attr <- .get_node_attr(g, node_attr_name = row_attr)
    col_attr <- row_attr
  }
  
  if (length(row_attr) != .count_nodes(g)) {
    stop("`row_attr` is not the same length as the number of nodes in `g`.",
         call. = FALSE)
  }
  if (length(col_attr) != .count_nodes(g)) {
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
  if (.is_directed(g)) {
    el <- switch (direction,
      all = rbind(el, t(apply(el, 1L, rev))),
      out = el,
      `in` = t(apply(el, 1L, rev)),
      
      stop('`direction` must be "all", "out", or "in".', call. = FALSE)
    )
  } else {
    el <- rbind(el, t(apply(el, 1L, rev)))
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







# assortativity_coeff <- function(g) {
#   vertex_attr(g, "degree") <- degree(g)
#   
#   as_mixing_matrix(g, "role")
#   
#   mix_mat <- as_mi
#   
#   adj_mat <- as_adjacency_matrix(g)
#   deg <- degree(g)
#   
#   deg_mix_mat <- adj_mat * t(replicate(nrow(adj_mat), deg))
#   
#   deg_mix_mat
#   
#   
#   deg_mix_mat <- matrix(0, nrow = nrow(adj_mat), ncol = ncol(adj_mat))
#   apply(adj_mat, 1L, function(x) deg)
#   
#   do.call(replicate(nrow(adj_mat), t(deg), simplify = FALSE),
#           cbind)
#   
#   replicate(nrow(adj_mat), deg, simplify = FALSE)
#   
#   apply(adj_mat, 2L, function(x) {
#     no_edge <- x == 0L
#     temp_deg <- deg
#     temp_deg[no_edge] <- 0L
#     temp_deg
#   })
#   
#   
#   
#   
#   
#   deg <- degree(g) - 1
#   el <- as_edgelist(g, names = FALSE)
#   el[] <- deg[el]
#   
#   
#   cor(el[, 1L], el[, 2L])
#   
#   cor(c(deg[[1]], deg[adj_mat[1, ] == 1]))
#   
#   
#   apply(adj_mat, 1L, cor())
#   
#   ad
#   
#   el[] <- deg[el]
#   
#   cor(el[, 1L], el[, 2L])
#   
#   
# }














