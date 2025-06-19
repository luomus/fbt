use("glue", "glue")
use("jsonlite", "fromJSON")
dir.create("build")

cat(
  sprintf(
    '<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <style>body{background-color:white;}</style>

  <title>FinBIF list of terms</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="FinBIF list of terms">
  <link rel="schema.DC" href="http://purl.org/DC/elements/1.0/">
  <meta name="DC.Title" content="FinBIF terms">
  <meta name="DC.Description" content="FinBIF list of terms">
  <meta name="DC.Date" content=%s>
  <meta name="DC.Language" content="en">
  <meta name="DC.Subject" content="biodiversity data">
</head>
<body>
  <main>
',
    Sys.Date()
  ),
  file = "build/index.html",
  append = TRUE
)

term_template <- readLines("term.template")

terms <- c(
  "informalTaxonGroup",
  "vernacularNameSwedish",
  "redListStatusFinland",
  "lajiturvaStatus",
  "regulatoryStatuses",
  "taxonPreferredHabitat",
  "isSensitiveTaxon",
  "datasetCurationLevel",
  "qualityControl",
  "qualityIssues",
  "sourceName",
  "originatingSource",
  "biogeographicialProvince",
  "locationName",
  "locationStatus",
  "femaleIndividualCount",
  "maleIndividualCount",
  "pairCount",
  "isMigrating",
  "isBreedingSite",
  "invasiveTaxonManagementAction",
  "isStateLand",
  "coordinateAccuracyClass",
  "gridCellYKJ"
)

for (term in terms) {

  term_data <- try(
    fromJSON(
      sprintf("https://rs.laji.fi/terms/%s?format=json", term),
      simplifyVector = FALSE
    ),
    TRUE
  )

  if (!inherits(term_data, "try-error")) {

    lbl <- NULL
    lbl <- term_data[["label"]]

    if (hasName(lbl, "@language")) {

      if (lbl[["@language"]] == "en") lbl <- lbl[["@value"]]

    } else {

      idx <- which(vapply(lbl, "[[", "", "@language") == "en")

      if (length(idx)) lbl <- lbl[[idx]][["@value"]]

    }

    lbl <- lbl %||% ""

    dfn <- NULL
    dfn <- term_data[["HBDF.definition"]]

    if (hasName(dfn, "@language")) {

      if (dfn[["@language"]] == "en") dfn <- dfn[["@value"]]

    } else {

      idx <- which(vapply(dfn, "[[", "", "@language") == "en")

      if (length(idx)) dfn <- dfn[[idx]][["@value"]]

    }

    dfn <- dfn %||% ""

    nts <- NULL
    nts <- term_data[["HBDF.notes"]]

    if (hasName(nts, "@language")) {

      if (nts[["@language"]] == "en") nts <- nts[["@value"]]

    } else {

      idx <- which(vapply(nts, "[[", "", "@language") == "en")

      if (length(idx)) nts <- nts[[idx]][["@value"]]

    }

    nts <- nts %||% ""

    exl <- paste(term_data[["HBDF.examples"]], collapse = "</br>")
    exl <- exl %||% ""

    cat(
      as.character(
        do.call(glue, c(as.list(term_template), .sep = "\n", .trim = FALSE))
      ),
      file = "build/index.html",
      append = TRUE
    )

  }
}

cat(
  '
  </main>
</body>
</html>
',
  file = "index.html",
  append = TRUE
)
