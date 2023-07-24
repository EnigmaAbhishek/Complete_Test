#!/bin/bash

# Load server-specific configuration
CONFIG_FILE="$1"

TRADE_NAME=$(awk -F "=" '/TRADE_NAME = / {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')
ACCOUNT_NAME=$(awk -F "=" '/ACCOUNT_NAME/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')
GIT_NAME=$(awk -F "=" '/GIT_NAME/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')
BASE_PYTHONPATH=$(awk -F "=" '/BASE_PYTHONPATH/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')
EXCHANGE_BIN_PATH=$(awk -F "=" '/EXCHANGE_BIN_PATH/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')
TIMEZONE=$(awk -F "=" '/TIMEZONE/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')
TRADE_HOUR_THRESHOLD=$(awk -F "=" '/TRADE_HOUR_THRESHOLD/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')
TRADE_DAY_THRESHOLD=$(awk -F "=" '/TRADE_DAY_THRESHOLD/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')

export BASE_TRADE_PATH=/home/$USER/live_$TRADE_NAME/config
export BASE_GIT_LIVE_CONFIGS=/home/$USER/EnigmaSoftware/$GIT_NAME/live_$TRADE_NAME/config
export BASE_PYTHONPATH=/home/$USER/EnigmaSoftware/EnigmaV2Python
export EXCHANGE_BIN_PATH=/home/$USER/bin

export LOCK_FILE=$BASE_TRADE_PATH/../live_${TRADE_NAME}_start.lock
echo $LOCK_FILE
HOUR=$(TZ=$TIMEZONE date +%H)
DAY_OF_WEEK=$(TZ=$TIMEZONE date +%u)
export TRADE_DATE=$(TZ=$TIMEZONE date +%Y%m%d)

if [ $HOUR -ge $TRADE_HOUR_THRESHOLD ]; then
    if [ -n "$TRADE_DAY_THRESHOLD" ] && [ $DAY_OF_WEEK -eq $TRADE_DAY_THRESHOLD ]; then
        TRADE_DATE=$(TZ=$TIMEZONE date -d '+1 day' +%Y%m%d)
    else
        TRADE_DATE=$(TZ=$TIMEZONE date -d '+1 day' +%Y%m%d)
    fi
fi

if [ -f "$LOCK_FILE" ]; then
    echo "$LOCK_FILE exists. Another process has started trade"
    exit -1
fi

if [ -z "$TRADE_DATE" ]; then
    echo "TRADE_DATE EMPTY"
    exit -1
fi

echo "Starting trade ... with trade date ${TRADE_DATE}"
touch $LOCK_FILE
nohup bash -c "${EXCHANGE_BIN_PATH}/${EXCHANGE_NAME}_live_${TRADE_NAME} ${BASE_TRADE_PATH}/strategy.xml ${TRADE_DATE};echo 'Removing lock file';rm ${LOCK_FILE}" >> /home/${USER}/script_logs/nohup_${TRADE_NAME}_${TRADE_DATE}.out 2>&1 &

nohup bash -c "taskset -c $MONITOR_CPU_CORE python -u $BASE_PYTHONPATH/trade_operation/trade_monitoring/monitor_trade_binary.py ${TRADE_NAME} live ${TRADE_DATE} ${ACCOUNT_NAME};echo 'Removing lock file';rm ${LOCK_FILE}" >> /home/${USER}/script_logs/nohup_monitor_${TRADE_NAME}_${TRADE_DATE}.out 2>&1 &
echo "Push successful with git"

export REF_FILE=/var/dumps/reference_data/cme/csv/cme.csv

$BASE_PYTHONPATH/trade_operation/ref_file_monitoring/compare_ref_file_diffs.sh $TRADE_NAME $REF_FILE











