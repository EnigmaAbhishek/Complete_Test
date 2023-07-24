#!/bin/bash

# Set common environment variables
export PATH=/home/${USER}/miniconda3/bin:/home/${USER}/miniconda3/condabin:$PATH
export PYTHONPATH=/home/enigma/EnigmaSoftware/EnigmaV2Python/:$PYTHONPATH
export TZ=UTC

# Load server-specific configurations
source "$1"

# Execute common commands
rm -rf /home/enigma/core.*

# Trade-specific commands
for trade in "${TRADE_NAMES[@]}"; do
    sh "/home/enigma/$trade/bash_scripts/start_trade.sh"
    sleep 60
done
