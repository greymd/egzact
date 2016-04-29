#!/bin/bash
TEST_DIR=`dirname $0`
BIN_DIR="${TEST_DIR}/../bin"

setUp(){
	cd $BIN_DIR 2> /dev/null
}

test_addt() {
	result=`echo abc | ./addt.egi ABC`
	assertEquals "ABC
abc" "${result}"

	result=`echo a bc | ./addt.egi ofs=_ eos=--- A`
	assertEquals "A
---
a_bc" "${result}"
}

test_addb() {
	result=`echo abc | ./addb.egi ABC`
	assertEquals "abc
ABC" "${result}"

	result=`echo a bc | ./addb.egi ofs=_ eos=--- A`
	assertEquals "a_bc
---
A" "${result}"
}

test_addl() {
	result=`echo abc | ./addl.egi ABC`
	assertEquals "ABCabc" "${result}"
}

test_addr() {
	result=`echo abc | ./addr.egi ABC`
	assertEquals "abcABC" "${result}"
}

test_comb() {
	result=`echo A B C D | ./comb.egi 2`
	assertEquals "A B
A C
B C
A D
B D
C D" "${result}"

	result=`echo "A B C\n1 2 3" | ./comb.egi eos="---" 2`
	assertEquals "A B
A C
B C
---
1 2
1 3
2 3" "${result}"

	result=`echo A B C D | ./comb.egi 100`
	assertEquals "A B C D" "${result}"

}

test_conv() {
	result=`seq 10 | xargs | ./conv.egi`
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

	result=`seq 10 | ./conv.egi eor=@`
	assertEquals "1@2@3@4@5@6@7@8@9@10@" "${result}"

	result=`seq 10 | xargs -n 5 | ./conv.egi each`
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

	result=`seq 10 | ./conv.egi 2`
	assertEquals "1 2
2 3
3 4
4 5
5 6
6 7
7 8
8 9
9 10" "${result}"

	result=`echo "AA AB AC AD\nBA BB BC BD" | ./conv.egi 3`
	assertEquals "AA AB AC
AB AC AD
AC AD BA
AD BA BB
BA BB BC
BB BC BD" "${result}"

	result=`echo "AA AB AC AD\nBA BB BC BD" | ./conv.egi each 3`
	assertEquals "AA AB AC
AB AC AD
BA BB BC
BB BC BD" "${result}"

	result=`echo "AA AB AC AD\nBA BB BC BD" | ./conv.egi each eos="@@@" 3`
	assertEquals "AA AB AC
AB AC AD
@@@
BA BB BC
BB BC BD" "${result}"
}

test_flat() {
	result=`seq 10 | ./flat.egi`
	assertEquals "1 2 3 4 5 6 7 8 9 10" "${result}"

	result=`seq 10 | tr ' ' '@' | ./flat.egi fs=@`
	assertEquals "1@2@3@4@5@6@7@8@9@10" "${result}"

	result=`seq 10 | ./flat.egi 5 | ./flat.egi each`
	assertEquals "1 2 3 4 5
6 7 8 9 10" "${result}"

	result=`seq 10 | ./flat.egi 2`
	assertEquals "1 2
3 4
5 6
7 8
9 10" "${result}"

	result=`echo "AA AB AC AD\nBA BB BC BD" | ./flat.egi 3`
	assertEquals "AA AB AC
AD BA BB
BC BD" "${result}"

	result=`echo "AA AB AC AD\nBA BB BC BD" | ./flat.egi each 3`
	assertEquals "AA AB AC
AD
BA BB BC
BD" "${result}"

	result=`echo "AA AB AC AD\nBA BB BC BD" | ./flat.egi each eos="@@@" 3`
	assertEquals "AA AB AC
AD
@@@
BA BB BC
BD" "${result}"
}

test_crops() {
	result=`echo "(* (cos α) (cos β))" | ./crops.egi "\(.*\)"`
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
	result=`echo A B C D E | ./cycle.egi`
	assertEquals "A B C D E
B C D E A
C D E A B
D E A B C
E A B C D" "${result}"
}

test_dropl() {
	result=`echo A B C D E F G | ./dropl.egi 3`
	assertEquals "D E F G" "${result}"

	result=`echo A B C D E F G | ./dropl.egi ofs=_ 3`
	assertEquals "D_E_F_G" "${result}"
}

test_dropr() {
	result=`echo A B C D E F G | ./dropr.egi 3`
	assertEquals "A B C D" "${result}"

	result=`echo A B C D E F G | ./dropr.egi ofs=_ 3`
	assertEquals "A_B_C_D" "${result}"
}

test_dupl() {
	result=`echo A B C D E F G | ./dupl.egi 3`
	assertEquals "A B C D E F G
A B C D E F G
A B C D E F G" "${result}"

	result=`echo "A B C\nD E F G" | ./dupl.egi ofs=_ eos=--- 3`
	assertEquals "A_B_C
A_B_C
A_B_C
---
D_E_F_G
D_E_F_G
D_E_F_G" "${result}"
}

