#!/usr/bin/env bash
find data -iname '*.txt.gpg' | sed 's/.gpg//' | xargs -n 1 -I {} gpg --batch --decrypt --passphrase "${GPG_PASSWORD}" -o {} {}.gpg
