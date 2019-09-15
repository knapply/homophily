#' Krackhardt's E-I Index
#' 
#' Given a categorical vertex attribute describing mutually exclusive groups, the E-I 
#' index represents a ratio of external to internal ties.
#'
#' @template param-g
#' @template param-node_attr_name
#' @param scope `<chr>` The target scope of the resulting EI-Index
#' * `"global"`, `"group"`, or `"node"`
#' @template param-dots 
#' 
#' @details
#' \deqn{E\mbox{-}I~Index = \frac{EL-IL}{EL+IL}}
#' * \eqn{EL}: external ties
#' * \eqn{IL}: internal ties
#' 
#' @references Krackhardt, David, and Robert N. Stern. "Informal Networks and 
#' Organizational Crises: An Experimental Simulation." Social Psychology Quarterly 51, no.
#'  2 (1988): 123-40. \url{http://www.jstor.org/stable/2786835}.
#' 
#' @template author-bk
#' 
#' @examples
#' # <igraph>
#' ei_index(jemmah_islamiyah, node_attr_name = "role")
#' ei_index(jemmah_islamiyah, node_attr_name = "role", scope = "group")
#' ei_index(jemmah_islamiyah, node_attr_name = "role", scope = "node")
#' 
#' # <network>
#' data("sampson", package = "ergm")
#' ei_index(samplike, node_attr_name = "group")
#' ei_index(samplike, node_attr_name = "group", scope = "group")
#' ei_index(samplike, node_attr_name = "group", scope = "node")
#' 
#' @export
ei_index <- function(g, node_attr_name, scope = c("global", "group", "node"), 
                     ...) {
  scope <- match.arg(scope, c("global", "group", "node"))
  
  .validate_node_attr(g, node_attr_name)

  if (.is_multiplex(g)) {
    warning("`g` is multiplex.", call. = FALSE)
  }

  switch (scope,
    global = .ei_global(g, node_attr_name, ...),
    group = .ei_group(g, node_attr_name, ...),
    node = .ei_node(g, node_attr_name, ...),

    stop("not yet implemented", call. = FALSE)
  )
}
#' @importFrom Matrix diag
.ei_global <- function(g, node_attr_name, ...) {
  mix_mat <- as_mixing_matrix(g, row_attr = node_attr_name, ...)
  
  I <- sum(diag(mix_mat))
  diag(mix_mat) <- 0
  E <- sum(mix_mat)
  
  (E - I) / (E + I)
}

#' @importFrom Matrix diag rowSums triu
.ei_group <- function(g, node_attr_name, ...) {
  mix_mat <- as_mixing_matrix(g, node_attr_name, ...)
  
  I <- diag(mix_mat)
  E <- rowSums(triu(mix_mat, k = 1L))
  
  (E - I) / (E + I)
}

#' @importFrom Matrix rowSums
.ei_node <- function(g, node_attr_name, ...) {
  node_attrs <- .get_node_attr(g, node_attr_name)
  node_names <- .get_node_names(g)
  
  attr_mat <- table(
    factor(node_names, levels = node_names),
    factor(node_attrs, levels = unique(node_attrs))
  )
  
  mix_mat <- as_mixing_matrix(g, row_attr = node_names, col_attr = node_attrs,
                              ...)
  
  I <- rowSums(mix_mat * attr_mat)
  E <- rowSums(mix_mat) - I
  
  (E - I) / (E + I)
}
