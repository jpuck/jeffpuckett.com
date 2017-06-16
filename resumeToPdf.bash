#!/bin/bash

set -e

cd $( dirname "${BASH_SOURCE[0]}" )

timestamp="$(jq --raw-output '.resume | keys | .[]' manifest.json)"

wkhtmltopdf --disable-javascript docs/resume/index.html "docs/resume/cv.$timestamp.pdf"
