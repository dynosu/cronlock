#!/bin/bash
# this script is to prevent a cron from running twice, while still being able to monitor it. 
# usage $0 script/cronname /full/path/to/script/to/execute

#where do we store lockfiles?
LOCKDIR=/tmp/cronlock
#used for naming lockfile
SCRIPTNAME="$1"
#this will capture all input except the first variable, which is the name of the lockfile
SCRIPT2EXECUTE="${@:2}"
LOCKFILE="${LOCKDIR}/$(whoami).${SCRIPTNAME}.lockfile"
if [ -z "${SCRIPT2EXECUTE}" ]; then
  echo "Need some script to execute. "
  echo "usage $0 script/cronname /full/path/to/script/to/execute"
fi

#easier to have a specific dir for it
if [ ! -d "${LOCKDIR}" ]; then
  mkdir ${LOCKDIR}
fi

#need to add monitoring check to see if lockfile still exists. If it exists for longer then X period, alert. 
if [ ! -f "${LOCKFILE}" ]; then
  touch "${LOCKFILE}"
elif [ -f "${LOCKFILE}" ]; then
  #if lockfile exists, then exit
  exit 1 
fi

#lets log when we start. should be handy for the check
STARTDATE=$(date) 
echo "Started ${SCRIPTNAME} at ${STARTDATE}" >"${LOCKFILE}"

#lets do the thing. 
${SCRIPT2EXECUTE}
SCRIPTEXITCODE="$?"
#if script exits with 0, we assume its okay. If not ... then add that to the lockfile and exit. 
if [[ "${SCRIPTEXITCODE}" -ne 0 ]]; then
  SCRIPTERROR="Cron with name: ${SCRIPTNAME} did not exit properly. User: $(whoami) executed: ${SCRIPT2EXECUTE}"
  echo ${SCRIPTERROR} | tee -a "${LOCKFILE}"
  rm ${LOCKFILE}
  exit ${SCRIPTEXITCODE}
elif [[ "${SCRIPTEXITCODE}" -eq 0 ]]; then
  rm ${LOCKFILE}
  exit ${SCRIPTEXITCODE}
fi

