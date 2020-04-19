#!/bin/bash
TEST_DIR=$(dirname "$0")
BIN_DIR="${TEST_DIR}/../bin"

setUp(){
	cd "$BIN_DIR" 2> /dev/null || exit 1
}

test_addt() {
	result=$(echo abc | egison ./addt.egi -- ABC)
	assertEquals "ABC
abc" "${result}"

	result=$(echo a bc | egison ./addt.egi -- ofs=_ eos=--- A)
	assertEquals "A
---
a_bc" "${result}"
}

test_addb() {
	result=$(echo abc | egison ./addb.egi -- ABC)
	assertEquals "abc
ABC" "${result}"

	result=$(echo a bc | egison ./addb.egi -- ofs=_ eos=--- A)
	assertEquals "a_bc
---
A" "${result}"
}

test_addl() {
	result=$(echo abc | egison ./addl.egi -- ABC)
	assertEquals "ABCabc" "${result}"
}

test_addr() {
	result=$(echo abc | egison ./addr.egi -- ABC)
	assertEquals "abcABC" "${result}"
}

test_comb() {
	result=$(echo A B C D | egison ./comb.egi -- 2)
	assertEquals "A B
A C
B C
A D
B D
C D" "${result}"

	result=$(printf "A B C\n1 2 3" | egison ./comb.egi -- eos="---" 2)
	assertEquals "A B
A C
B C
---
1 2
1 3
2 3" "${result}"

	result=$(echo A B C D | egison ./comb.egi -- 100)
	assertEquals "A B C D" "${result}"

}

test_conv() {
	result=$(seq 10 | xargs | egison ./conv.egi)
	assertEquals "1
2
3
4
5
6
7
8
9
10" "${result}"

	result=$(seq 10 | egison ./conv.egi -- eor=@)
	assertEquals "1@2@3@4@5@6@7@8@9@10@" "${result}"

	result=$(seq 10 | xargs -n 5 | egison ./conv.egi -- each)
	assertEquals "1
2
3
4
5
6
7
8
9
10" "${result}"

	result=$(seq 10 | egison ./conv.egi -- 2)
	assertEquals "1 2
2 3
3 4
4 5
5 6
6 7
7 8
8 9
9 10" "${result}"

	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./conv.egi -- 3)
	assertEquals "AA AB AC
AB AC AD
AC AD BA
AD BA BB
BA BB BC
BB BC BD" "${result}"

	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./conv.egi -- ofs='"' 3)
	assertEquals 'AA"AB"AC
AB"AC"AD
AC"AD"BA
AD"BA"BB
BA"BB"BC
BB"BC"BD' "${result}"

	result=$(echo 'AA"AB"AC"AD"BA"BB"BC"BD' | egison ./conv.egi -- ifs="\"" ofs="\"\"" 3)
	assertEquals 'AA""AB""AC
AB""AC""AD
AC""AD""BA
AD""BA""BB
BA""BB""BC
BB""BC""BD' "${result}"

	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./conv.egi -- each 3)
	assertEquals "AA AB AC
AB AC AD
BA BB BC
BB BC BD" "${result}"

	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./conv.egi -- each eos="@@@" 3)
	assertEquals "AA AB AC
AB AC AD
@@@
BA BB BC
BB BC BD" "${result}"
}

test_flat() {
	result=$(seq 10 | egison ./flat.egi)
	assertEquals "1 2 3 4 5 6 7 8 9 10" "${result}"

	result=$(seq 10 | tr ' ' '@' | egison ./flat.egi -- fs=@)
	assertEquals "1@2@3@4@5@6@7@8@9@10" "${result}"

	result=$(seq 10 | egison ./flat.egi -- 5 | egison ./flat.egi each)
	assertEquals "1 2 3 4 5
6 7 8 9 10" "${result}"

	result=$(seq 10 | egison ./flat.egi -- 2)
	assertEquals "1 2
3 4
5 6
7 8
9 10" "${result}"

# 	result=$(seq 10 | egison ./flat.egi -- ofs='"\' 2)
# 	assertEquals '1"\2
# 3"\4
# 5"\6
# 7"\8
# 9"\10' "${result}"

	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./flat.egi -- 3)
	assertEquals "AA AB AC
AD BA BB
BC BD" "${result}"

	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./flat.egi -- each 3)
	assertEquals "AA AB AC
AD
BA BB BC
BD" "${result}"

	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./flat.egi -- each eos="@@@" 3)
	assertEquals "AA AB AC
AD
@@@
BA BB BC
BD" "${result}"

