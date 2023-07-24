#!/bin/bash

# Server1 specific environment variables
export EXCHANGE_NAME=B3
export BULK_CANCEL_SCRIPT_PATH=/home/infra/shared/bulkcancel.sh
export LD_LIBRARY_PATH=~/EnigmaSoftware/ThirdParty/icu/lib/:~/EnigmaSoftware/ThirdParty/xercesc/lib/:$LD_LIBRARY_PATH

# Server1 specific trade names
TRADE_NAMES=(
    "live_brz_di"
    "live_di_front"
    "live_brz_mid"
    "live_brz_frt2"
    "live_us_ted"
)
