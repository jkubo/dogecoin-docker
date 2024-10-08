#!/bin/bash
set -e

if [ -n "${UID+x}" ] && [ "${UID}" != "0" ]; then
  usermod -u "$UID" dogecoin
fi

if [ -n "${GID+x}" ] && [ "${GID}" != "0" ]; then
  groupmod -g "$GID" dogecoin
fi

echo "$0: assuming uid:gid for dogecoin:dogecoin of $(id -u dogecoin):$(id -g dogecoin)"

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for dogecoind"

  set -- dogecoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "dogecoind" ]; then
  mkdir -p "$DOGECOIN_DATA"
  chmod 700 "$DOGECOIN_DATA"
  # Fix permissions for home dir.
  chown -R dogecoin:dogecoin "$(getent passwd dogecoin | cut -d: -f6)"
  # Fix permissions for bitcoin data dir.
  chown -R dogecoin:dogecoin "$DOGECOIN_DATA"

  echo "$0: setting data directory to $DOGECOIN_DATA"

  set -- "$@" -datadir="$DOGECOIN_DATA"
fi

if [ "$1" = "dogecoind" ] || [ "$1" = "dogecoin-cli" ] || [ "$1" = "dogecoin-tx" ]; then
  echo
  exec gosu dogecoin "$@"
fi

chown -R dogecoin:dogecoin "$DOGECOIN_DATA"

echo
exec "$@"