# mappers ======================================================================
.map_int <- function(.x, .f, ...) {
  vapply(.x, .f, FUN.VALUE = integer(1L), ...)
}

.map_dbl <- function(.x, .f, ...) {
  vapply(.x, .f, FUN.VALUE = double(1L), ...)
}

.map_num <- function(.x, .f, ...) {
  vapply(.x, .f, FUN.VALUE = numeric(1L), ...)
}

.map_lgl <- function(.x, .f, ...) {
  vapply(.x, .f, FUN.VALUE = logical(1L), ...)
}

# default-ers ==================================================================
`%||%` <- function(lhs, rhs) {
  if (is.null(lhs)) rhs else lhs
}

# test-ers =====================================================================
.is_scalar_chr <- function(x) {
  length(x) == 1L && is.character(x)
}

# misc =========================================================================
#' @importFrom Matrix Matrix
.as_contingency_table <- function(f1, f2) {
  Matrix(table(f1, f2, deparse.level = 0L))
}

# node generics ================================================================
.node_attr_names <- function(g) {
  UseMethod(".node_attr_names")
}
#' @importFrom igraph vertex_attr_names
.node_attr_names.igraph <- function(g) {
  vertex_attr_names(graph = g)
}
#' @importFrom network list.vertex.attributes
.node_attr_names.network <- function(g) {
  list.vertex.attributes(x = g)
}


.node_attr_exists <- function(g, node_attr_name) {
  node_attr_name %in% .node_attr_names(g)
}


.validate_node_attr <- function(g, node_attr_name) {
  if (!.is_scalar_chr(node_attr_name)) {
    stop("`node_attr_name` must be a a scalar `character`.",
         call. = FALSE)
  }
  if (!.node_attr_exists(g, node_attr_name)) {
    stop('`"', node_attr_name, '"` isn\'t a node/vertex attribute in `g`.',
         call. = FALSE)
  }
}


.get_node_attr <- function(g, node_attr_name) {
  UseMethod(".get_node_attr")
}
#' @importFrom igraph vertex_attr
.get_node_attr.igraph <- function(g, node_attr_name) {
  .validate_node_attr(g, node_attr_name)
  
  vertex_attr(graph = g, name = node_attr_name)
}
#' @importFrom network get.vertex.attribute
.get_node_attr.network <- function(g, node_attr_name) {
  .validate_node_attr(g, node_attr_name)
  
  get.vertex.attribute(x = g, attrname = node_attr_name)
}

.get_node_names <- function(g) {
  UseMethod(".get_node_names")
}
#' @importFrom igraph vcount vertex_attr
.get_node_names.igraph <- function(g) {
  vertex_attr(g, "name") %||% seq_len(vcount(g))
}
#' @importFrom network get.vertex.attribute
.get_node_names.network <- function(g) {
  get.vertex.attribute(g, "vertex.names")
}

# graph generics ===============================================================
.is_multiplex <- function(g) {
  UseMethod(".is_multiplex")
}

.is_multiplex.network <- function(g) {
  if (!g[["gal"]][["multiple"]]) {
    return(FALSE)
  }
  el <- .as_edgelist.network(g)
  if (.is_directed.network(g)) {
    el <-  cbind(pmin.int(el[, 1L], el[, 2L]), 
                 pmax.int(el[, 1L], el[, 2L]))
  }
  any(duplicated.matrix(el))
}

#' @importFrom igraph any_multiple
.is_multiplex.igraph <- function(g) {
  any_multiple(g)
}


.count_nodes <- function(g) {
  UseMethod(".count_nodes")
}

#' @importFrom igraph vcount
.count_nodes.igraph <- function(g) {
  vcount(g)
}

.count_nodes.network <- function(g) {
  g[["gal"]][["n"]]
}


.as_edgelist <- function(g) {
  UseMethod(".as_edgelist")
}

#' @importFrom igraph as_edgelist
.as_edgelist.igraph <- function(g) {
  as_edgelist(g, names = FALSE)
}

.as_edgelist.network <- function(g) {
  out <- cbind(
    unlist(lapply(g[["mel"]], `[[`, "outl"), use.names = FALSE),
    unlist(lapply(g[["mel"]], `[[`, "inl"), use.names = FALSE)
  )
  if (!.is_directed.network(g)) {
    out[] <- t(apply(out, 1L, sort))
  }
  out
}


.is_directed <- function(g) {
  UseMethod(".is_directed")
}

#' @importFrom igraph is_directed
.is_directed.igraph <- function(g) {
  is_directed(g)
}

#' @importFrom network is.directed
.is_directed.network <- function(g) {
  is.directed(g)
}

