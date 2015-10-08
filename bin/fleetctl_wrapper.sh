#/bin/bash
eval "$(ssh-agent)"
ssh-add bin/core-os.pem
fleetctl --tunnel=fleet.servalot.net:443 --strict-host-key-checking=false $@
