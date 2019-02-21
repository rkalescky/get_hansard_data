#!/bin/bash

function format_number {
  printf %04d $((10#${1}))
}

function get_files {
  directory=${1}
  n_max=${2}
  s=${3}
  for n in $(seq 1 ${n_max})
  do
    for p in {0..2}
    do
      for x in "" "_a" "_b" "_c"
        do
          base_url="http://www.hansard-archive.parliament.uk/${directory}"
          file_name="S${s}V$(format_number ${n})P${p}${x}.zip"
          url="${base_url}/${file_name}"
          wget -q -nc ${url}
          if file ${file_name} | grep -q "HTML"; then
            rm ${file_name}
          fi
      done
    done
  done  
}

for series in "Parliamentary_Debates_Vol_1_(1803)_to_Vol_41_(Feb_1820) 41 1" \
  "Parliamentary_Debates,_New_Series_Vol_1_(April_1820)_to_Vol_25_(July_1830) 24 2" \
  "Parliamentary_Debates_(3rd_Series)_Vol_1_(Oct_1830)_to_Vol_356_(August_1891) 356 3" \
  "Parliamentary_Debates_(4th_Series)_Vol_1_(February_1892)_to_Vol_199_(December_1908) 199 4" \
  "Official_Report,_House_of_Commons_(5th_Series)_Vol_1_(Jan_1909)_to_Vol_1000_(March_1981) 1000 5C" \
  "The_Official_Report,_House_of_Lords_(5th_Series)_Vol_1_(Jan_1909)_to_2004 670 5L" \
  "The_Official_Report,_House_of_Commons_(6th_Series)_Vol_1_(March_1981)_to_2004 424 6C"
do
  directory=$(echo ${series} | cut -d' ' -f1)
  n_max=$(echo ${series} | cut -d' ' -f2)
  s=$(echo ${series} | cut -d' ' -f3)
  get_files ${directory} ${n_max} ${s}
done
 
