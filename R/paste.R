#' paste variants
#'
#' There are all wrappers around \code{base::paste} with different defaults:
#' \tabular{llcc}{
#'    \code{}         \tab \strong{mnemonic}        \tab \strong{\code{collapse=}} \tab \strong{\code{sep=}} \cr
#'    \code{p()}      \tab paste                    \tab \code{NULL}               \tab \code{" "}   \cr
#'    \code{p0()}     \tab paste0                   \tab \code{NULL}               \tab \code{""}    \cr
#'    \code{pc()}     \tab paste collapse           \tab \code{""}                 \tab \code{""}    \cr
#'    \code{pcs()}    \tab paste collapse space     \tab \code{" "}                \tab \code{""}    \cr
#'    \code{pcc()}    \tab paste collapse comma     \tab \code{", "}               \tab \code{""}    \cr
#'    \code{pcsc()}   \tab paste collapse semicolon \tab \code{"; "}               \tab \code{""}    \cr
#'    \code{pcnl()}   \tab paste collapse newline   \tab \code{"\n"}               \tab \code{""}    \cr
#'    \code{pc_and()} \tab paste collapse and       \tab \emph{varies}             \tab \code{""}    \cr
#' }
#'
#' @param ... passed on to \code{paste}
#' @param sep passed on to \code{base::paste}
#' @export
#' @seealso \code{\link{wrap}} \code{\link{sentence}}
#' @rdname paste-variants
#' @examples
#' x <- head(letters, 3)
#' y <- tail(letters, 3)
#' p(x, y)
#' p0(x, y)
#' pc(x)
#' pcs(x)
#' pcc(x)
#' pcsc(x)
#' pcnl(x)
#' pc_and(x[1])
#' pc_and(x[1:2])
#' pc_and(x[1:3])
#' pc_and(x, y)
p <- function(...) paste(...)

# paste0
#' @export
#' @rdname paste-variants
p0 <- function(..., sep = "") paste(..., sep = sep)

# paste collapse ""
#' @export
#' @rdname paste-variants
pc <- function(..., sep = "")
  paste(..., sep = sep, collapse = "")

# paste collapse space " "
#' @export
#' @rdname paste-variants
pcs <- function(..., sep = "")
  paste(..., sep = sep, collapse = " ")

# paste collapse new line
#' @rdname paste-variants
#' @export
pcnl <- function(..., sep = "")
  paste(..., sep = sep, collapse = "\n")

# paste collapse comma
#' @rdname paste-variants
#' @export
pcc <- function(..., sep = "")
  paste(..., sep = sep, collapse = ", ")

# paste collapse semicolon
#' @rdname paste-variants
#' @export
pcsc <- function(..., sep = "")
  paste(..., sep = sep, collapse = "; ")

# paste collapse and
#' @rdname paste-variants
#' @export
pc_and <- function(..., sep = "") {
  x <- paste(..., sep = sep)
  lx <- length(x)
  switch( as.character(lx),
    "0" = "",
    "1" = x,
    "2" = paste(x, collapse = " and "),
    # else
    paste0( paste0(x[-lx], collapse = ", "), ", and ", x[lx])

  )
}



#' sentence
#'
#' A wrapper around \code{paste} that does some simple string cleaning before returning the result. It
#' \enumerate{
#'    \item calls \code{trimws}
#'    \item make sure each string ends with a single \code{"."}
#'    \item runs of multiple spaces \code{" "} replaced with one space
#'    \item runs of multiple periods \code{"."} replaced with one period
#'    \item runs of multiple commas \code{","} replaced with one comma
#'    \item spaces before commas or periods removed
#' }
#'
#' @param ... passed on to \code{paste}
#'
#' @export
#'
#' @examples
#' sentence(
#'  "The", c("first", "second", "third"),
#'    "letter is", letters[1:3], ".",
#'  "That's important to know")
#'  x <- p0( "a sentence with   excessive or missing whitespace,",
#' ", extra punctuation, and missing capilitization.more than one in fact ! .Three,actually")
#' cat(x, "\n")
#' cat(sentence(x), "\n")
sentence <- function(...) {
  x <- paste(...)

  x <- trimws(x)

  # we use perl = TRUE as the default everywhere because
  # it's both faster and more powerful

  # Add a period if there isn't a sentence ending punctuation
  x <- ifelse(grepl("[?!.]$", x, perl = TRUE), x, paste0(x, "."))

  # 2 or more spaces into 1 space
  x <- gsub("[[:space:]]+", " ", x, perl = TRUE)

  # remove spaces preceding ?!.,;
  x <- gsub("[[:space:]]([.,?;!])", "\\1", x, perl = TRUE)

  # if there are multiple punctuation characters in a row (possibly separated by
  # spaces), just keep the first, giving priorioty to sentence ending ?!. if
  # present
  x <-  gsub("[;, ]*([.?!;,] ?)[.?!;, ]*", "\\1", x, perl = TRUE)

  # make sure a space or EOL or digit follows every period or comma. digit
  # unless it's followd by a digit, indicating its a decimal or numeric
  # separator and not punctuation.
  # there should be any ",$" matches at this point
  x <- gsub("([.,])(?![[:digit:]]| |$)", "\\1 ", x, perl = TRUE)

  # make sure a space or EOL follows every ?!;
  x <- gsub("([?!;])(?! |$)", "\\1 ", x, perl = TRUE)

  # Capatilize first letter following a .?! or at the start of the string
  x <- gsub("(^|[.?!] )([[:lower:]])", "\\1\\U\\2", x, perl = TRUE)

  x
}


#' Wrap strings
#'
#' These are a series of helpers to help wrap strings with two flanking characters
#'
#' @param x character to wrap
#' @param left character
#' @param right character
#'
#' @rdname wrap
#' @export
#' @seealso paste-variants sentence unwrap
#' @examples
#' wrap("abc", "__")
#' sngl_quote("abc")
#' dbl_quote("abc")
#' parens("abc")
#' bracket("abc")
#' (x <- p("name", parens("attribute")))
wrap <- function(x, left = "", right = left)
  paste0(left, x, right)

#' @rdname wrap
#' @export
dbl_quote <- function(x) wrap(x, '"')

#' @rdname wrap
#' @export
sngl_quote <- function(x) wrap(x, "'")

#' @rdname wrap
#' @export
bracket <- function(x) wrap(x, "[", "]")

#' @rdname wrap
#' @export
brace <- function(x) wrap(x, "{", "}")

#' @rdname wrap
#' @export
parens <- function(x) wrap(x, "(", ")")
