#!/usr/bin/env sh

set -e

# build
npm run build

cd dist

git init
git add -A
git commit -m 'deploy'

git push -f git@github.com:busheezy/elrs-binding-phrase-to-bytes.git master:gh-pages

cd -