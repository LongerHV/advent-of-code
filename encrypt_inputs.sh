#!/usr/bin/env bash
find data -iname '*.txt' -print0 | xargs -0 -n 1 gpg --batch --symmetric --passphrase "${GPG_PASSWORD}"
