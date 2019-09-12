# article: inst/articles/Koschade-Stuart-A-Social-Network-Analysis-of-Jemaah-Islamiyah.pdf

pasted_table_to_adj_mat <- function(.x) {
  init <- strsplit(
    unlist(strsplit(.x, "\n"), use.names = FALSE), 
    "\t"
  )
  dim_names <- init[[1L]]
  
  out <- do.call(
    rbind, lapply(init[seq(2, length(init))], 
                  function(x) as.integer(x[seq(2, length(init))]))
  )
  
  dimnames(out) <- list(dim_names, dim_names)
  
  out
}


# Table 1 Jemaah Islamiyah binary relations ====
adj_mat_1 <- pasted_table_to_adj_mat(
"MUKLAS	AMROZI	IMRON	SAMUDRA	DULMATIN	IDRIS	MUBAROK	AZAHARI	GHONI	ARNASAN	RAUF	OCTAVIA	HIDAYAT	JUNAEDI	PATEK	FERI	SARIJO
MUKLAS	0	1	1	1	1	1	0	1	1	0	0	0	0	0	1	0	1
AMROZI	1	0	0	1	0	1	1	0	0	0	0	0	0	0	0	0	0
IMRON	1	0	0	1	1	1	0	1	1	0	0	0	0	0	1	1	1
SAMUDRA	1	1	1	0	1	1	1	1	1	1	1	1	1	1	1	0	1
DULMATIN	1	0	1	1	0	1	0	1	1	0	0	0	0	0	1	1	1
IDRIS	1	1	1	1	1	0	1	1	1	0	0	0	0	0	1	0	1
MUBAROK	0	1	0	1	0	1	0	0	0	0	0	0	0	0	0	0	0
AZAHARI	1	0	1	1	1	1	0	0	1	0	0	0	0	0	1	1	1
GHONI	1	0	1	1	1	1	0	1	0	0	0	0	0	0	1	1	1
ARNASAN	0	0	0	1	0	0	0	0	0	0	1	1	1	1	0	0	0
RAUF	0	0	0	1	0	0	0	0	0	1	0	1	1	1	0	0	0
OCTAVIA	0	0	0	1	0	0	0	0	0	1	1	0	1	1	0	0	0
HIDAYAT	0	0	0	1	0	0	0	0	0	1	1	1	0	1	0	0	0
JUNAEDI	0	0	0	1	0	0	0	0	0	1	1	1	1	0	0	0	0
PATEK	1	0	1	1	1	1	0	1	1	0	0	0	0	0	0	1	1
FERI	0	0	1	0	1	0	0	1	1	0	0	0	0	0	1	0	1
SARIJO	1	0	1	1	1	1	0	1	1	0	0	0	0	0	1	1	0"
)

stopifnot(
  Matrix::isSymmetric(adj_mat_1)
)


# Table 2 Jemaah Islamiyah: Interactional criteria applied ====
adj_mat_2 <- pasted_table_to_adj_mat(
"MUKLAS	AMROZI	IMRON	SAMUDRA	DULMATIN	IDRIS	MUBAROK	AZAHARI	GHONI	ARNASAN	RAUF	OCTAVIA	HIDAYAT	JUNAEDI	PATEK	FERI	SARIJO
MUKLAS	0	2	2	1	1	5	0	1	1	0	0	0	0	0	1	0	1
AMROZI	2	0	0	2	0	4	5	0	0	0	0	0	0	0	0	0	0
IMRON	2	0	0	3	5	3	0	5	5	0	0	0	0	0	5	1	5
SAMUDRA	1	2	3	0	2	5	2	2	2	2	2	2	2	2	2	0	2
DULMATIN	1	0	5	2	0	2	0	5	5	0	0	0	0	0	5	1	5
IDRIS	5	4	3	5	2	0	2	2	2	0	0	0	0	0	2	0	2
MUBAROK	0	5	0	2	0	2	0	0	0	0	0	0	0	0	0	0	0
AZAHARI	1	0	5	2	5	2	0	0	5	0	0	0	0	0	2	1	2
GHONI	1	0	5	2	5	2	0	5	0	0	0	0	0	0	5	1	5
ARNASAN	0	0	0	2	0	0	0	0	0	0	2	2	2	2	0	0	0
RAUF	0	0	0	2	0	0	0	0	0	2	0	2	2	2	0	0	0
OCTAVIA	0	0	0	2	0	0	0	0	0	2	2	0	2	2	0	0	0
HIDAYAT	0	0	0	2	0	0	0	0	0	2	2	2	0	2	0	0	0
JUNAEDI	0	0	0	2	0	0	0	0	0	2	2	2	2	0	0	0	0
PATEK	1	0	5	2	5	2	0	2	5	0	0	0	0	0	0	1	5
FERI	0	0	1	0	1	0	0	1	1	0	0	0	0	0	1	0	1
SARIJO	1	0	5	2		2	0	2	5	0	0	0	0	0	5	1	0"
)


names_in_article_vis <- c("ARNASAN", "RAUF", "JUNAEDI", "OCTAVIA", "HIDAYAT", 
                          "SAMUDRA", "FERI", "DULMATIN", "SARIJO", "PATEK",
                          "GHONI", "HUSIN", "IMRON", "IDRIS", "MUKLAS", 
                          "AMROZI", "MUBAROK")

# AZAHARI is not in article's visualization, but is HUSIN
setdiff(names_in_article_vis, rownames(adj_mat_1))
#> [1] "HUSIN"
setdiff(names_in_article_vis, rownames(adj_mat_2))
#> [1] "HUSIN"

# role_attr <- c(
#   "MUKLAS",      "command team",
#   "AMROZI",      "operation assistant",
#   "IMRON",      "operation assistant",
#   "SAMUDRA",      "command team",
#   "DULMATIN",      "bomb maker",
#   "IDRIS",      "command team",
#   "MUBAROK",      "operation assistant",
#   "AZAHARI",      "bomb maker",
#   "GHONI",      "bomb maker",
#   "ARNASAN",      "suicide bomber",
#   "RAUF",      "Team Lima",
#   "OCTAVIA",      "Team Lima",
#   "HIDAYAT",      "Team Lima",
#   "JUNAEDI",      "Team Lima",
#   "PATEK",      "bomb maker",
#   "FERI",      "suicide bomber",
#   "SARIJO",      "bomb maker"
# )

node_attrs <- tibble::tribble(
  ~name,           ~role,
  "MUKLAS",        "command team",
  "AMROZI",        "operation assistant",
  "IMRON",         "operation assistant",
  "SAMUDRA",       "command team",
  "DULMATIN",      "bomb maker",
  "IDRIS",         "command team",
  "MUBAROK",       "operation assistant",
  "AZAHARI",       "bomb maker",
  "GHONI",         "bomb maker",
  "ARNASAN",       "suicide bomber",
  "RAUF",          "Team Lima",
  "OCTAVIA",       "Team Lima",
  "HIDAYAT",       "Team Lima",
  "JUNAEDI",       "Team Lima",
  "PATEK",         "bomb maker",
  "FERI",          "suicide bomber",
  "SARIJO",        "bomb maker"
)

stopifnot(
  identical(node_attrs$name, rownames(adj_mat_1))
)
stopifnot(
  identical(node_attrs$name, rownames(adj_mat_2))
)

jemmah_islamiyah <- igraph::graph_from_adjacency_matrix(
  adj_mat_1, mode = "undirected"
)
igraph::vertex_attr(jemmah_islamiyah) <- as.list(node_attrs)

usethis::use_data(jemmah_islamiyah, overwrite = TRUE)
