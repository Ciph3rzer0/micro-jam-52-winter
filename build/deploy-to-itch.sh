#!/bin/bash

# Zip the webexport contents
cd ../webexport
zip -r boxesgame.zip .
cd ..

# Push to itch.io
butler push webexport/boxesgame.zip akatona/boxes-for-the-big-man:web --userversion-file VERSION