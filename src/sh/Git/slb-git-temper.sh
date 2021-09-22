#!/bin/bash
# Script to save supermodule and it´s submodules
# Remarks:
#   If we don't have a file, start it with nothing;
#   If there is no param, read the value from the file, otherwise read from the param.
#   Save for next time

if [ ! -f "/tmp/TEMPERVAR.dat" ] ; then VALUE=""; fi;
if [ -z "$1" ]; then VALUE=`cat /tmp/TEMPERVAR.dat`; else VALUE=${1}; fi
echo "${VALUE}" > /tmp/TEMPERVAR.dat