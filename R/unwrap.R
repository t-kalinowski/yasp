#' unwrap
#'
#' Remove pair(s) of characters from a string. The pair to be removed
#' can be in any position within the string.
#'
#' @param x character vector
#' @param left left character to remove
#' @param right right character to remove. Only removed if position is after \code{left}
#' @param n_pairs number of character pairs to remove
#'
#' @return character vector with pairs removed
#' @export
#'
#' @examples
#' # by default, removes all matching pairs of left and right
#' x <- c("a", "(a)", "((a))", "(a) b", "a (b)", "(a) (b)" )
#' data.frame( x, unparens(x), check.names = FALSE )
#'
#' # specify n_pairs to remove a specific number of pairs
#' x <- c("(a)", "((a))", "(((a)))", "(a) (b)", "(a) (b) (c)", "(a) (b) (c) (d)")
#' data.frame( x,
#'             "n_pairs=1"   = unparens(x, n_pairs = 1),
#'             "n_pairs=2"   = unparens(x, n_pairs = 2),
#'             "n_pairs=3"   = unparens(x, n_pairs = 3),
#'             "n_pairs=Inf" = unparens(x), # the default
#'             check.names = FALSE )
#'
#' # use unwrap() to specify any pair of characters for left and right
#' x <- "A string with some \\emph{latex tags}."
#' unwrap(x, "\\emph{", "}")
#'
#' # by default, only pairs are removed. Set a character to "" to override.
#' x <- c("a)", "a))", "(a", "((a" )
#' data.frame(x, unparens(x),
#'   'left=""' = unwrap(x, left = "", right = ")"),
#'   check.names = FALSE)
unwrap <- function(x, left = "", right = left, n_pairs = Inf) {

  repeat {

    # get the index positions of the first left match
    left_match <- as.integer(regexpr(left, x, fixed = TRUE))

    # get the index positions of the first right match after the first left match
    pos_start_search_right <- left_match + nchar(left)

    right_match <- as.integer(
      regexpr(right, substr(x, pos_start_search_right, nchar(x))))


    both_match <- left_match != -1L & left_match < right_match
    # right_match != -1  implicitly must be TRUE

    if (!any(both_match)) break

    xtmp <- x[both_match]
    left_match  <- left_match[both_match]
    right_match <- right_match[both_match]

    xtmp <- drop_chars(xtmp, left_match,  len = nchar(left))

    # adjust right match after dropping left chars
    right_match <- right_match - nchar(left)
    xtmp <- drop_chars(xtmp, right_match, len = nchar(right))

    x[both_match] <- xtmp
    n_pairs <- n_pairs - 1L
    if (n_pairs < 1L) break
  }
  x
}

#' @export
#' @rdname unwrap
unparens <- function(x, n_pairs = Inf)
  unwrap(x, left = "(", right = ")", n_pairs = n_pairs)


drop_chars <- function(string, start, end = start + len, len = 1L){
  left_side <- substr(string, 1L, start - 1L)
  right_side <- substr(string, end, nchar(string))
  paste0(left_side, right_side)
}
