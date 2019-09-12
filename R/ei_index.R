#' Krackhardt's E-I Index
#' 
#' Given a categorical vertex attribute describing mutually exclusive groups, the E-I 
#' index represents a ratio of external to internal ties.
#' 
#' @param g 
#' * `<igraph>`
#'   + `<network>`, if `{intergraph}` is installed.
#' @param node_attr_name 
#' * `<chr>`
#' * The name of a node/vertex attribute in `g`.
#' @param scope
#' * `<chr>`
#' * The target scope of the resulting EI-Index
#'   + `"global"`, `"group"`, or `"node"`
#' 
#' @details
#' \deqn{E\mbox{-}I~Index = \frac{EL-IL}{EL+IL}}
#' 
#' @references Krackhardt, David, and Robert N. Stern. "Informal Networks and 
#' Organizational Crises: An Experimental Simulation." Social Psychology Quarterly 51, no.
#'  2 (1988): 123-40. \url{http://www.jstor.org/stable/2786835}.
#' 
#' @template author-bk
#' 
#' @examples
#' ei_index(jemmah_islamiyah, node_attr_name = "role")
#' 
#' ei_index(jemmah_islamiyah, node_attr_name = "role", scope = "group")
#' 
#' ei_index(jemmah_islamiyah, node_attr_name = "role", scope = "node")
#' 
#' @export
ei_index <- function(g, node_attr_name, scope = c("global", "group", "node")) {
  UseMethod("ei_index")
}

#' @rdname ei_index
#' @export
ei_index.network <- function(g, node_attr_name, 
                             scope = c("global", "group", "node")) {
  if (!requireNamespace("intergraph", quietly = TRUE)) {
    stop("{intergraph} is required to perform this operation on objects of 
         class 'network'.", call. = FALSE)
  }
  
  ei_index.igraph(intergraph::asIgraph(g), node_attr_name, scope)
}

#' @rdname ei_index
#' @export
ei_index.igraph <- function(g, node_attr_name, 
                            scope = c("global", "group", "node")) {
  scope <- match.arg(scope, c("global", "group", "node"))
  
  if (!node_attr_name %in% vertex_attr_names(g)) {
    stop("`", node_attr_name, "` is not the name a node attribute in `g`.",
         call. = FALSE)
  }
  
  if (is_multiplex(g)) {
    warning("`g` is multiplex.", call. = FALSE)
  }

  switch (scope,
    global = ei_global(g, node_attr_name),
    group = ei_group(g, node_attr_name),
    node = ei_node(g, node_attr_name),
    stop("not yet implemented", call. = FALSE)
  )
}

ei_global <- function(g, node_attr_name) {
  attr_el <- as_attr_el(g, node_attr_name)
  n_edges <- nrow(attr_el)
  
  E <- length(attr_el[, 1L][attr_el[, 1L] != attr_el[, 2L]])
  I <- n_edges - E
  
  (E - I) / n_edges
}

ei_group <- function(g, node_attr_name) {
  mix_mat <- as_mixing_matrix(g, node_attr_name)
  
  I <- diag(mix_mat)
  diag(mix_mat) <- NA
  E <- rowSums(mix_mat, na.rm = TRUE)
  EI <- (E - I) / (E + I)
  
  data.frame(
    attribute = rownames(mix_mat),
    external_ties = E,
    internal_ties = I,
    ei_index = EI,
    row.names = NULL,
    stringsAsFactors = FALSE
  )
}

ei_node <- function(g, node_attr_name) {
  UseMethod("ei_node")
}

ei_node.network <- function(g, node_attr_name) {
  if (!requireNamespace("intergraph", quietly = TRUE)) {
    stop("{intergraph} is required to perform this operation on objects of 
         class 'network'.", call. = FALSE)
  }
  ei_node.igraph(intergraph::asIgraph(g), node_attr_name)
}

#' @importFrom igraph as_adj_list vcount vertex_attr vertex_attr_names
ei_node.igraph <- function(g, node_attr_name) {
  attrs <- vertex_attr(g, name = node_attr_name)
  
  adj_list <- lapply(as_adj_list(g), function(x) {
    vertex_attr(g, name = node_attr_name, index = x)
  })
  
  node_ei_vals <- mapply(function(ego, alters) {
    n_edges <- length(alters)
    E <- length(alters[alters != ego])
    I <- n_edges - E
    EI <- (E - I) / n_edges
    
    data.frame(attribute = ego,
               external_ties = E,
               internal_ties = I,
               ei_index = EI,
               stringsAsFactors = FALSE,
               row.names = NULL, check.rows = FALSE, 
               check.names = FALSE, fix.empty.names = FALSE)
  }, 
  attrs, adj_list, SIMPLIFY = FALSE, USE.NAMES = FALSE)
  
  if ("name" %in% vertex_attr_names(g)) {
    node_names <- vertex_attr(g, name = "name")          # if standard {igraph}
  } else if ("vertex.names" %in% vertex_attr_names(g)) {
    node_names <- vertex_attr(g, name = "vertex.names")  # if from {network}
  } else {
    node_names <- seq_len(vcount(g))                     # if nameless
  }
  
  cbind(node = node_names, 
        do.call(rbind, node_ei_vals),
        stringsAsFactors = FALSE)
}
