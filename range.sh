#!/bin/bash
## range
## - returns range of numbers
## version 0.1.3b - Darwin range fix
## see sh2/range
##################################################
range() {
 eval-range() {
  #eval echo {${range_start}..${range_end}..${range_incr}}
  eval echo {${range_start}..${range_end}} # Darwin range fix (acatual Bashv3)
 }
 #------------------------------------------------
 test-range() {
  test ${range_start} -ge 0 -a ${range_end} -ge ${range_start} || {
   error "out of range" "${BASHFUNC}" "${LINENO}"
   false
  }
 }
 #------------------------------------------------
 range-list() {
  test-range
  eval-range
 }
 #------------------------------------------------
 _() {
  range-list
 }
 #################################################
 if [ ${#} -eq 3 ]
 then
  range_start=${1}
  range_end=${2}
  range_incr=${3}
 elif [ ${#} -eq 2 ]
 then
  range_start=${1}
  range_end=${2}
  range_incr=1
 elif [ ${#} -eq 1 ] 
 then
  range_start=1
  range_end=${1}
  range_incr=1
 else
  exit 1 # wrong args
 fi
 ################################################
 _
 ################################################
}
##################################################
