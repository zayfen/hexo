#!/bin/env bash

# rm -r themes/next
# git clone https://github.com/theme-next/hexo-theme-next themes/next --depth=1

git submodule foreach --recursize git pull origin master


