#!/bin/bash

# Delete duplicate files in OneDrive folder. 
# Choose pattern (comment/uncomment) 
# and run in required folder with command: 
# $ ~/windows-scripts/onedrive-duplicates-folder.sh

ALL_COUNTER=0
PATTERN=' 1'
#PATTERN='-DESKTOP-R25IK4F'
#echo LOOK IN: "$PWD"

recursiverm() { 
local COUNTER=0
for fullpath in *; do
    if [ -d "$fullpath" ]
    then
	 cd -- "$fullpath" && recursiverm 
    fi

case $fullpath in
*$PATTERN*)
  filename="${fullpath##*/}"
  base="${filename%.[^.]*}"
  ext="${filename:${#base} + 1}"
  if [[ -z "$base" && -n "$ext" ]]; then
        base=".$ext"
        ext=""
  fi

  #dub=$(echo "$filename" | sed "s/$PATTERN//g")
  dub=${filename//"$PATTERN"/}

  f1="$filename"
  f2="$dub"

  #echo $f1
  #echo $f2

  if [ -f "$f1" ] && [ -f "$f2" ] ; then
          s1=$(stat -c '%s' "$f1");
          s2=$(stat -c '%s' "$f2");
          if [ "$s1" -eq 58 ] ; then 
		  echo -e '\t'REMOVED: "${PWD}/${f1}" ; 
		  rm "$f1"; 
		  COUNTER=$((COUNTER+1)); 
	  fi
          if [ "$s2" -eq 58 ] ; then 
		  echo -e '\t'REMOVED: "${PWD}/${f2}" ; 
		  rm "$f2"; 
		  mv "$f1" "$f2"; 
		  COUNTER=$((COUNTER+1)); 
	  fi
  fi
;;
esac

done
#cd ..
echo -e ALL IN "$PWD": "$COUNTER"'\n'
((ALL_COUNTER+=COUNTER))
cd ..
}
#cd .; 
recursiverm  

#echo ALL: "$ALL_COUNTER"
echo TOTAL DUPLICATES REMOVED: "$ALL_COUNTER"
