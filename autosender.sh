#!/bin/bash

#  Blockmove ICX Autosender - claim I-Score automatically and send out free balance
#  Vote for Blockmove :: hx5b97bbec2e555289351806103833a465b7fbbd47
#  Copyright (c) 2019 Blockmove <hello@blockmove.eu>
#  https://github.com/eublockmove/ICX-AutoSender/LICENSE

# EDIT THESE VARIABLES
keystore=keystore.txt #keystore file
password="PASSWORD" #password to keystore
myICXaddress="ICX_ADDRESS" #ICX address where you claim I_Score
sendTo="ICX_ADDRESS" #address where to transfer free balance

#
# DO NOT TOUCH BELOW IF YOU DON'T KNOW WHAT YOU ARE DOING
#
endpoint="https://ctz.solidwallet.io/api/v3" #run by ICON Foundation

#ISCore JSON templates
queryIScore=$(cat <<EOF
{
    "jsonrpc": "2.0",
    "id": 1234,
    "method": "icx_call",
    "params": {
        "to": "cx0000000000000000000000000000000000000000",
        "dataType": "call",
        "data": {
            "method": "queryIScore",
            "params": {
                "address": "$myICXaddress"
            }
        }
    }
}
EOF
)

claimIScore=$(cat <<EOF
{
    "jsonrpc": "2.0",
    "id": 1234,
    "method": "icx_sendTransaction",
    "params": {
	"version": "0x3",
	"to": "cx0000000000000000000000000000000000000000",
	"nid": "0x1",
        "nonce": "0x0",
        "value": "0x0",
        "dataType": "call",
        "data": {
            "method": "claimIScore"
        }
    }
}
EOF
)

#get the amount of claimable ICX
echo $queryIScore > temp.json
response=$(tbears call temp.json -u $endpoint)
rm temp.json
response="${response##*\"estimatedICX\": \"0x}"
response="${response%%\",*}"
response="$(echo $response | tr '[:lower:]' '[:upper:]')" #convert to uppercase so bc can work with it

if (( $(echo "$response < DE0B6B3A7640000" |bc -l) )); then
    echo "Less than 1 ICX to claim ... exiting."
else
    #claim IScore
    echo $claimIScore > temp.json
    tbears sendtx temp.json -u $endpoint -k $keystore -p $password
    rm temp.json
    sleep 5 #wait for TX to go through

    #get available balance
    response="$(tbears balance -u $endpoint $myICXaddress)"
    response="${response##*balance in decimal: }"
    value="$(echo "obase=10;ibase=10; $response-500000000000000000" | bc)" #keep 0.5 ICX for TX fees and such

    # send out all free balance
    tbears transfer -f $myICXaddress -k $keystore -n 0x1 -u $endpoint -p $password $sendTo $value
fi
