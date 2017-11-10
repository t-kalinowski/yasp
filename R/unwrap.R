



#' unwrap
#'
#' Remove pair(s) of wrapping characters from a string. The pair to be removed
#' can be in any position within the string.
#'
#' @param x character vector
#' @param left left character to remove
#' @param right right character to remove
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
#'             "npairs=1" = unparens(x, n_pairs = 1),
#'             "npairs=2" = unparens(x, n_pairs = 2),
#'             "npairs=3" = unparens(x, n_pairs = 3),
#'             "npairs=Inf" = unparens(x),
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

    all_right_matches <- gregexpr(right, x, fixed = TRUE)

    # get the index positions of the first right match after the first left match
    pos_start_search_right <- left_match + nchar(left)

    right_match <- as.integer(
      regexpr(right, substr(x, pos_start_search_right, nchar(x))))

    right_match <- ifelse(right_match == -1L, -1L,
                          right_match + pos_start_search_right -1L)

    ## older, functional implementation of search for right...
    ## not sure which is better
    # right_match <- vapply(seq_along(x), function(i)
    #                         Find(function(match) match > left_match[i],
    #                              all_right_matches[[i]], nomatch = -1L),
    #                              integer(1L))


    # right_match <- vapply(seq_along(x), function(i) {
    #   matches <- all_right_matches[[i]]
    #   matches[which.max(matches > left_match[i])]
    # }

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


# list(l = left_matches, r = right_matches)
#
# regmatches(wo_left, ) <- ""
#
# wo_right <- wo_left
# regmatches(wo_right, regexpr(left, wo_right, fixed = TRUE)) <- ""
#
# x <- wo_right
# x
#   ifelse(left_match)
#
# left_match <- regexpr(left, x)
#
#
#
# remove_left <- sub(left, "", x, fixed = TRUE)
# remove_left <- sub(left, "", x, fixed = TRUE)
# left <- grepl("(^|\\s)\\(", x)
# right <- grepl("\\)($|\\s)", x)
# lr <- left & right
# if()
#   x[lr] <- gsub("(^|\\s)\\(", "\\1", x[lr])
# x[lr] <- gsub("\\)($|\\s)", "\\1", x[lr])
# x
#
#     #remove left


# this doesn't work, replacement cant be 0 nchar()
# substr(xtmp, left_pos, left_pos + nchar(left)) <- ""
# substr(xtmp, right_pos, right_pos) <- ""
# x[both_match] <- xtmp


#' unparens <- function(x, all = FALSE) {
#'
#'   remove_left <- sub()
#'   remove_right <- sub()
#'   left <- grepl("(^|\\s)\\(", x)
#'   right <- grepl("\\)($|\\s)", x)
#'   lr <- left & right
#'   if()
#'   x[lr] <- gsub("(^|\\s)\\(", "\\1", x[lr])
#'   x[lr] <- gsub("\\)($|\\s)", "\\1", x[lr])
#'   x
#' }



# drop_chars <- function(string, pos_start, len = 1L){
#   left_side <- substr(string, 1L, pos_start - 1L)
#   right_side <- substr(string, pos_start + len, nchar(string))
#   paste0(left_side, right_side)
# }
# strReverse <- function(x)
#   sapply(lapply(strsplit(x, NULL), rev), paste, collapse = "")

#' @export
# unwrap <- function(x, left = "_", right = left) {
#
#   left_match <- regexpr(left, x, fixed = TRUE) %>% as.vector()
#   right_match <- gregexpr(right, x, fixed = TRUE) %>% vapply(function(idx) tail(idx, 1L), integer(1L))
#
#   both_match <- left_match != -1 & right_match != -1 & left_match < right_match
#
#   if (any(both_match)) {
#     xtmp <- x[both_match]
#     left_match  <- left_match[both_match]
#     right_match <- right_match[both_match]
#
#     xtmp <- drop_chars(xtmp, left_match,  len = nchar(left))
#
#     right_match <- right_match - nchar(left)
#     xtmp <- drop_chars(xtmp, right_match, len = nchar(right))
#
#     x[both_match] <- xtmp
#
#   }
#   x
# }




# unwrap <- function(x, left = "_", right = left, n_pairs = 1L) {
#   repeat {
#     left_match <- as.integer(regexpr(left, x, fixed = TRUE))
#     right_match <- vapply(gregexpr(right, x, fixed = TRUE),
#                           function(idx) tail(idx, 1L), integer(1L))
#
#     both_match <-
#       left_match != -1 & right_match != -1 & left_match < right_match
#
#     if (!any(both_match)) break
#
#     xtmp <- x[both_match]
#     left_match  <- left_match[both_match]
#     right_match <- right_match[both_match]
#
#     xtmp <- drop_chars(xtmp, left_match,  len = nchar(left))
#
#     # adjust right match after dropping left chars
#     right_match <- right_match - nchar(left)
#     xtmp <- drop_chars(xtmp, right_match, len = nchar(right))
#
#     x[both_match] <- xtmp
#     n_pairs <- n_pairs - 1L
#     if (n_pairs < 1L) break
#   }
#   x
# }



#
# lapply(seq_along(x),
#        function(i) Find(function(m) m > left_match[i], all_rightg[[i]])
# )
#
#
# drop_left <- function(x) {
#   drop_chars()
# }
#
#
# right_match <- as.integer(regexpr(left, drop_chars(x, left_match, nchar(left)), fixed = TRUE))
#
# vapply(gregexpr(right, x, fixed = TRUE),
#        function(idx) tail(idx, 1L), integer(1L))

