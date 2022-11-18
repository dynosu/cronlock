#!/bin/bash
#
# Created by Leon de Jong
#
# cron lockfile check
#where do we store lockfiles?
LOCKDIR="/tmp/cronlock"
DATENOW=$(date +%s)

#help function
function gethelp {
  printf "%b\n" "% Usage: `basename $0` -h"
  printf "%b\n" "  `basename $0` -c <crit time in seconds>"
  printf "%b\n" "  `basename $0` -f <lockfile to check(relative to ${LOCKDIR})>"
  printf "%b\n" "  if no lockfile is given. Then the entire dir (${LOCKDIR}) will be checked"
  printf "%b\n" "  `basename $0` -h <this help>"
  printf "%b\n" "% Example Usage: `basename $0` -h"
  printf "%b\n" "  `basename $0` -c 120 -f scripts.testlock (.lockfile will be added)"
  exit 1
}
function agecheck() {
  DATECREATED=$(date +%s -r "${1}")
  TIMESINCECREATED=$((${DATENOW}-${DATECREATED}))
  if [ "${TIMESINCECREATED}" -gt "${OPT_CRIT}" ]; then
    CRITLIST+=$(printf "%b\n" "\n$1 has existed for longer then configured ${OPT_CRIT} seconds" )
  fi
}

NUMARGS=$#
if [ $NUMARGS -eq 0 ]; then
  gethelp
fi

# lets fire up the args

#without warning: 
while getopts :c:f:h FLAG; do
  case $FLAG in
    c)  #<crit time in seconds>
      OPT_CRIT=${OPTARG}
      ;;
    f)  #<lockfile to check(relative to ${LOCKDIR})>
      OPT_FILE=${OPTARG}
      ;;
    h)  #show help
      gethelp
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.
if [ -z ${OPT_CRIT} ]; then
  echo "need a value for crit (in seconds)"
  gethelp
  exit 1
fi

#if opt_file isnt given, then check the whole lockdir
#i do this so its possible to set all lockfiles to 1 sla that doesnt call
# and 1 specific 1 that can call.
if [ -z ${OPT_FILE} ]; then
  for file in `ls ${LOCKDIR}/*.lockfile`
    do 
      agecheck ${LOCKDIR}/${file}
    done
elif [ -f "${LOCKDIR}/${OPT_FILE}.lockfile" ]; then
   agecheck ${LOCKDIR}/${OPT_FILE}.lockfile
elif [ ! -f "${LOCKDIR}/${OPT_FILE}.lockfile" ]; then
  printf '%s\n' "lockfile does not exist"
  exit 1
fi

#if critlist is empty, then its all okay
if [ -z "${CRITLIST}" ]; then 
  printf '%s\n' "OK: no lockfiles older then ${OPT_CRIT} seconds found"
  exit 0
#otherwise SOMETHING is broken, and exit with a crit. 
elif [ -n "${CRITLIST}" ]; then
  printf '%s\n' "CRIT: lockfiles found older then ${OPT_CRIT} seconds" 
  printf '%s\n' " ${CRITLIST[*]}"
  exit 2
fi