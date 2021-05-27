#!/bin/bash

if [ ! $1 ]; then
    echo "Enter knot name and number of images."
    exit 1
fi

echo "Preparing $1..."

if [ $3 ]; then
    name=$3
else
    name=$1
fi

mkdir $name 2>/dev/null

for i in $(seq 1 $2); do
    printf -v num "%02d" $i
    new_name="${name}R${num}.jpg"

    echo "Fetching $new_name"

    wget -q -O ./$name/$new_name "https://www.animatedknots.com/photos/$1/${1}R${i}.jpg"
done

echo "Done fetching, preparing gif..."

ffmpeg -framerate 1 -pattern_type glob -i "$name/*.jpg" -r 15 -vf scale=512:-1 "${name}/${name}.gif"

