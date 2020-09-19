#!/bin/zsh

rm -rf build/*
bundle exec middleman build
(cd build; git add --all; git commit -a -m "updating build"; git push)
