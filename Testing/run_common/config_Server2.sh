#!/bin/bash

# Server2 specific environment variables
export EXCHANGE_NAME=CME
export BULK_CANCEL_SCRIPT_PATH=/home/infra/prod/scripts/bulkcancel_ilink3.sh
export LD_LIBRARY_PATH=~/EnigmaSoftware/ThirdParty/icu/lib/:~/EnigmaSoftware/ThirdParty/xercesc/lib/:$LD_LIBRARY_PATH

# Server2 specific trade names
TRADE_NAMES=(
    "live_trade1"
    "live_trade2"
    "live_trade3"
)
