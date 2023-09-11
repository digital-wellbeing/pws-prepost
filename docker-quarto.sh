#!/bin/bash
quarto render --output-dir=docs
rm -rf output/*
mv -f docs/* output
echo "Done. Files available on host at ./docker/"