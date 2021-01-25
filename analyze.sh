#~/bin/sh

if [$1 == '']; then
	echo "ERROR - Enter an image name"
else
	#save docker image as a tar
	docker save $1 -o image.tar

	#extract image contents in a directory
	mkdir image && tar xf image.tar -C image && cd image

	#extract layers' contents
	for layerDir in $(ls -d */); do
		mkdir $layerDir/layer && tar xf $layerDir/layer.tar -C $layerDir/layer
	done

fi
