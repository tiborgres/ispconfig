#!/bin/bash

# copying all test mails into the proper location
/root/bin/copy_sync.sh

# antispam training
sudo -u amavis /var/spool/amavisd/bin/spam.sh

# cleanup after training
/root/bin/clear_spams.sh
