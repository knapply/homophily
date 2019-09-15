#' Newmans' Assortativity Coefficient
#' 
#' Given a categorical vertex attribute describing mutually exclusive groups, 
#' the assortativity coefficient represents the tendency for nodes to form ties
#' with similar alters.
#'
#' @template param-g
#' @template param-node_attr_name
#' @template param-dots
#' @param val1 Continuous vector.
#' @param val2 Continuous vector.
#' 
#' @details
#' \deqn{ r = \frac{ \sum_i{e_{ii} - \sum_i{a_ib_i}} } {1 - \sum_i{a_ib_i} } }
#' 
#' * \eqn{e}: mixing matrix
#' * \eqn{e_{ii}}: diagonal of mixing matrix
#' * \eqn{a_i}: row sums of mixing matrix
#' * \eqn{b_i}: column sums of mixing matrix
#' 
#' @references M. E. J. Newman, Mixing patterns in networks, Physical Review E, 
#' 67 026126, 2003. \url{https://arxiv.org/pdf/cond-mat/0209450.pdf}.
#' 
#' @template author-bk
#' 
#' @examples
#' data("faux.desert.high", package = "ergm")
#' assort_discrete(faux.desert.high, node_attr_name = "race")
#' 
#'
#' data("sampson", package = "ergm")
#' assort_discrete(samplike, "group")
#' 
#' @importFrom Matrix colSums diag forceSymmetric rowSums
#' 
#' @export
assort_discrete <- function(g, node_attr_name, ...) {
  .validate_node_attr(g, node_attr_name)
  
  mix_mat <- as_mixing_matrix(g, node_attr_name, ...)
  mix_mat <- 0.5 * (mix_mat + t(mix_mat))
 
  e_ij <- mix_mat / sum(mix_mat) 
  sigma.a_i.b_i <- sum(colSums(e_ij) * rowSums(e_ij))
  
  (sum(diag(e_ij)) - sigma.a_i.b_i) / (1 - sigma.a_i.b_i)
}

#' @rdname assort_discrete
#' 
#' @importFrom stats cor
#' 
#' @export
assort_scalar <- function(g, val1, val2 = NULL) {
  if (is.null(val2)) {
    val2 <- val1
  }
  
  el <- .as_edgelist(g)
  
  if (!.is_directed(g)) {
    val1 <- c(val1, val1)
    val2 <- c(val2, val2)
    el <- rbind(el, el[, c(2L, 1L)])
  }
  
  el[, 1L] <- val1[el[, 1L]]
  el[, 2L] <- val2[el[, 2L]]
  
  cor(el[, 1L], el[, 2L])
}

#' @rdname assort_discrete
#' 
#' @importFrom stats cor
#' 
#' @export
assort_degree <- function(g) {
  adj_mat <- .as_adj_mat(g)
  assort_scalar(g, rowSums(adj_mat), colSums(adj_mat))
}
