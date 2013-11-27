#!/bin/sh

#  pngcrush_dir.sh
#  AviarySDKCustomizer
#
#  Created by Jack Sisson on 3/12/13.
#  Copyright (c) 2013 Aviary. All rights reserved.

echo "crushing $png"
`"${1}" -rem allb -brute "$2" temp.png`
mv -f temp.png $png
