#!/bin/bash

if [ "$1" == "" ]; then
	echo "Usage: $0 <release>" >&2
	exit 1
fi

set -ex

rm -rf tmp && mkdir tmp

git clone git@github.com:CanalTP/pdfGenerator.git -b "$1" tmp/pdfGenerator

docker build -t "zibok/pdfgenerator:$1" .
