# file: .profile.d/ssh-setup.sh

#!/bin/bash
echo $0: creating public and private key files

# Create the .ssh directory
mkdir -p ${HOME}/.ssh
chmod 700 ${HOME}/.ssh
echo "${HEROKU_PRIVATE_KEY}" > ${HOME}/.ssh/id_rsa
chmod 600 ${HOME}/.ssh/id_rsa
eval "$(ssh-agent)"
ssh-add
