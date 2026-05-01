#!/bin/bash
set -euo pipefail

## pre process
mkdir -p ./build-resources/tmp
rm -rf ./build-resources/tmp/*
trap 'rm -rf ./build-resources/tmp' EXIT

## get
source ./build-resources/consts.sh
curl -Lo ./build-resources/tmp/cards.json "$YGOPRODECK_API"
curl -Lo ./build-resources/tmp/master.zip "$YAML_YUGI_ZIP_PATH"
unzip ./build-resources/tmp/master.zip $YAML_YUGI_CARDS_DIR -d ./build-resources/tmp

## load
duckdb < ./build-resources/queries/export-cards.sql
duckdb < ./build-resources/queries/export-yaml-yugi.sql

## join
duckdb < ./build-resources/queries/export-dataset.sql
