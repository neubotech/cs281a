#!/bin/bash
# 
# this script make 10 samples per video and 10 frames per sample

# filename="v_ApplyEyeMakeup_g15_c05.avi"

outDIR="./Pictures"
if [ ! -d "$outDIR" ]; then
    mkdir $outDIR
fi

num_samples=10;
num_frames=11;

timer_start=$SECONDS

for filename in ./*.avi
do
duration=$(ffmpeg -i $filename 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print (3600*A[1] + 60*A[2] + B[1] ) }')

interval=`echo $duration / $num_samples | bc -l`
last=`echo $duration - $interval | bc -l`

echo "duration: $duration"
echo "interval: $interval"

time=0.0;

for (( i=1; i<=$num_samples; i++ ))
do
    echo "i: $i"
    echo "time: $time"
    total=`echo $time *1000 | bc`;
    fraction=`echo $total % 1000 | bc`;
    sec=`echo $total / 1000 % 60| bc `;
    min=`echo $total / 1000 / 60 % 60 | bc`;
    hrs=`echo $total / 1000 / 3600 | bc`;
    timestamp=$(printf "%02d:%02d:%02d[.%03d]" $hrs $min $sec $fraction)
    echo $timestamp

    # echo $i
    imagefile="${outDIR}/${filename%.*}_${i}_"
    # echo $imagefile

    # ffmpeg -loglevel debug -ss $timestamp -i $filename  -vframes $num_frames $imagefile%d.jpg
    ffmpeg -loglevel fatal -ss $timestamp -i $filename  -vframes $num_frames $imagefile%d.jpg
    
    time=`echo $time + $interval | bc -l`
    #wait for sometime
    #perl -MTime::HiRes -e 'Time::HiRes::usleep 5000'
done

echo "seconds since start: $(( SECONDS - timer_start))"
done
