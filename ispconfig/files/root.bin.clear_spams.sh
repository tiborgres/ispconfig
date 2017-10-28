#!/bin/bash

# remove DSPAM files
cd /var/lib/dspam/data/a/m/amavis/amavis.sig
# 1. method
rm -f *.sig

# 2. method
for i in `echo 0 1 2 3 4 5 6 7 8 9 a b c d e f`
do
  rm -f ???$i*.sig
done

# 3. (first method again)
rm -f $.sig

# 4. method
for i in *
do
  rm -f $i
done

# remove CRM114 files
DIRS="known_good known_spam texts"
cd /var/spool/amavisd/.crm114/reaver_cache
rm -rf $DIRS
mkdir $DIRS
chown amavis:amavis $DIRS
chmod 755 $DIRS