# 	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./flat.egi -- each eos='\' 3)
# 	assertEquals 'AA AB AC
# AD
# \
# BA BB BC
# BD' "${result}"
}

test_slit() {
	result=$(seq 10 | egison ./slit.egi)
	assertEquals "1
2
3
4
5
6
7
8
9
10" "${result}"

	result=$(seq 10 | egison ./slit.egi -- 4)
	assertEquals "1 2 3
4 5 6
7 8
9 10" "${result}"

	result=$(seq 10 | egison ./slit.egi -- ofs="-" 5)
	assertEquals "1-2
3-4
5-6
7-8
9-10" "${result}"

	result=$(seq 10 | egison ./flat.egi -- ofs="@" | egison ./slit.egi fs="@" 2)
	assertEquals "1@2@3@4@5
6@7@8@9@10" "${result}"

	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./slit.egi -- 3)
	assertEquals "AA AB AC
AD BA BB
BC BD" "${result}"

	result=$(printf "AA AB AC AD AE\nBA BB BC BD BE" | egison ./slit.egi -- each 2)
	assertEquals "AA AB AC
AD AE
BA BB BC
BD BE" "${result}"

	result=$(echo "AA AB AC AD" | egison ./slit.egi -- 3)
	assertEquals "AA AB
AC
AD" "${result}"

	result=$(printf "AA AB AC AD AE\nBA BB BC BD BE" | egison ./slit.egi -- each 4)
	assertEquals "AA AB
AC
AD
AE
BA BB
BC
BD
BE" "${result}"

	result=$(printf "AA AB AC AD\nBA BB BC BD" | egison ./slit.egi -- each eos="@@@" 3)
	assertEquals "AA AB
AC
AD
@@@
BA BB
BC
BD" "${result}"

}

test_crops() {
	result=$(echo "(* (cos α) (cos β))" | egison ./crops.egi -- "\(.*\)")
	assertEquals "(* (cos α)
(cos α)
(* (cos α) (cos β)
(cos α) (cos β)
(cos β)
(* (cos α) (cos β))
(cos α) (cos β))
(cos β))" "${result}"
}

test_cycle() {
	result=$(echo A B C D E | egison ./cycle.egi)
	assertEquals "A B C D E
B C D E A
C D E A B
D E A B C
E A B C D" "${result}"
}

test_dropl() {
	result=$(echo A B C D E F G | egison ./dropl.egi -- 3)
	assertEquals "D E F G" "${result}"

	result=$(echo A B C D E F G | egison ./dropl.egi -- ofs=_ 3)
	assertEquals "D_E_F_G" "${result}"
}

test_dropr() {
	result=$(echo A B C D E F G | egison ./dropr.egi -- 3)
	assertEquals "A B C D" "${result}"

	result=$(echo A B C D E F G | egison ./dropr.egi -- ofs=_ 3)
	assertEquals "A_B_C_D" "${result}"
}

test_dupl() {
	result=$(echo A B C D E F G | egison ./dupl.egi -- 3)
	assertEquals "A B C D E F G
A B C D E F G
A B C D E F G" "${result}"

	result=$(printf "A B C\nD E F G" | egison ./dupl.egi -- ofs=_ eos=--- 3)
	assertEquals "A_B_C
A_B_C
A_B_C
---
D_E_F_G
D_E_F_G
D_E_F_G" "${result}"
}

test_mirror() {
	result=$(echo AAA BBB CCC AAA | egison ./mirror.egi)
	assertEquals "AAA CCC BBB AAA" "${result}"
}

test_obrev() {
	result=$(echo AAA BBB CCC AAA | egison ./obrev.egi)
	assertEquals "AAA BBB CCC AAA
AAA CCC BBB AAA" "${result}"

	result=$(printf "1 2 3 4\nA B C D" | egison ./obrev.egi -- eos=---)
	assertEquals "1 2 3 4
4 3 2 1
---
A B C D
D C B A" "${result}"

}

test_nestl() {
	result=$(echo AAA BBB CCC | egison ./nestl.egi -- "<p>*</p>")
	assertEquals "<p> <p> <p> AAA </p> BBB </p> CCC </p>" "${result}"
}

test_nestr() {
	result=$(echo AAA BBB CCC | egison ./nestr.egi -- "<p>*</p>")
	assertEquals "<p> AAA <p> BBB <p> CCC </p> </p> </p>" "${result}"
}

