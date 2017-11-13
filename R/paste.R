#' paste variants
#'
#' Wrappers around \code{\link[base:paste]{base::paste}} with a variety of defaults:
#' \tabular{llcc}{
#'    \code{}         \tab \strong{mnemonic}         \tab \strong{\code{collapse=}} \tab \strong{\code{sep=}} \cr
#'    \code{p()}      \tab paste                     \tab \code{NULL}               \tab \code{" "}   \cr
#'    \code{p0()}     \tab paste0                    \tab \code{NULL}               \tab \code{""}    \cr
#'    \code{pc()}     \tab paste collapse            \tab \code{""}                 \tab \code{""}    \cr
#'    \code{pcs()}    \tab paste collapse space      \tab \code{" "}                \tab \code{""}    \cr
#'    \code{pcc()}    \tab paste collapse comma      \tab \code{", "}               \tab \code{""}    \cr
#'    \code{pcsc()}   \tab paste collapse semicolon  \tab \code{"; "}               \tab \code{""}    \cr
#'    \code{pcnl()}   \tab paste collapse newline    \tab \code{"\n"}               \tab \code{""}    \cr
#'    \code{pc_and()} \tab paste collapse and        \tab \emph{varies}             \tab \code{""}    \cr
#' }
#'
#' @param ...,sep passed on to \code{\link[base:paste]{base::paste}}
#' @export
#' @seealso \code{\link{wrap}} \code{\link{sentence}}
#' @rdname paste-variants
#' @examples
#' x <- head(letters, 3)
#' y <- tail(letters, 3)
#' # paste
#' p(x, y)
#' p0(x, y)
#' # paste + collapse
#' pc(x)
#' pc(x, y)
#' pcs(x)
#' pcc(x)
#' pcc(x, y)
#' pcsc(x)
#' pcnl(x)
#' pc_and(x[1:2])
#' pc_and(x[1:3])
#' pc_and(x, y)
#' pc_and(x, y, sep = "-")
#' pc_and(x[1])
#' pc_and(x[0])
p <- function(...) paste(...)

# paste0
#' @export
#' @rdname paste-variants
p0 <- function(...) paste0(...)

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

## removing for now to keep the total number of exported function low
#
# ' # paste collapse underscore
# ' #' @rdname paste-variants
# ' #' @export
# ' pcu <- function(..., sep = "")
# '   paste(..., sep = sep, collapse = "_")
#
# ' # paste collapse dash
# ' #' @rdname paste-variants
# ' #' @export
# ' pcd <- function(..., sep = "")
# '   paste(..., sep = sep, collapse = "-")
#
## lines from documentation tables above and in README
# '    \code{pcu()}    \tab paste collapse underscore \tab \code{"_"}                \tab \code{""}    \cr
# | `pcu()`     | paste collapse underscore | `"_"`      | `""`   |
#
# ## from examples
# # ' pcu(x)

# paste collapse comma
#' @rdname paste-variants
#' @export
pcc <- function(..., sep = "")
  paste(..., sep = sep, collapse = ", ")

# paste collapse new line
#' @rdname paste-variants
#' @export
pcnl <- function(..., sep = "")
  paste(..., sep = sep, collapse = "\n")

# paste collapse semicolon
#' @rdname paste-variants
#' @export
pcsc <- function(..., sep = "")
  paste(..., sep = sep, collapse = "; ")

# paste collapse and
#' @rdname paste-variants
#' @export
pc_and <- function(..., sep = "") {
  x <- paste(..., sep = sep, collapse = NULL)
  lx <- length(x)
  if(lx == 0L)
    ""
  else if (lx == 1L)
    x
  else if (lx == 2L)
    paste0(x, collapse = " and ")
  else
    paste0( paste0(x[-lx], collapse = ", "), ", and ", x[lx])
}


#' Wrap strings
#'
#' Wrap strings with flanking characters
#'
#' @param x character to wrap
#' @param left,right character pair to wrap with
#' @param ... passed to \code{\link[base:paste]{base::paste}} before wrapping
#'
#' @rdname wrap
#' @export
#' @seealso \code{\link{unwrap}} \code{\link{p0}} \code{\link{sentence}}
#' @examples
#' wrap("abc", "__")  #  __abc__
#' parens("abc")      #   (abc)
#' sngl_quote("abc")  #   'abc'
#' dbl_quote("abc")   #   "abc"
#' bracket("abc")     #   [abc]
#' brace("abc")       #   {abc}
#'
#' label <- p("name", parens("attribute"))
#'
#' label             # "name (attribute)"
#' unparens(label)   # "name attribute"
#'
#' # make your own function like this:
#' # markdown bold
#' bold <- function(...) wrap(paste(...), "**")
#' p("make a word", bold("bold"))
#' # see unbold example in ?unwrap
wrap <- function(x, left, right = left)
  paste0(left, x, right)

#' @rdname wrap
#' @export
dbl_quote <- function(...) wrap(paste(...), '"')

#' @rdname wrap
#' @export
sngl_quote <- function(...) wrap(paste(...), "'")

#' @rdname wrap
#' @export
bracket <- function(...) wrap(paste(...), "[", "]")

#' @rdname wrap
#' @export
brace <- function(...) wrap(paste(...), "{", "}")

#' @rdname wrap
#' @export
parens <- function(...) wrap(paste(...), "(", ")")

