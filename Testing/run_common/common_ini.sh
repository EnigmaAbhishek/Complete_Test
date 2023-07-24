#!/bin/bash

# Set common environment variables
export PATH=/home/${USER}/miniconda3/bin:/home/${USER}/miniconda3/condabin:$PATH
export PYTHONPATH=/home/enigma/EnigmaSoftware/EnigmaV2Python/:$PYTHONPATH
export TZ=UTC

# Load server-specific configurations
config_file="$1"

# Execute the script using Python
python3 <<EOF
from configparser import ConfigParser
import os

# Read the INI file
config = ConfigParser()
config.read("$config_file")

# Extract server-specific configurations
server_config = config["Server"]
for key, value in server_config.items():
    os.environ[key] = value

# Execute common commands
os.system("rm -rf /home/enigma/core.*")

# Extract trade-specific commands
trades_config = config["Trades"]
trade_names = trades_config.get("TRADE_NAMES", "").split(",")
trade_names = [t.strip() for t in trade_names if t.strip()]
for trade_name in trade_names:
    os.system(f"sh /home/enigma/{trade_name}/bash_scripts/start_trade.sh")
    os.system("sleep 60")
EOF
