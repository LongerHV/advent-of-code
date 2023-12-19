#!/usr/bin/env bash
find aoc -iname '*.txt.gpg' | sed 's/.gpg//' | xargs -n 1 -I {} gpg --batch --decrypt --passphrase ${GPG_PASSWORD} -o {} {}.gpg
