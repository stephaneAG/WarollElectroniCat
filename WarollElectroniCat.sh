#!/bin/bash

# the following program generates a Waroll-like composition, but replacing the saturated colors by hexadeciaml jpg glitches ;P

# R: kittos stack -> nice effect ;D

# path of our script
scriptPath=`pwd`

# R: to get a frame from the webcam & store that in the current directory under the name "image_prefix00001.png"
#vlc -I dummy v4l2:///dev/video0 --video-filter scene --no-audio --scene-path "${scriptPath}/" --scene-prefix image_prefix --scene-format png vlc://quit --run-time=1 -Vdummy

# default image is Kitto.jpg
imgToWaroll="${scriptPath}/Kitto.jpg"

# check if we have any argument
if (( $# != 0 ))
then
  # get img argument
  imgToWaroll="$1"
else
  # display error & help
  echo "an image name passed as param is required !"
  exit 1
fi

# TODO: if not a .jpg, convert to jpg WITHOUT LOOSING TRANSPARENCY first

# make 4 copies of it TODO: improve by using the current folder instead
cp $imgToWaroll "${scriptPath}/original1.jpg"
cp $imgToWaroll "${scriptPath}/original2.jpg"
cp $imgToWaroll "${scriptPath}/original3.jpg"
cp $imgToWaroll "${scriptPath}/original4.jpg"

# for the fun, reorient images to form a mozaic ;D
# R: "flop" mirrors horizontally while "flip" mirrors vertically
convert -flop "${scriptPath}/original2.jpg" "${scriptPath}/original2.jpg"
convert -flip "${scriptPath}/original2.jpg" "${scriptPath}/original3.jpg"
convert -flip "${scriptPath}/original1.jpg" "${scriptPath}/original4.jpg"

# glitch each copy ( the commented section is some pseudo-controlled glitches, to ~ even the results )
#jpglitch -a 70 -s 4 -i 31 -o "${scriptPath}/glitched1.png" "${scriptPath}/original1.jpg"
#jpglitch -a 70 -s 4 -i 31 -o "${scriptPath}/glitched2.png" "${scriptPath}/original2.jpg"
#jpglitch -a 70 -s 4 -i 31 -o "${scriptPath}/glitched3.png" "${scriptPath}/original3.jpg"
#jpglitch -a 70 -s 4 -i 31 -o "${scriptPath}/glitched4.png" "${scriptPath}/original4.jpg"

jpglitch -o "${scriptPath}/glitched1.png" "${scriptPath}/original1.jpg"
jpglitch -o "${scriptPath}/glitched2.png" "${scriptPath}/original2.jpg"
jpglitch -o "${scriptPath}/glitched3.png" "${scriptPath}/original3.jpg"
jpglitch -o "${scriptPath}/glitched4.png" "${scriptPath}/original4.jpg"


# delete unglitched copies
rm "${scriptPath}/original1.jpg"
rm "${scriptPath}/original2.jpg"
rm "${scriptPath}/original3.jpg"
rm "${scriptPath}/original4.jpg"

# merge copy 1/2 & 4/3 horizontally
#montage "${scriptPath}/glitched1.png" -geometry +0+0 "${scriptPath}/glitched2.png" "${scriptPath}/glitched_up.png" 
#montage "${scriptPath}/glitched4.png" -geometry +0+0 "${scriptPath}/glitched3.png" "${scriptPath}/glitched_down.png"
# simpler manner to do the above ( we could also do convert +append *.png lonnngImg.png :D )
convert +append "${scriptPath}/glitched1.png" "${scriptPath}/glitched2.png" "${scriptPath}/glitched_up.png"
convert +append "${scriptPath}/glitched4.png" "${scriptPath}/glitched3.png" "${scriptPath}/glitched_down.png"

# delete temp files
rm "${scriptPath}/glitched1.png"
rm "${scriptPath}/glitched2.png"
rm "${scriptPath}/glitched3.png"
rm "${scriptPath}/glitched4.png"

# compute output filename
# get filename without the path
originalFileWithoutPath="${imgToWaroll##*/}"
# ge the path without the filename
originalFilePathOnly="${somePath%/*}"
# get the filename without the extension
originalFileName="${originalFileWithoutPath%%.*}"
# get the extension without the name
originalFileExt="${originalFileWithoutPath#*.}"
# generate the output filepath
outputFilepath="$originalFilePathOnly/$originalFileName.glitched.png"

# merge copy 1/2 & 4/3 vertically ( we could also do convert -append *.png lonnngImg.png :D )
#convert -append "${scriptPath}/glitched_up.png" "${scriptPath}/glitched_down.png" "$outputFilepath"
convert -append "${scriptPath}/glitched_up.png" "${scriptPath}/glitched_down.png" "${scriptPath}/electronicWaroll.png"

# delete temp files
rm "${scriptPath}/glitched_up.png"
rm "${scriptPath}/glitched_down.png"

# if desired, resize, add a background, ..
