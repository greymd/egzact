#!/bin/bash
TEST_DIR=`dirname $0`
BIN_DIR="${TEST_DIR}/../bin"

setUp(){
	cd $BIN_DIR 2> /dev/null
}

test_takel() {
	result=`echo A B C D E F G | ./takel.egi 3`
	assertEquals "A B C" "${result}"

	result=`echo A B C D E F G | ./takel.egi ofs=_ 3`
	assertEquals "A_B_C" "${result}"
}

test_taker() {
	result=`echo A B C D E F G | ./taker.egi 3`
	assertEquals "E F G" "${result}"

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
	result=`echo aaa bbb ccc | wrap "<p>*</p>"`
    assertEquals "<p>aaa</p> <p>bbb</p> <p>ccc</p>" "${result}"
}



. ${TEST_DIR}/shunit2/source/2.1/src/shunit2