test_perm() {
	result=$(echo A B C D | egison ./perm.egi -- 2)
	assertEquals "A B
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
D C" "${result}"

	result=$(echo A B C D | egison ./perm.egi -- 100)
	assertEquals "A B C D
A B D C
A C B D
B A C D
A C D B
A D B C
B A D C
B C A D
C A B D
A D C B
B C D A
B D A C
C A D B
C B A D
D A B C
B D C A
C B D A
C D A B
D A C B
D B A C
C D B A
D B C A
D C A B
D C B A" "${result}"
}

test_stairl() {
	result=$(echo A B C D | egison ./stairl.egi)
	assertEquals "A
A B
A B C
A B C D" "${result}"
}

test_stairr() {
	result=$(echo A B C D | egison ./stairr.egi)
	assertEquals "D
C D
B C D
A B C D" "${result}"
}

test_sublist() {
	result=$(echo A B C D | egison ./sublist.egi)
	assertEquals "A
A B
B
A B C
B C
C
A B C D
B C D
C D
D" "${result}"
}

test_subset() {
	result=$(echo A B C D | egison ./subset.egi)
	assertEquals "A
B
C
D
A B
A C
B C
A D
B D
C D
A B C
A B D
A C D
B C D
A B C D" "${result}"
}


test_takel() {
	result=$(echo A B C D E F G | egison ./takel.egi -- 3)
	assertEquals "A B C" "${result}"

	result=$(echo A B C D E F G | egison ./takel.egi -- 100)
	assertEquals "A B C D E F G" "${result}"

	result=$(echo A B C D E F G | egison ./takel.egi -- ofs=_ 3)
	assertEquals "A_B_C" "${result}"
}

test_taker() {
	result=$(echo A B C D E F G | egison ./taker.egi -- 3)
	assertEquals "E F G" "${result}"

	result=$(echo A B C D E F G | egison ./taker.egi -- 100)
	assertEquals "A B C D E F G" "${result}"

	result=$(echo A B C D E F G | egison ./taker.egi -- ofs=_ 3)
	assertEquals "E_F_G" "${result}"
}

test_takelx() {
	result=$(echo QBY JCG FCM PAG TPX BQG UGB | egison ./takelx.egi -- "^P.*$")
    assertEquals "QBY JCG FCM PAG" "${result}"

	result=$(echo QBY JCG FCM PAG TPX BQG UGB | egison ./takelx.egi -- ofs=_ "^P.*$")
    assertEquals "QBY_JCG_FCM_PAG" "${result}"
}

test_takerx() {
	result=$(echo QBY JCG FCM PAG TPX BQG UGB | egison ./takerx.egi -- "^P.*$")
    assertEquals "PAG TPX BQG UGB" "${result}"

	result=$(echo QBY JCG FCM PAG TPX BQG UGB | egison ./takerx.egi -- fs=" " ofs="*" "^P.*$")
    assertEquals "PAG*TPX*BQG*UGB" "${result}"
}

test_wrap() {
	result=$(echo aaa bbb ccc | egison ./wrap.egi -- "<p>*</p>")
    assertEquals "<p>aaa</p> <p>bbb</p> <p>ccc</p>" "${result}"

	result=$(echo aaa bbb ccc | egison ./wrap.egi -- ofs=_ "<p>*</p>")
    assertEquals "<p>aaa</p>_<p>bbb</p>_<p>ccc</p>" "${result}"
}

test_zniq() {
	result=$(echo aaa bbb ccc aaa bbb | egison ./zniq.egi)
    assertEquals "aaa bbb ccc" "${result}"

	result=$(echo aaa bbb ccc aaa bbb | egison ./zniq.egi -- ofs="*")
    assertEquals "aaa*bbb*ccc" "${result}"
}

test_zrep() {
	result=$(echo 1 2 3 4 5 6 7 8 9 10 | egison ./zrep.egi -- "1")
    assertEquals "1 10" "${result}"

	result=$(echo 1 2 3 4 5 6 7 8 9 10 | egison ./zrep.egi -- 1)
    assertEquals "1 10" "${result}"

	result=$(echo AD1 AD2 AF1 AF2 BD1 BD2 BF1 BF2 CD1 CD2 CF1 CF2 DD1 DD2 DF1 DF2 | egison ./zrep.egi -- '^D.*$')
    assertEquals "DD1 DD2 DF1 DF2" "${result}"

	result=$(echo AD1 AD2 AF1 AF2 BD1 BD2 BF1 BF2 CD1 CD2 CF1 CF2 DD1 DD2 DF1 DF2 | egison ./zrep.egi -- 'あ')
    assertEquals "" "${result}"
}

# shellcheck source=/dev/null
. "${TEST_DIR}/shunit2/source/2.1/src/shunit2"
