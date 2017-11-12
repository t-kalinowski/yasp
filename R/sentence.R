
#' sentence
#'
#' A wrapper around \code{paste} that does some simple cleaning appropriate for
#' prose sentences. It
#' \enumerate{
#'    \item trims leading and trailing whitespace
#'    \item collapses runs of whitespace into a single space
#'    \item appends a period (\code{.}) if there is no terminal punctuation
#'          mark (\code{.}, \code{?}, or \code{!})
#'    \item removes spaces preceding punctuation characters: \code{.?!,;:}
#'    \item collapses sequences of punctuation marks (\code{.?!,;:}) (possibly
#'          separated by spaces), into a single punctuation mark.
#'          The first punctuation mark of the sequence is used, with
#'          priority given to terminal punctuation marks \code{.?!} if present
#'    \item makes sure a space or end-of-string follows every one of
#'          \code{.?!,;:}, with an exception for the special case of \code{.,:}
#'          followed by a digit, indicating the punctuation is decimal period,
#'          number separator, or time delimiter
#'    \item capitalizes the first letter of each sentence (start-of-string or
#'          following a \code{.?!})
#' }
#'
#' @param ... passed on to \code{paste}
#'
#' @export
#'
#' @examples
#' compare <- function(x) cat(sprintf(' in: "%s"\nout: "%s"\n', x, sentence(x)))
#' compare("capitilized and period added")
#' compare("whitespace:added ,or removed ; like this.and this")
#' compare("periods and commas in numbers like 1,234.567 are fine !")
#' compare("colons can be punctuation or time : 12:00 !")
#' compare("only one punctuation mark at a time!.?,;")
#' compare("The first mark ,; is kept;,,with priority for terminal marks ;,.")
#'
#' # vectorized like paste()
#' sentence(
#'  "The", c("first", "second", "third"), "letter is", letters[1:3],
#'  parens("uppercase:", sngl_quote(LETTERS[1:3])), ".")
sentence <- function(...) {
  x <- paste(...)

  x <- trimws(x)

  # we use perl = TRUE as the default everywhere because
  # it's both faster and more powerful
  lgsub <- function(ptrn, rplc) gsub(ptrn, rplc, x, perl = TRUE)

  # Add a period if there isn't a terminal punctuation mark
  x <- ifelse(grepl("[?!.]$", x, perl = TRUE), x, paste0(x, "."))

  # 2 or more spaces into 1 space
  x <- lgsub("[[:space:]]+", " ")

  # remove spaces preceding ?!.,;:
  x <- lgsub("[[:space:]]([.,?;:!])", "\\1")

  # if there are multiple punctuation characters in a row (possibly separated by
  # spaces), just keep the first, giving priority to terminal marks ?!. if
  # present.

  ## first, look for sequences that contain ?!., and capture that and possibly a
  ## space
  x <- lgsub("[;:, ]*([.?!] ?)[.?!:;,]*( ?)[.?!:;, ]*", "\\1\\2")

  ## next, look for sequences that contain ,;: and capture the first one possibly
  ## a space
  x <- lgsub("([,;:])[;:,]*( ?)[;, ]*", "\\1\\2")

  # make sure a space or EOL or digit follows every period or comma or colon.
  # digit unless it's followd by a digit, indicating its a decimal or numeric
  # separator or time separator and not punctuation.
  # there should not be any ",$" matches at this point
  x <- lgsub("([.,:])(?![[:digit:] ]|$)", "\\1 ")

  # make sure a space or EOL follows every ?!;
  x <- lgsub("([?!;])(?! |$)", "\\1 ")

  # Capatilize first letter following a .?! or at the start of the string
  x <- lgsub("(^|[.?!] )([[:lower:]])", "\\1\\U\\2")

  x
}
