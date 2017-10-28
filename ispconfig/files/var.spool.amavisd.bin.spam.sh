#!/bin/bash

#DIR=$HOME/tmp-learning
HOME=/var/spool/amavisd

cd $HOME

# DSPAM
/usr/bin/dspam_train amavis $HOME/spam $HOME/nospam

# SpamAssassin
/usr/bin/sa-learn --progress --ham $HOME/nospam/
/usr/bin/sa-learn --progress --spam $HOME/spam/

# CRM114
for i in `ls $HOME/nospam/`; do $HOME/.crm114/mailreaver.crm -u $HOME/.crm114 --good < $HOME/nospam/$i; done
for i in `ls $HOME/spam/`; do $HOME/.crm114/mailreaver.crm -u $HOME/.crm114 --spam < $HOME/spam/$i; done

# Bogofilter
/usr/bin/bogofilter -s -B $HOME/spam/
/usr/bin/bogofilter -n -B $HOME/nospam/
