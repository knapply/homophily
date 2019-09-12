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

as_mixing_matrix <- function(g, node_attr_name) {
  UseMethod("as_mixing_matrix")
}

as_mixing_matrix.igraph <- function(g, node_attr_name) {
  attr_el <- as_attr_el.igraph(g, node_attr_name)
  dim_names <- unique(sort(attr_el))
  
  table(factor(attr_el[, 1], levels = dim_names), 
        factor(attr_el[, 2], levels = dim_names))
}


as_mixing_matrix.network <- function(g, node_attr_name) {
  if (!requireNamespace("intergraph", quietly = TRUE)) {
    stop("{intergraph} is required to perform this operation on objects of 
         class 'network'.", call. = FALSE)
  }
  
  as_mixing_matrix.igraph(intergraph::asIgraph(g), node_attr_name)
}