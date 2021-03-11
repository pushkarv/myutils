#!/bin/sh
while getopts ":i:t:" o; do
    case "${o}" in
        i)
            i=${OPTARG}
            ;;
        t)
            t=${OPTARG}
            ;;
        *)
            echo 'Usage: analyze.sh -i <image name> -t <term to grep>'
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${i}" ] || [ -z "${t}" ]; then
            echo 'Usage: analyze.sh -i <image name> -t <term to grep>'
else
	#save docker image as a tar
	echo "Saving docker image as tar"
	docker save ${i} -o image.tar
	
	rm -rf image
	echo "Deleting existing image directory"
	#extract image contents in a directory
	echo "Making image directory and extracting contents"
	mkdir image && tar xf image.tar -C image && cd image

	#extract layers' contents
	echo "Extracting layer contents"
	for layerDir in $(ls -d */); do
		mkdir $layerDir/layer && tar xf $layerDir/layer.tar -C $layerDir/layer
	done

	echo "Searching for ${t}"
	grep -rni -e ${t}

fi
