#!/bin/bash

import configparser
import os


# Read the config file
config_parser = configparser.ConfigParser()
config_parser.read("config.ini")

# Get the trade name and account name from the config file
trade_name = config_parser["TRADE"]["name"]
account_name = config_parser["TRADE"]["account"]

#Check if the trade date is empty
if not config_parser["TRADE"]["date"]:
print("TRADE_DATE EMPTY")
exit(1)

Get the current time
hour = int(os.popen("TZ=America/Chicago date +%H").read())

If it is after 4pm or it is a weekend, then set the trade date to the next day
if hour >= 16 or os.popen("TZ=America/Chicago date +%u").read() == "7":
trade_date = os.popen("TZ=America/Chicago date -d '+1 day' +%Y%m%d").read()

Check if the lock file exists
lock_file = os.path.join(config_parser["trade_path"], "live_{}_start.lock".format(trade_name))
if os.path.exists(lock_file):
print("LOCK_FILE exists. Another process has started trade")
exit(1)

Create the lock file
open(lock_file, "w").close()

Start the trade
print("Starting trade ... with trade date {}".format(trade_date))
nohup bash -c '/home/{}/bin/{}live{} {}'.format(os.environ["USER"], config_parser["exchange"]["name"], trade_name, config_parser["strategy"]["path"]) &

Copy the configs from git to live
print("Copying configs from git to live...")
os.system("bash {}/../bash_scripts/copy_configs_from_git.sh".format(config_parser["trade_path"]))

Copy the configs from live into git
print("Copying configs from live into git ...")
os.system("bash {}/../bash_scripts/copy_configs_from_prod_to_git.sh {}".format(config_parser["trade_path"], trade_date))