#!/bin/bash

git clean -dfx

files=( $(grep '\$VERSION\s*=\s*.[0-9._]+.;' -Erl) )

echo
echo files to update:
grep -Er '\$VERSION\s*=\s*.[0-9._]+.;' --color=always
echo

DEFAULT=$( grep -E '\$VERSION\s*=\s*.[0-9._]+.;' < "${files[0]}" | sed -e s/[^0-9._]//g )

read -ep "new version: " -i $DEFAULT VERSION

sed -i -e "s/= *'$DEFAULT';/= '$VERSION';/" "${files[@]}"

git diff -- "${files[@]}"
