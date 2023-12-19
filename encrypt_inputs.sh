#!/usr/bin/env bash
find aoc -iname '*.txt' | xargs -n 1 gpg --batch --symmetric --passphrase ${GPG_PASSWORD}
