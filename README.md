# ICX AutoSender
![Blockmove logo](https://i.imgur.com/eMSxYRR.png)

This is a spinoff version of [ICX AutoStaker](https://github.com/eublockmove/ICX-AutoStaker) with goal to claim I_Score automatically and send out all available balance (keeping 0.5 ICX reserve). This is useful mainly for P-Reps to move their rewards away from the P-Rep node to make it less interesting target or to minimize losses if compromised.

## Linux Setup (Ubuntu 18.04)
Install T-Bears and its dependancies:
```
sudo apt update && sudo apt -y upgrade && sudo apt -y install pkg-config python3-pip libsecp256k1-dev && pip3 install tbears
```
Download ICX AutoSender:
```
wget https://raw.githubusercontent.com/eublockmove/ICX-AutoSender/master/autosender.sh
```
Export your keystore from ICONex and copy it to the same directory. Now open autosender.sh and edit variables keystore, password, myICXaddress and sendTo on the top. **Warning: use this only on a secure system! If your keystore in combination with password leaks, you might lose all your ICX!**

You can now execute AutoSender:
```
bash autosender.sh
```
