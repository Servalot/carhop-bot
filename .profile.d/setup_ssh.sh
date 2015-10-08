# file: .profile.d/ssh-setup.sh

#!/bin/bash
echo $0: creating public and private key files

# Create the .ssh directory
mkdir -p ${HOME}/.ssh
chmod 700 ${HOME}/.ssh
cp bin/core-os.pem ${HOME}/.ssh/id_rsa
eval "$(ssh-agent)"
ssh-add
