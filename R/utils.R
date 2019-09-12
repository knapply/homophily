is_multiplex <- function(g) {
  UseMethod("is_multiplex")
}

is_multiplex.network <- function(g) {
  if (!requireNamespace("intergraph", quietly = TRUE)) {
    stop("{intergraph} is required to perform this operation on objects of 
         class 'network'.", call. = FALSE)
  }
  
  is_multiplex.igraph(intergraph::asIgraph(g))
}

#' @importFrom igraph any_multiple
is_multiplex.igraph <- function(g) {
  any_multiple(g)
}

as_attr_el <- function(g, node_attr_name) {
  UseMethod("as_attr_el")
}

#' @importFrom igraph as_edgelist vertex_attr
as_attr_el.igraph <- function(g, node_attr_name) {
  out <- as_edgelist(g, names = FALSE)
  out[] <- vertex_attr(g, name = node_attr_name)[out]
  
  out
}


as_attr_el.network <- function(g, node_attr_name) {
  if (!requireNamespace("intergraph", quietly = TRUE)) {
    stop("{intergraph} is required to perform this operation on objects of 
         class 'network'.", call. = FALSE)
  }
  
  as_attr_el.igraph(intergraph::asIgraph(g), node_attr_name)
}


#' Construct a graph object's mixing matrix.
#' 
#' Using a categorical vertex attribute, construct a matrix depicting network mixing
#' patterns.
#' 
#' @param g 
#' * `<igraph>`
#'   + `<network>`, if `{intergraph}` is installed.
#' @param node_attr_name 
#' * `<chr>`
#' * The name of a node/vertex attribute in `g`. 
#' 
#' @template author-bk
#' 
#' @examples 
#' as_mixing_matrix(jemmah_islamiyah, node_attr_name = "role")
#' 
#' @export
as_mixing_matrix <- function(g, node_attr_name) {
  UseMethod("as_mixing_matrix")
}

#' @rdname as_mixing_matrix
#' @export
as_mixing_matrix.igraph <- function(g, node_attr_name) {
  attr_el <- as_attr_el.igraph(g, node_attr_name)
  dim_names <- unique(sort(attr_el))
  
  out <- table(factor(attr_el[, 1], levels = dim_names), 
               factor(attr_el[, 2], levels = dim_names))
  class(out) <- "matrix"
  out
}

#' @rdname as_mixing_matrix
#' @export
as_mixing_matrix.network <- function(g, node_attr_name) {
  if (!requireNamespace("intergraph", quietly = TRUE)) {
    stop("{intergraph} is required to perform this operation on objects of 
         class 'network'.", call. = FALSE)
  }
  
  as_mixing_matrix.igraph(intergraph::asIgraph(g), node_attr_name)
}