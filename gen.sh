#!/bin/bash

DIR=~/.local/share/mcasset

if ! [ -d "$DIR" ];
then mkdir $DIR
fi

name () {
    echo "Enter a name for the resource pack:"
    read NAME

    NAME=${NAME// /_} # replace spaces with underscores

    PACK=$DIR/$NAME
    if ! [ -d "$PACK" ];
    then mkdir $PACK
    else rm -rf $PACK && mkdir $PACK # danger
    fi

    mkdir $PACK/assets
    mkdir $PACK/assets/minecraft
}

description () {
    echo "Enter a description for the resource pack:"
    read DESC
}

icon () {
    echo "Enter a path to an icon for the resource pack, or leave blank:"
    read ICON

    if [ -z $ICON ]; then
        return
    fi

    if [ -f $ICON ]; then
        cp $ICON $DIR"/"$NAME"/pack.png"
        mogrify -resize 128x128! $DIR"/"$NAME"/pack.png"
        echo "Icon added!"
    else
        echo "That file does not exist!"
        icon
    fi
}

format () {
    echo "Enter pack format! (1-9, or 0 for default)"
    read FORMAT

    # black magic fuckery
    re='^[0-9]+$'
    if ! [[ $FORMAT =~ $re ]]; then
    echo "Invalid argument: $format (1-9, or 0 for default)"
    format
    fi
}

mcmeta () {

    if [ $FORMAT == "0"]; then
    FORMAT=9

    if [ -z $DESC ]; then
    DESC="A very cool resource pack."

    # trying to fit the pack.mcmeta into an echo command is so god-awful
    echo "
{
  \"pack\": {
    \"pack_format\": $FORMAT,
    \"description\": \"$DESC\"
  }
}" > $PACK/pack.mcmeta
}

# 20 questions
name
description
icon
format
mcmeta