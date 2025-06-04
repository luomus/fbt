use("glue", "glue")
unlink("terms.md")

term_template <- readLines("term.template")

terms <- read.csv("terms.csv")
terms <- apply(terms, 1, c, simplify = FALSE)

for (i in terms) {

  term       <- i[["term"]]
  label      <- i[["label"]]
  definition <- i[["definition"]]
  notes      <- i[["notes"]]
  examples   <- i[["examples"]]

  cat(
    as.character(do.call(glue, c(as.list(term_template), .sep = "\n"))),
    file = "index.html",
    append = TRUE
  )

}
