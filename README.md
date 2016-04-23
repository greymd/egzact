![logo](./img/logo.png)
# Simplify what can hardly be done with Shell.
New command line tools with three concepts.

* Enumeration of various patterns from standard input.
* Useful equivalents for existent Linux commands (inspired by [nixar](https://github.com/askucher/nixar)).
* Controlling records and fields given by particular separator (inspired by [Open-Usp-Tukubai](https://github.com/usp-engineers-community/Open-usp-Tukubai)).

## Install (Mac OSX / Linux)

### 1. Install Egison
Install *upper 3.6.0*.

Mac
http://www.egison.org/getting-started/getting-started-mac.html

Linux
http://www.egison.org/getting-started/getting-started-linux.html

### 2. Execute following commands

```sh
$ git clone https://github.com/greymd/egzact.git
$ cd egzact
$ make install

# Add path
$ echo 'PATH=$PATH:$HOME/.egison/bin' >> ~/.bashrc
$ source ~/.bashrc

# Works!
$ seq 10 | flat | takel 3
1 2 3
```

## Docker

You can also try commands on the docker container.
```sh
$ git clone https://github.com/greymd/egzact.git
$ docker build -t ubuntu/egzact egzact

# Open bash on the container
$ docker run -it ubuntu/egzact /bin/bash

# Works!
root@XXXXXXXXX:/# seq 10 | flat | takel 3
1 2 3
```

# Commands
## Generate multiple results from whole the STDIN

### $ `conv`

It recognizes whole the inputs as the set of fields and prints them with specified number of cols. It convolutes the each records.

```sh
$ seq 10 | conv 2
1 2
2 3
3 4
4 5
5 6
6 7
7 8
8 9
9 10

# Infinite input
$ yes | awk '$0=NR'
1
2
3
4
5
.
.
.

$ yes | awk '$0=NR' | conv 3 | head
1 2 3
2 3 4
3 4 5
4 5 6
5 6 7
.
.
.

```

### $ `flat`
It recognizes whole the inputs as the set of fields and prints them with specified number of cols.
In default, it just removes the new lines.

```sh
$ seq 10 | flat
1 2 3 4 5 6 7 8 9 10
```

The behavior is same as `xargs -n N` option. However [Common command line options](#common-command-line-options) like `fs` can be used.

```sh
$ seq 10 | flat 2
1 2
3 4
5 6
7 8
9 10

# Comma separeted file
$ cat myfile
AA,AB,AC,AD
BA,BB,BC,BD
CA,CB,CC,CD
DA,DB,DC,DD

# Field separator(fs) option is useful for keeping comma.
$ cat myfile | flat 8 fs=,
AA,AB,AC,AD,BA,BB,BC,BD
CA,CB,CC,CD,DA,DB,DC,DD
```

## Generate multiple results for each line.

### $ `stairl`

Generate subsets of the fields.
Each result matches to the *left* side of the original input.
In most cases, it looks *stairs*.

```sh
$ echo A B C D | stairl
A
A B
A B C
A B C D
```

#### what's going to happen if the input has multiple lines?

```sh
$ cat myfile2
AA AB AC AD
BA BB BC BD
CA CB CC CD

# The command is executed for each line.
$ cat myfile2 | stairl
AA
AA AB
AA AB AC
AA AB AC AD
BA
BA BB
BA BB BC
BA BB BC BD
CA
CA CB
CA CB CC
CA CB CC CD

# `eos` option is helpful if you want to know where each result is coming from.
$ cat myfile2 | stairl eos=---
AA
AA AB
AA AB AC
AA AB AC AD
---
BA
BA BB
BA BB BC
BA BB BC BD
---
CA
CA CB
CA CB CC
CA CB CC CD
```

### $ `stairr`

Generate subsets of the fields.
Results match to the *right* side of the original input.
In most cases, it looks *stairs*.

```sh
$ echo A B C D | stairr
D
C D
B C D
A B C D
```

### $ `subsets`

Generate all the subsets of the fields.

```sh
$ echo A B C D | subsets
A
A B
B
A B C
B C
C
A B C D
B C D
C D
D
```

Whole the results is same as `stairl | stairr` when the duplicated lines can be merged.

```sh
$ echo A B C D | stairl | stairr | sort | uniq
A
A B
A B C
A B C D
B
B C
B C D
C
C D
D

$ echo A B C D | subsets | sort | uniq
A
A B
A B C
A B C D
B
B C
B C D
C
C D
D
```

### $ `pattn`
Crop all the patterns which matches given string (regular expression).
It includes all the patterns (from shortest to longest match).

```sh
$ echo 1110100110 | pattn "1.*1"
11
111
11101
1101
101
11101001
1101001
101001
1001
111010011
11010011
1010011
10011
```

If you want to use normal `grep` command for matching query, `stairr fs="" | stairl fs=""` can works with almost same behavior. In addition, it is faster than `pattn` because it works with multi processing.

```sh
$ echo 1110100110 | stairr fs="" | stairl fs="" | grep -o '1.*1' | sort | uniq
1001
10011
101
101001
1010011
11
1101
1101001
11010011
111
11101
11101001
111010011
```

### $ `cycle`

Generate all the circulated patterns.

```sh
$ echo A B C D E | cycle
A B C D E
B C D E A
C D E A B
D E A B C
E A B C D
```

### $ `comb`

Generate **combinations** of N of fields.

```
$ echo A B C D | comb 2
A B
A C
B C
A D
B D
C D
```

### $ `perm`

Generate **permutations** of N of fields.

```sh
$ echo A B C D | perm 2
A B
A C
B A
A D
B C
C A
B D
C B
D A
C D
D B
D C
```

### $ `dupl`

Duplicate lines.

```sh
$ echo A B C D | dupl 3
A B C D
A B C D
A B C D
```

## Generate single result for each line.

### $ `addl`

Add str to left side of the input.

*Add* + *L*eft

```sh
$ echo abc | addl ABC
ABCabc
```

### $ `addr`

Add str to right side of the input.

*Add* + *R*ight

```sh
$ echo abc | addr ABC
abcABC
```


### $ `mirror`

Reverse the order of the field.

```sh
$ echo A B C D | mirror
D C B A
```


### $ `takel`

Print first *N* of fields.

*Take* + *L*eft

```sh
$ echo A B C D | takel 3
A B C
```

### $ `taker`

Print last *N* of fields.

*Take* + *R*ight

```sh
$ echo A B C D | taker 3
B C D
```

### $ `takelx`

Print fields from first one to the one which matches given regular expression.

*Take* + *L*eft + rege*X*

```sh
$ echo QBY JCG FCM PAG TPX BQG UGB | takelx "^P.*$"
QBY JCG FCM PAG
```

### $ `takerx`

Print fields from last one to the one which matches given regular expression.

*Take* + *R*ight + rege*X*

```sh
$ echo QBY JCG FCM PAG TPX BQG UGB | takerx "^P.*$"
PAG TPX BQG UGB
```

### $ `dropl`

Remove first *N* of fields.

*Drop* + *L*eft

```sh
$ echo QBY JCG FCM PAG TPX BQG UGB | dropl 3
PAG TPX BQG UGB
```

### $ `dropr`

Remove last *N* of fields.

*Drop* + *R*ight

```sh
$ echo QBY JCG FCM PAG TPX BQG UGB | dropr 3
QBY JCG FCM PAG
```

### $ `zrep`

Extract particular fields which matches given regular expression.

eg*Z*act + g*REP*

```sh
$ echo 1 2 3 4 5 6 7 8 9 10 | zrep "1"
1 10
```

### $ `zniq`

Merge duplicated fields.

eg*Z*act + u*NIQ*

```sh
$ echo aaa bbb ccc aaa bbb | zniq
aaa bbb ccc
```

### $ `wrap`

Add particular prefix and suffix to each field in accordance with given argument.
`*` is the placeholder which represents each field.

```sh
$ echo aaa bbb ccc | wrap "<p>*</p>"
<p>aaa</p> <p>bbb</p> <p>ccc</p>
```

### $ `nestl`

Nest all the fields with with given argument.
`*` is the placeholder which represents each field.
First field is the most deeply nested element.

*Nest* + *L*eft

```sh
$ echo aaa bbb ccc | nestl "<p>*</p>"
<p> <p> <p> aaa </p> bbb </p> ccc </p>
```

### $ `nestr`

Nest all the fields with with given argument.
`*` is the placeholder which represents each field.
Last field is the most deeply nested element.

*Nest* + *R*ight

```sh
$ echo aaa bbb ccc | nestr "<p>*</p>"
<p> aaa <p> bbb <p> ccc </p> </p> </p>
```

### $ `stick`

Associate each first *N* of fields and each remaining the fields.
Associated two fields are printed sequentially.

```sh
$ echo 1 2 3 10 20 30 | stick 3
1 10 2 20 3 30
```

## Other commands

### $ `addt`

Add str to top of the input.

```sh
$ echo abc | addt ABC
ABC
abc
```

### $ `addb`

Add str to bottom of the input.

```sh
$ echo abc | addb ABC
abc
ABC
```

## Common command line options

### `fs`
Field separator.

 * Default value is space ` `.
 * Format: `fs=STR`

Example

```sh
$ echo "/usr/local/var/" | stairl fs=/

/usr
/usr/local
/usr/local/var
/usr/local/var/

# In case of empty, each character is regarded as a field.
$ echo "abcdefg" | stairl fs=""
a
ab
abc
abcd
abcde
abcdef
abcdefg
```

### `ifs`
Input field separator.
If `fs` is already set, this option is primarily used.

 * Default value is space ` `.
 * Format: `ifs=STR`

Example

```sh
$ cat myfile3
AA,AB,AC,AD
BA,BB,BC,BD

# "," separated input -> " " separated output.
$ cat myfile3 | stairr ifs=","
AD
AC AD
AB AC AD
AA AB AC AD
BD
BC BD
BB BC BD
BA BB BC BD
```

### `ofs`
Output field separator.
If `fs` is already set, this option is primarily used.

 * Default value is space ` `.
 * Format: `ofs=STR`


Example

```sh
$ cat myfile3
AA,AB,AC,AD
BA,BB,BC,BD

# "," separated input -> "_" separated output.
$ cat myfile3 | cycle ifs="," ofs="_"
AA_AB_AC_AD
AB_AC_AD_AA
AC_AD_AA_AB
AD_AA_AB_AC
BA_BB_BC_BD
BB_BC_BD_BA
BC_BD_BA_BB
BD_BA_BB_BC

# "," separated input -> tab separated output.
$ cat myfile3 | dupl 2 ifs="," ofs="\t"
AA      AB      AC      AD
AA      AB      AC      AD
BA      BB      BC      BD
BA      BB      BC      BD
```

### `eor`
End of record (a.k.a, raw).
Result of each line (record) is separated with new line `\n` in default.
This option change the string for separating each record.

 * Default value is new line `\n`.
 * Format: `eor=STR`

Example

```sh
$ cat myfile4
AA AB AC AD
BA BB BC BD

$ cat myfile4 | stairl
AA           # End of record
AA AB        # End of record
AA AB AC     # End of record
AA AB AC AD  # End of set
BA           # End of record
BA BB        # End of record
BA BB BC     # End of record
BA BB BC BD  # End of set

$ cat myfile4 | stairr eor=" @@@ "
AD @@@ AC AD @@@ AB AC AD @@@ AA AB AC AD
BD @@@ BC BD @@@ BB BC BD @@@ BA BB BC BD
```

### `eos`
End of set. Set means, **result generated from single line**, in this manual.

 * Default value is new line `\n`.
 * Format: `eos=STR`

Example

```sh
$ cat myfile4
AA AB AC AD
BA BB BC BD


$ cat myfile4 | stairl eos="---"
AA
AA AB
AA AB AC
AA AB AC AD
---
BA
BA BB
BA BB BC
BA BB BC BD

$ cat myfile4 | stairl eos="---" eor=" @@@ " ofs=" | "
AA @@@ AA | AB @@@ AA | AB | AC @@@ AA | AB | AC | AD
---
BA @@@ BA | BB @@@ BA | BB | BC @@@ BA | BB | BC | BD
```

## Tips
A special command line option `each` is available in ``flat`` and ``conv`` commands.
The option change command's behavior to "each line mode".
In default, those commands handle whole the standard input (STDIN).
However with this option, those commands can read each line and print the result.

Example

```sh
$ cat myfile4
AA AB AC AD
BA BB BC BD

$ cat myfile4 | flat 3
AA AB AC
AD BA BB
BC BD

$ cat myfile4 | flat each 3
AA AB AC
AD
BA BB BC
BD

$ cat myfile4 | conv each 3 eos="---"
AA AB AC
AB AC AD
---
BA BB BC
BB BC BD
```

## Uninstall

```sh
$ make uninstall
```

# External Library
[UnitTest.hs](./test/UnitTest.hs) is distributed on [egison/egison](https://github.com/egison/egison) under the [MIT license](https://github.com/egison/egison/blob/master/LICENSE).

# License
This software is released under the MIT License.
See [LICENSE](./LICENSE)
