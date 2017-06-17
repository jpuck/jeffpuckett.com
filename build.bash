#!/bin/bash

set -e

[[ "$1" == "prod" ]] && {
    export NODE_ENV=production
}

cd $( dirname "${BASH_SOURCE[0]}" )

ruby ./ruby/github-markup.rb

npm run webpack

rm ./docs/js/jp.cv.js

filename="$(jq --raw-output '.cv.file' manifest.json)"

wkhtmltopdf --disable-javascript ./docs/cv/index.html "./docs/cv/$filename"

php ./php/cachehash.php
