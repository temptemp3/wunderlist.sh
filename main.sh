#!/bin/bash
## wunderlist.sh
## - wunderlist cl
## version 0.0.3 - caching
##################################################
## includes
. $( dirname ${0} )/error.sh true # error handling, show errors
. $( dirname ${0} )/cache.sh # caching
. $( dirname ${0} )/sanitize.sh # sanitization
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
wl-get-lists() {
 url="--url https://a.wunderlist.com/api/v1/lists"
 wl-curl
}
#-------------------------------------------------
wl-get() {
 X="-X GET"
 commands
}
#-------------------------------------------------
wl-curl() {
 test "${X}" 
 test "${url}"
 _() {
 curl \
  ${X} \
  ${url} \
  -H "X-Access-Token: ${WL_AT}" \
  -H "X-Client-ID: ${WL_CID}" \
  --silent \
  --insecure \
  || {
   # CURLE_SSL_CACERT (60)
   # Peer certificate cannot be authenticated with known CA certificates. 
   # see https://curl.haxx.se/libcurl/c/libcurl-errors.html
   error_message="curl error (${?})"
   error-line
   false
  }
 }
 cache \
 "${cache}/${FUNCNAME}-$( sanitize ${X} ${url} )" \
 "_"
}
#-------------------------------------------------
wl-test() {
 echo testing ... 1>&2
 for i in {1..999999}
 do
  wl get lists
 done
}
#-------------------------------------------------
initialized=
wl-init() {
 initialized=true

 test ! -f "$( dirname ${0})/wl-config.sh" || {
  echo reading config file ... 1>&2
  . $( dirname ${0})/wl-config.sh
 }

 test "${WL_AT}" || {
  error_message="missing access token"
  error-line
  false
 }

 test "${WL_CID}" || {
  error_message="missing client id"
  error-line
  false 
 }

}
#-------------------------------------------------
wl() {
 test "${initialized}" || { ${FUNCNAME}-init ; }
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