test_mirror() {
	result=`echo AAA BBB CCC AAA | ./mirror.egi`
	assertEquals "AAA CCC BBB AAA" "${result}"
}

test_iosides() {
	result=`echo AAA BBB CCC AAA | ./iosides.egi`
	assertEquals "AAA BBB CCC AAA
AAA CCC BBB AAA" "${result}"

	result=`echo "1 2 3 4\nA B C D" | ./iosides.egi eos=---`
	assertEquals "1 2 3 4
4 3 2 1
---
A B C D
D C B A" "${result}"

}

test_nestl() {
	result=`echo AAA BBB CCC | ./nestl.egi "<p>*</p>"`
	assertEquals "<p> <p> <p> AAA </p> BBB </p> CCC </p>" "${result}"
}

test_nestr() {
	result=`echo AAA BBB CCC | ./nestr.egi "<p>*</p>"`
	assertEquals "<p> AAA <p> BBB <p> CCC </p> </p> </p>" "${result}"
}

test_perm() {
	result=`echo A B C D | ./perm.egi 2`
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

	result=`echo A B C D | ./perm.egi 100`
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
	result=`echo A B C D | ./stairl.egi`
	assertEquals "A
A B
A B C
A B C D" "${result}"
}

test_stairr() {
	result=`echo A B C D | ./stairr.egi`
	assertEquals "D
C D
B C D
A B C D" "${result}"
}

test_takel() {
	result=`echo A B C D E F G | ./takel.egi 3`
	assertEquals "A B C" "${result}"

	result=`echo A B C D E F G | ./takel.egi 100`
	assertEquals "A B C D E F G" "${result}"

	result=`echo A B C D E F G | ./takel.egi ofs=_ 3`
	assertEquals "A_B_C" "${result}"
}

test_taker() {
	result=`echo A B C D E F G | ./taker.egi 3`
	assertEquals "E F G" "${result}"

	result=`echo A B C D E F G | ./taker.egi 100`
	assertEquals "A B C D E F G" "${result}"

	result=`echo A B C D E F G | ./taker.egi ofs=_ 3`
	assertEquals "E_F_G" "${result}"
}

test_takelx() {
	result=`echo QBY JCG FCM PAG TPX BQG UGB | ./takelx.egi "^P.*$"`
    assertEquals "QBY JCG FCM PAG" "${result}"

	result=`echo QBY JCG FCM PAG TPX BQG UGB | ./takelx.egi ofs=_ "^P.*$"`
    assertEquals "QBY_JCG_FCM_PAG" "${result}"
}

test_takerx() {
	result=`echo QBY JCG FCM PAG TPX BQG UGB | ./takerx.egi "^P.*$"`
    assertEquals "PAG TPX BQG UGB" "${result}"

	result=`echo QBY JCG FCM PAG TPX BQG UGB | ./takerx.egi fs=" " ofs="*" "^P.*$"`
    assertEquals "PAG*TPX*BQG*UGB" "${result}"
}

test_wrap() {
	result=`echo aaa bbb ccc | ./wrap.egi "<p>*</p>"`
    assertEquals "<p>aaa</p> <p>bbb</p> <p>ccc</p>" "${result}"

	result=`echo aaa bbb ccc | ./wrap.egi ofs=_ "<p>*</p>"`
    assertEquals "<p>aaa</p>_<p>bbb</p>_<p>ccc</p>" "${result}"
}

test_zniq() {
	result=`echo aaa bbb ccc aaa bbb | ./zniq.egi`
    assertEquals "aaa bbb ccc" "${result}"

	result=`echo aaa bbb ccc aaa bbb | ./zniq.egi ofs="*"`
    assertEquals "aaa*bbb*ccc" "${result}"
}

test_zrep() {
	result=`echo 1 2 3 4 5 6 7 8 9 10 | ./zrep.egi "1"`
    assertEquals "1 10" "${result}"

	result=`echo 1 2 3 4 5 6 7 8 9 10 | ./zrep.egi 1`
    assertEquals "1 10" "${result}"

	result=`echo AD1 AD2 AF1 AF2 BD1 BD2 BF1 BF2 CD1 CD2 CF1 CF2 DD1 DD2 DF1 DF2 | ./zrep.egi '^D.*$'`
    assertEquals "DD1 DD2 DF1 DF2" "${result}"

	result=`echo AD1 AD2 AF1 AF2 BD1 BD2 BF1 BF2 CD1 CD2 CF1 CF2 DD1 DD2 DF1 DF2 | ./zrep.egi 'あ'`
    assertEquals "" "${result}"
}

. ${TEST_DIR}/shunit2/source/2.1/src/shunit2
