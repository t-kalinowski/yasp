# yasp: Yet Another String Package

yasp is small `R` package built almost entirely around `base::paste`. It includes:

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
* `unparens("name (attribute)")` --> `"name attribute"`

### `sentence`
`paste` with some additional string cleaning around `.`, `,`, and whitespace 
appropriate for a prose sentence.

## Installation

You can install yasp from github with:

``` r
# install.packages("devtools")
devtools::install_github("t-kalinowski/yasp")
```
