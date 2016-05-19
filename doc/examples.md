# egzact examples

## Enumerate all the possible parent domains from the sub domain.

```bash
$ echo hoge.huga.pre.cure.example.com | stairr fs=.
com
example.com
cure.example.com
pre.cure.example.com
huga.pre.cure.example.com
hoge.huga.pre.cure.example.com
```

## Enumerate all the possible parent directories from the sub directory.

```bash
$ pwd | stairl fs=/
/usr
/usr/local
/usr/local/bin
```

## Enumerate all the possible FQDN

```bash
$ echo aaa.bbb.ccc.example.com/a/b/c/d | stairr fs=. | stairl fs=/
com
com/a
com/a/b
com/a/b/c
com/a/b/c/d
example.com
example.com/a
example.com/a/b
example.com/a/b/c
example.com/a/b/c/d
ccc.example.com
ccc.example.com/a
ccc.example.com/a/b
ccc.example.com/a/b/c
ccc.example.com/a/b/c/d
bbb.ccc.example.com
bbb.ccc.example.com/a
bbb.ccc.example.com/a/b
bbb.ccc.example.com/a/b/c
bbb.ccc.example.com/a/b/c/d
aaa.bbb.ccc.example.com
aaa.bbb.ccc.example.com/a
aaa.bbb.ccc.example.com/a/b
aaa.bbb.ccc.example.com/a/b/c
aaa.bbb.ccc.example.com/a/b/c/d
```

## Enumerate all the `that ... that` parts from [the complicated sequence](https://en.wikipedia.org/wiki/That_that_is_is_that_that_is_not_is_not_is_that_it_it_is) .

``stairl | stairr`` generates all the subsets from the input.

```bash
$ echo "That that is is that that is not is not is that it it is" | stairl | stairr | grep -o "that.*that" | sort | uniq
that is is that
that is is that that
that is is that that is not is not is that
that is not is not is that
that that
that that is not is not is that
```

## Split the file into 17 indivisual files.

```sh
$ seq $(awk 'END{print NR}' mytext) | slit 17 | awk '{print "sed -n "$1","$NF"p mytext > mytext."NR}'
sed -n 1,2p mytext > mytext.1
sed -n 3,4p mytext > mytext.2
sed -n 5,6p mytext > mytext.3
sed -n 7,8p mytext > mytext.4
sed -n 9,10p mytext > mytext.5
sed -n 11,12p mytext > mytext.6
sed -n 13,14p mytext > mytext.7
sed -n 15,15p mytext > mytext.8
sed -n 16,16p mytext > mytext.9
sed -n 17,17p mytext > mytext.10
sed -n 18,18p mytext > mytext.11
sed -n 19,19p mytext > mytext.12
sed -n 20,20p mytext > mytext.13
sed -n 21,21p mytext > mytext.14
sed -n 22,22p mytext > mytext.15
sed -n 23,23p mytext > mytext.16
sed -n 24,24p mytext > mytext.17

# Execute
$ seq $(awk 'END{print NR}' mytext) | slit 17 | awk '{print "sed -n "$1","$NF"p mytext > mytext."NR}' | sh
```

## Generate [Bi-gram](https://en.wikipedia.org/wiki/N-gram) from the poem.

```bash
$ echo "If a man understands a poem, he shall have troubles." | conv 2
If a
a man
man understands
understands a
a poem,
poem, he
he shall
shall have
have troubles.
```

## Create a zip file nested 100 times.

```bash
$ echo file {1..100}.zip | conv 2 | mirror | addl "zip "
zip 1.zip file
zip 2.zip 1.zip
zip 3.zip 2.zip
zip 4.zip 3.zip
zip 5.zip 4.zip
zip 6.zip 5.zip
zip 7.zip 6.zip
zip 8.zip 7.zip
zip 9.zip 8.zip
zip 10.zip 9.zip
...

# Execute
$ echo file {1..100}.zip | conv 2 | mirror | addl "zip " | sh

$ unzip -Z -2 100.zip
99.zip
```

## Calculate the approximation of Napier's Constant

```bash
$ seq 10 | flat | stairl ofs="*" | flat | wrap ofs="+" '1/(*)' | addl "1+" | bc -l
2.71828180114638447967
```

## Calculate the approximation of PI

```bash
$ seq 1 2 50 | nl | awk '$1=$1"^2/"' | addr '+' | mirror | flat | addr ' 1' | nestr '(*)' | wrap ifs="_" '(4/ *)' | bc -l
3.14159265358979323651
```

## Generate too nexted DOM element

```bash
$ echo {1..10} | nestr "<p>*</p>"
<p> 1 <p> 2 <p> 3 <p> 4 <p> 5 <p> 6 <p> 7 <p> 8 <p> 9 <p> 10 </p> </p> </p> </p> </p> </p> </p> </p> </p> </p>
```

## Generate too nexted JSON element

`jq` command is necessary.

```bash
$ echo A B C D E F | wrap '"*":' | addr "\"G\"" | nestr "{*}" | jq .
{
  "A": {
    "B": {
      "C": {
        "D": {
          "E": {
            "F": "G"
          }
        }
      }
    }
  }
}
```

## Easily create table element.

```
$ COL=3

$ echo A B C D E F G H | wrap '<td>*</td>' | flat $COL | wrap fs=_ '<tr>*</tr>' | addt '<table border=1>' | addb '</table>'
<table border=1>
<tr><td>A</td> <td>B</td> <td>C</td></tr>
<tr><td>D</td> <td>E</td> <td>F</td></tr>
<tr><td>G</td> <td>H</td></tr>
</table>
```
