#!/bin/bash
cd ../datafiles/luwrain-windows-nightly/registry/org/luwrain/global-keys/
rm doc.txt 2>nul
for D in *; do
  printf '.'
done
printf '\r'
for D in *; do
  printf '*'
  printf "$D - " >> doc.txt
  grep '"with-control" = "true"' $D/booleans.txt > /dev/null
  if [ $? -ne 1 ]; then
    printf "ctrl" >> doc.txt
  fi
  grep '"with-alt" = "true"' $D/booleans.txt > /dev/null
  if [ $? -ne 1 ]; then
    printf "+alt" >> doc.txt
  fi
  grep '"with-shift" = "true"' $D/booleans.txt > /dev/null
  if [ $? -ne 1 ]; then
    printf "+shift" >> doc.txt
  fi
  printf "+" >> doc.txt
  grep character "$D/strings.txt" | cut -d '=' -f 2 | sed 's/[ \"]//g' >> doc.txt
  grep special "$D/strings.txt" | cut -d '=' -f 2 | sed 's/[ \"]//g' >> doc.txt
  printf "\r\n" >> doc.txt
done
mv doc.txt ../../../../../../tools/
cd ../../../../../../tools/

