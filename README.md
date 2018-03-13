# yasp: String Functions for Compact R Code

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/yasp)](https://cran.r-project.org/package=yasp)

yasp is a small `R` package for working with character vectors. It is written
in pure base `R` and has no dependancies. It includes:

### `paste` wrappers with short names and various defaults

|                 | mnemonic                  | `collapse=`| `sep=` |
| :-------------- | :------------------------ | :--------- | :----- |
| `p()`, `p0()`   | paste, paste0             | `NULL`     | `""`   |
| `ps()`, `pss()` | paste (sep) space         | `NULL`     | `" "`  |
| `psh()`         | paste sep hyphen          | `NULL`     | `"_"`  |
| `psu()`         | paste sep underscore      | `NULL`     | `"-"`  |
| `psnl()`        | paste sep newline         | `NULL`     | `"\n"` |
| `pc()`          | paste collapse            | `""`       | `""`   |
| `pcs()`         | paste collapse space      | `" "`      | `""`   |
| `pcc()`         | paste collapse comma      | `", "`     | `""`   |
| `pcsc()`        | paste collapse semicolon  | `"; "`     | `""`   |
| `pcnl()`        | paste collapse newline    | `"\n"`     | `""`   |
| `pc_and()`      | paste collapse and        | _varies_   | `""`   |
| `pc_or()`       | paste collapse or         | _varies_   | `""`   |

`pc_and` and `pc_or` collapses vectors of length 3 or greater using a serial 
comma (aka, oxford comma)
``` r
pc_and( letters[1:2] )  # "a and b"
pc_and( letters[1:3] )  # "a, b, and c"
pc_or( letters[1:2] )  # "a or b"
pc_or( letters[1:3] )  # "a, b, or c"
```

### `wrap` and variants
Wrap a string with some characters
```
wrap("abc", "__")  #  __abc__
dbl_quote("abc")   #   "abc"
sngl_quote("abc")  #   'abc'
parens("abc")      #   (abc)
bracket("abc")     #   [abc]
brace("abc")       #   {abc}
```

### `unwrap`, `unparens`
Remove pairs of characters from a string
``` r
label <- p("name", parens("attribute"))

label             # "name (attribute)"
unparens(label)   # "name attribute"

# by default, removes all matching pairs of left and right
x <- c("a", "(a)", "((a))", "(a) b", "a (b)", "(a) (b)" )
data.frame( x, unparens(x), check.names = FALSE )
#>         x unparens(x)
#> 1       a           a
#> 2     (a)           a
#> 3   ((a))           a
#> 4   (a) b         a b
#> 5   a (b)         a b
#> 6 (a) (b)         a b
```
specify `n_pairs` to remove a specific number of pairs
``` r
x <- c("(a)", "((a))", "(((a)))", "(a) (b)", "(a) (b) (c)", "(a) (b) (c) (d)")
data.frame( x, "n_pairs=1"   = unparens(x, n_pairs = 1),
               "n_pairs=2"   = unparens(x, n_pairs = 2),
               "n_pairs=3"   = unparens(x, n_pairs = 3),
               "n_pairs=Inf" = unparens(x), # the default 
               check.names = FALSE)
  
#>                 x     n_pairs=1   n_pairs=2 n_pairs=3 n_pairs=Inf
#> 1             (a)             a           a         a           a
#> 2           ((a))           (a)           a         a           a
#> 3         (((a)))         ((a))         (a)         a           a
#> 4         (a) (b)         a (b)         a b       a b         a b
#> 5     (a) (b) (c)     a (b) (c)     a b (c)     a b c       a b c
#> 6 (a) (b) (c) (d) a (b) (c) (d) a b (c) (d) a b c (d)     a b c d
```
use `unwrap()` to specify any pair of characters for left and right
``` r
x <- "A string with some \\emph{latex tags}."
unwrap(x, "\\emph{", "}")
#> [1] "A string with some latex tags."
```
by default, only pairs are removed. Set a character to `""` to override.
``` r
x <- c("a)", "a))", "(a", "((a" )
data.frame(x, unparens(x), 'left=""' = unwrap(x, left = "", right = ")"),
           check.names = FALSE)
  
#>     x unparens(x) left=""
#> 1  a)          a)       a
#> 2 a))         a))       a
#> 3  (a          (a      (a
#> 4 ((a         ((a     ((a
```

### `sentence`

`paste` with some additional string cleaning (mostly concerning
whitespace) appropriate for prose sentences. It

  + trims leading and trailing whitespace
  + collapses runs of multiple whitespace into a single space
  + appends a period `.` if there is no terminal punctuation mark (`.`, `?`, or `!`)
  + removes spaces preceding punctuation characters: `.?!,;:`
  + collapses sequences of punctuation characters (`.?!,;:`) (possibly
      separated by spaces), into a single punctuation character. The first
      punctuation character of the sequence is used, with priority given to
      terminal punctuation marks `.?!` if present
  + makes sure a space or end-of-string follows every one of
      `.?!,;:`, with an exception for the special case of `.,:`
      followed by a digit, indicating the punctuation is a decimal period, 
      number seperator, or time delimiter
  + capitalizes the first letter of each sentence (start-of-string or
      following a `.?!`)
      
Some examples in `?sentence`:
``` r
compare <- function(x) cat(sprintf(' in: "%s"\nout: "%s"\n', x, sentence(x)))

#>  in: "capitilized and period added"
#> out: "Capitilized and period added."

#>  in: "whitespace:added ,or removed ; like this.and this"
#> out: "Whitespace: added, or removed; like this. And this."

#>  in: "periods and commas in numbers like 1,234.567 are fine !"
#> out: "Periods and commas in numbers like 1,234.567 are fine!"

#>  in: "colons can be punctuation or time : 12:00 !"
#> out: "Colons can be punctuation or time: 12:00!"

#>  in: "only one punctuation at a time!.?,;"
#> out: "Only one punctuation at a time!"

#>  in: "The first mark ,; is kept;,,with priority for terminal marks  ;,."
#> out: "The first mark, is kept; with priority for terminal marks."

# vectorized like paste()
sentence(
 "The", c("first", "second", "third"), "letter is", letters[1:3],
 parens("uppercase:", sngl_quote(LETTERS[1:3])), ".")
#> [1] "The first letter is a (uppercase: 'A')." 
#> [2] "The second letter is b (uppercase: 'B')."
#> [3] "The third letter is c (uppercase: 'C')."
```

## Installation

You can install 'yasp' from CRAN with:
``` r
install.packages("yasp")
```
Or install from github with:

``` r
# install.packages("devtools")
devtools::install_github("t-kalinowski/yasp")
```
