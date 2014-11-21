#!/usr/bin/env sh
# 
# this script make 10 samples per video and 10 frames per sample

# filename="v_ApplyEyeMakeup_g15_c05.avi"

outDIR="./Pictures"
if [ ! -d "$outDIR" ]; then
    mkdir $outDIR
fi

num_samples=10;
last=`echo $num_samples - 1`;
num_frames=11;

timer_start=$SECONDS

for filename in ./*.avi
do
duration=$(ffmpeg -i $filename 2>&1 | grep "Duration"| cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print (3600*A[1] + 60*A[2] + B[1]) }')

interval=`echo $duration / $num_samples | bc -l`
last=`echo $duration - $interval | bc -l`

# echo $duration
# echo $interval

time=0.0;

for i in `seq 0 $last`
do
   # echo $time
   # echo $i
    imagefile="${outDIR}/${filename%.*}_${i}_"
   # echo $imagefile
    
    ffmpeg -loglevel fatal  -i $filename -ss $time -vframes $num_frames $imagefile%d.jpg
    #ffmpeg -loglevel debug  -i $filename -ss $time -vframes $num_frames $imagefile%d.jpg
    
    time=`echo $time + $interval | bc -l`
done

echo "seconds since start: $(( SECONDS - timer_start))"
done
