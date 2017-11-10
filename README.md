# yasp: Yet Another String Package

yasp is a small `R` package built almost entirely around `base::paste`. It includes:

### `paste` wrappers with short names and different defaults

|             | mnemonic	               | `collapse=`| `sep=` |
| :---------- | :----------------------- | :--------- | :----- |
| `p()`	      | paste	                   | `NULL`	    | `" "`  |
| `p0()`	    | paste0	                 | `NULL`     | `""`   |
| `pc()`	    | paste collapse	         | `""`	      | `""`   |
| `pcs()`	    | paste collapse space	   | `" "`	    | `""`   |
| `pcc()`	    | paste collapse comma	   | `", "`     | `""`   |
| `pcsc()`	  | paste collapse semicolon | `"; "`     | `""`   |
| `pcnl()`	  | paste collapse newline	 | `"\n"`     | `""`   |
| `pc_and()`	| paste collapse and	     | _varies_   | `""`   |

`pc_and` collapses vectors of length 3 or greater using a serial comma (aka, oxford comma)
```
pc_and( letters[1:2] )  # "a and b"
pc_and( letters[1:3] )  # "a, b, and c"
```

### `wrap` and variants
Wrap a string with some characters

* `wrap("x", left = "", right = left)`
* `dbl_quote("x")`  -->  `"\"x\""`
* `sngl_quote("x")` --> `"'x'"`
* `parens("x")`     -->     `"(x)"` 
* `bracket("x")`    -->    `"[x]"`
* `brace("x")`      -->    `"{x}"`


### `unwrap`, `unparens`
Remove pairs of characters from a string
``` r
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
```
x <- c("(a)", "((a))", "(((a)))", "(a) (b)", "(a) (b) (c)", "(a) (b) (c) (d)")
data.frame( x, "n_pairs=1" = unparens(x, n_pairs = 1),
               "n_pairs=2" = unparens(x, n_pairs = 2),
               "n_pairs=3" = unparens(x, n_pairs = 3),
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
```
x <- "A string with some \\emph{latex tags}."
unwrap(x, "\\emph{", "}")
#> [1] "A string with some latex tags."
```

by default, only pairs are removed. Set a character to `""` to override.
```

x <- c("a)", "a))", "(a", "((a" )
data.frame(x, unparens(x),
  'left=""' = unwrap(x, left = "", right = ")"),
  check.names = FALSE)
  
#>     x unparens(x) left=""
#> 1  a)          a)       a
#> 2 a))         a))       a
#> 3  (a          (a      (a
#> 4 ((a         ((a     ((a
```

### `sentence`
`paste` with some additional string cleaning around `.`, `,`, and whitespace 
appropriate for a prose sentence.

## Installation

You can install yasp from github with:

``` r
# install.packages("devtools")
devtools::install_github("t-kalinowski/yasp")
```
