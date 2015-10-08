#/bin/bash
eval "$(ssh-agent)"

# Create the .ssh directory
mkdir -p ${HOME}/.ssh
chmod 700 ${HOME}/.ssh
cp bin/core-os.pem ${HOME}/.ssh/id_rsa

exec ./bin/fleetctl --tunnel=fleet.servalot.net:443 --strict-host-key-checking=false $@

