#!/bin/bash

git clean -dfx

files=( $(grep '\$VERSION\s*=\s*.[0-9.]+.;' -Erl) )

echo
echo files to update:
grep -Er '\$VERSION\s*=\s*.[0-9.]+.;' --color=always
echo

DEFAULT=$( grep -E '\$VERSION\s*=\s*.[0-9.]+.;' < "${files[0]}" | sed -e s/[^0-9.]//g )

read -ep "new version: " -i $DEFAULT VERSION

sed -i -e "s/= *'$DEFAULT';/= '$VERSION';/" "${files[@]}"

git diff -- "${files[@]}"
