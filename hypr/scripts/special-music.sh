#! /usr/bin/env python

first_greeting="Nice to meet you!"
later_greeting="How are you?"
greeting_occasion=""

if [ -z $greeting_occasion  ]; then
    echo $first_greeting
else
    echo $later_greeting
fi
