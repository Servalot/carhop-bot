#/bin/bash
FLEETCTL="fleetctl"
which $FLEETCTL
if test $? -eq 1; then
	FLEETCTL="./bin/$FLEETCTL"
fi
$FLEETCTL --tunnel=fleet.servalot.net:443 --strict-host-key-checking=false $@

