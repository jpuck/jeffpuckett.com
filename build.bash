#!/bin/bash

set -e

[[ "$1" == "prod" ]] && {
    export NODE_ENV=production
}

cd $( dirname "${BASH_SOURCE[0]}" )

ruby ruby/github-markup.rb

npm run webpack

filename="$(jq --raw-output '.resume.file' manifest.json)"

wkhtmltopdf --disable-javascript docs/resume/index.html "docs/resume/$filename"
