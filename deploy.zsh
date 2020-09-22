#!/bin/zsh

rm -rf build/*
bundle exec middleman build --verbose
(cd build; git add --all; git commit -a -m "updating build"; git push)
