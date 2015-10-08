#/bin/bash
FLEETCTL="fleetctl"
which $FLEETCTL
if test $? -eq 1; then
	FLEETCTL="./bin/$FLEETCTL"
fi
$FLEETCTL --tunnel=$HEROKU_FLEETCTL_TUNNEL --strict-host-key-checking=false $@

