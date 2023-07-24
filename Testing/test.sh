#!/bin/bash

# Load configuration file
CONFIG_FILE="$1"
ALGO_CHECK_ENABLED=$(awk -F "=" '/ALGO_CHECK_ENABLED/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')
CHECK_PATHS=$(awk -F "=" '/CHECK_PATHS/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')
CHECK_ARGS=$(awk -F "=" '/CHECK_ARGS/ {print $2}' "$CONFIG_FILE" | tr -d '[:space:]')


if [ $ALGO_CHECK_ENABLED = true ]; then
    
    echo Bye
    
    IFS="," read -ra CHECK_PATHS_ARRAY <<< "$CHECK_PATHS"
    IFS="," read -ra CHECK_ARGS_ARRAY <<< "$CHECK_ARGS"

    for i in "${!CHECK_PATHS_ARRAY[@]}"; do
        check_path=${CHECK_PATHS_ARRAY[$i]}
        check_args=${CHECK_ARGS_ARRAY[$i]}

    if [ -n "$check_path" ]; then
        echo "Executing check script: $check_path $check_args"
        bash -c "$check_path $check_args"
    else
        echo "No check script specified for ${TRADE_NAME}"
    fi
    done
fi