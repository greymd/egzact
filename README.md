# egzact
New command line tools

* Enumeration of various patterns from standard input.
* Useful equivalents for existent Linux commands (like nixar)
* Controlling records and fields given by particular separator (like Open-Usp-Tukubai).

## Install

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
```

## Commands

### flat

It recognizes whole the inputs as the set of fields and prints them with specified number of cols.
In default, it just removes the new lines.

```sh
$ seq 10 | flat
1 2 3 4 5 6 7 8 9 10
```

The behavior is same as `xargs -n N` option.

```sh
$ seq 10 | flat 2
1 2
3 4
5 6
7 8
9 10
```

### conv

It recognizes whole the inputs as the set of fields and prints them with specified number of cols.
It convolutes the each records.

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
```

### addl
Add str to left side of the input.

```sh
$ echo abc | addl ABC
ABCabc
```

### addr
Add str to right side of the input.

```sh
$ echo abc | addr ABC
abcABC
```

### addt
Add str to top of the input.

```sh
$ echo abc | addt ABC
ABC
abc
```

### addb
Add str to bottom of the input.

```sh
$ echo abc | addb ABC
abc
ABC
```

### algrep
Print pattern which matches given string (regular expression).
It includes all the patterns (from shortest to longest match).

```sh
$ echo 1110100110 | algrep "1.*1"
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
### cycle

Generate all the circulated patterns.

```sh
$ echo A B C D E | cycle
A B C D E
B C D E A
C D E A B
D E A B C
E A B C D
```

### comb

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

### perm

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

### dupl

**Duplicate** lines.

```sh
$ echo A B C D | dupl 3
A B C D
A B C D
A B C D
```

### mirror

Reverse the order of the field.

```sh
$ echo A B C D | mirror
D C B A
```

### stairl

Generate the patterns which are subsets of the fields.
Results match to the *left* side of the original input.
In most cases, it looks *stairs*.

```sh
$ echo A B C D | stairl
A
A B
A B C
A B C D
```

### stairr

Generate the patterns which are subsets of the fields.
Results match to the *right* side of the original input.
In most cases, it looks *stairs*.


```sh
$ echo A B C D | stairr
D
C D
B C D
A B C D
```

### stairal

Generate all the patterns which are subsets of the fields.

```sh
$ echo A B C D | stairal
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

### takel

Print first *N* of fields.

```sh
$ echo A B C D | takel 3
A B C
```

### taker

Print last *N* of fields.

```sh
$ echo A B C D | taker 3
B C D
```

### takexl

Print fields from first one to the one which matches given regular expression.

```sh
$ echo QBY JCG FCM PAG TPX BQG UGB | takexl "^P.*$"
QBY JCG FCM PAG
```

### takexr

Print fields from last one to the one which matches given regular expression.

```sh
$ echo QBY JCG FCM PAG TPX BQG UGB | ./takexr "^P.*$"
PAG TPX BQG UGB
```

## Command Line Options

### `fs`
Field separator.

 * Default value is space ` `.
 * Format: `fs=STR`

Example
```
$ echo "/usr/local/var/" | stairl fs=/

/usr
/usr/local
/usr/local/var
/usr/local/var/
```

### `ifs`
Input field separator.
If `fs` is already set, this option is primarily used.

 * Default value is space ` `.
 * Format: `ifs=STR`

### `ofs`
Output field separator.
If `fs` is already set, this option is primarily used.

 * Default value is space ` `.
 * Format: `ofs=STR`

### `eor`
End of record (a.k.a, raw).

 * Default value is new line `\n`.
 * Format: `eor=STR`

### `eos`
End of set.

 * Default value is new line `\n`.
 * Format: `eos=STR`

## Uninstall

```sh
$ make uninstall
```

# External Library
[UnitTest.hs](./test/UnitTest.hs) is distributed on [egison/egison](https://github.com/egison/egison) under the [MIT license](https://github.com/egison/egison/blob/master/LICENSE).

# License
This software is released under the MIT License.
See [LICENSE](./LICENSE)
