#!/bin/bash
## wunderlist.sh
## - wunderlist cl
## version 0.0.1 - initial
##################################################
## aliases
shopt -s expand_aliases
alias commands='
 { local _command ; _command="${1}" ; local args=${@:2} ; }
 test ! "$( declare -f ${FUNCNAME}-${_command} )" && {
  echo "${FUNCNAME} command \"${_command}\" not yet implemented" ;
 true
 } || {
  ${FUNCNAME}-${_command} ${args}
 }
'
##################################################
wl-test() {
 echo testing ... 1>&2
 curl \
  -X GET \
  --url https://a.wunderlist.com/api/v1/lists \
  -H "X-Access-Token: ${WL_AT}" \
  -H "X-Client-ID: ${WL_CID}" \
  --silent
}
#-------------------------------------------------
init() {
 test "${WL_AT}"
 test "${WL_CID}"
}
#-------------------------------------------------
wl() {
 init
 commands
}
##################################################
if [ ! ] 
then
 true
else
 exit 1 # wrong args
fi
##################################################
wl ${@}
##################################################
