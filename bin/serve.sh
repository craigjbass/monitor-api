#!/usr/bin/env ash

_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$rack" 2>/dev/null
}

trap _term SIGTERM

while nc -z 127.0.0.1 4567; do echo 'waiting for old server to finish...'; sleep 3; done
bundle exec rackup -p 4567 -o 0.0.0.0 &

rack=$!
wait "$rack"

