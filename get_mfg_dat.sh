#!/bin/bash

download_file() {
  [[ -s mfg.dat ]] && echo "mfg.dat found!" && exit
  ourTemp=$(mktemp)
  [[ -z "${ourTemp}" ]] && echo "mktemp failed" && exit 1
  curl --max-time 10 --ignore-content-length -s -X"GET a/mfg/mfg.dat" http://192.168.1.254:80 -o ${ourTemp}

  if [ $? -eq 7 ]; then
    echo "Failed to connect"
  elif [ -f ${ourTemp} ]; then
    file_size=$(wc -c <"${ourTemp}")
    if [ $file_size -gt 200000 ]; then
      mv ${ourTemp} mfg.dat
      echo "File downloaded successfully!"
    else
      rm ${ourTemp}
      echo "File too small"
    fi
  else
    echo "No file downloaded"
  fi
}

if [ "$1" == "one" ]; then
  download_file
else
  while [[ ! -s mfg.dat ]] 
  do
    $0 "one" &
    sleep 0.05
  done
fi
