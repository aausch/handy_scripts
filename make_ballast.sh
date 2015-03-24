#!/bin/bash

usage="$(basename "$0") [-h] [-s n] [-f filename] [-c n] [-t target_dir]-- program to calculate the answer to life, the universe and everything

where:
    -h  show this help text
    -s  set the file size in bytes
    -f  filename (created files will follow the pattern $filename[number].safetodelete
    -t  target_dir (directory to create the files in)
    -c  number of files to create

example:
    $ ./make_ballast.sh -f somefile -c 10 -t ~ -s 10000000
writing 10000000 bytes to /Users/aausch/somefile_0.safetodelete
writing 10000000 bytes to /Users/aausch/somefile_1.safetodelete
writing 10000000 bytes to /Users/aausch/somefile_2.safetodelete
writing 10000000 bytes to /Users/aausch/somefile_3.safetodelete
writing 10000000 bytes to /Users/aausch/somefile_4.safetodelete
writing 10000000 bytes to /Users/aausch/somefile_5.safetodelete
writing 10000000 bytes to /Users/aausch/somefile_6.safetodelete
writing 10000000 bytes to /Users/aausch/somefile_7.safetodelete
writing 10000000 bytes to /Users/aausch/somefile_8.safetodelete
writing 10000000 bytes to /Users/aausch/somefile_9.safetodelete
"

if [ $# -eq 0 ]; then
    echo "$usage"
    exit 1
fi

filename=ballast_file
count=0
size=10000000
target_dir=/opt/ballast

while getopts hf:c:s:t: opt; do
  case $opt in
  h) echo "$usage"
      exit
      ;;
  f)
      filename=$OPTARG
      ;;
  c)
      count=$OPTARG
      ;;
  s)
      size=$OPTARG
      ;;
  t)
      target_dir=$OPTARG
      ;;
  :) printf "missing argument for -%s\n" "$OPTARG" >&2
      echo "$usage" >&2
      exit 1
      ;;
  \?) printf "illegal option: -%s\n" "$OPTARG" >&2
      echo "$usage" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND - 1))



COUNTER=0
while [  $COUNTER -lt $count ]; do
     constructed_filename="${target_dir}/${filename}_${COUNTER}.safetodelete"
     echo writing $size bytes to $constructed_filename
     touch $constructed_filename
     truncate -s $size $constructed_filename 
     let COUNTER=COUNTER+1 
     
done
