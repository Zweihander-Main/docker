#!/bin/bash

exit $(curl -s https://api.github.com/repos/ankicommunity/anki-sync-server/commits | jq -r "((now - (.[0].commit.author.date | fromdateiso8601) )  / (60*60*24)  | trunc)")
