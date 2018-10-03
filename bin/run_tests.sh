#!/usr/bin/env ash

set -e

_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$rspec" 2>/dev/null
}

trap _term SIGTERM

while ! psql $DATABASE_URL -c 'SELECT 1'; do
    echo 'Waiting for db'; sleep 3;
done

export NO_LOGS=true

bundle exec guard
