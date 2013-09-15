#!/bin/bash

SCREEN_SHOT_CMD="wkhtmltoimage-amd64 --use-xserver "
CONVERT_CMD=/usr/bin/convert

SIZE=300x
URL=$1
OUTPUT_FILE=$2
TMP_FILE=/tmp/$$_`basename $OUTPUT_FILE`

$SCREEN_SHOT_CMD $URL $TMP_FILE 
$CONVERT_CMD -resize $SIZE $TMP_FILE $OUTPUT_FILE
rm $TMP_FILE

