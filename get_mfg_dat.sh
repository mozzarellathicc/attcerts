#!/bin/bash
 
download_file() {
  curl --max-time 10 --ignore-content-length -s -X"GET a/mfg/mfg.dat" http://192.168.1.254:80 -o tmp_mfg.dat
 
  if [ $? -eq 7 ]; then
    echo "Failed to connect, retrying..."
    download_file
  elif [ -f tmp_mfg.dat ]; then
    file_size=$(wc -c <"tmp_mfg.dat")
    if [ $file_size -gt 200000 ]; then
      mv tmp_mfg.dat mfg.dat
      echo "File downloaded successfully!"
    else
      rm tmp_mfg.dat
      echo "File too small, retrying..."
      download_file
    fi
  else
    echo "No file downloaded, retrying..."
    download_file
  fi
}
 
download_file
