export exchange_name=B3
export bulk_cancel_script_path=/home/infra/shared/bulkcancel.sh
export ld_library_path=~/EnigmaSoftware/ThirdParty/icu/lib/:~/EnigmaSoftware/ThirdParty/xercesc/lib/:$LD_LIBRARY_PATH

rm -rf /home/enigma/core.*

sh /home/enigma/live_brz_di/bash_scripts/start_trade.sh
sleep 60
sh /home/enigma/live_di_front/bash_scripts/start_trade.sh
sleep 60
sh /home/enigma/live_brz_mid/bash_scripts/start_trade.sh
sleep 60
sh /home/enigma/live_brz_frt2/bash_scripts/start_trade.sh
sleep 60

