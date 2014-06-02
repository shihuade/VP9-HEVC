
#!/bin/bash


#usage runCheckProfile ${profile}
runCheckProfile()
{

	if [ ! $# -eq 1 ]
	then
		echo  "usage: runCheckProfile \${profile} "
		exit 1
	fi
	
	local ProfileName=$1
	local Flag=""
	let "Flag=0"
	declare -a aOptionList
	aOptionList=(baseline main  high)
	
	for Profile  in ${aOptionList[@]}
	do
		if [  ${ProfileName} =  ${Profile}   ]
		then
			let "Flag=1"
		fi
	done
	
	if [ ${Flag}  -eq 0 ]
	then
		echo "profile name is not right"
		echo "profile option should be set as :  ${aOptionList[@]}"
		exit 1
	fi


}

#usage runCheckProfile ${profile}
runCheckSpeed()
{

	if [ ! $# -eq 1 ]
	then
		echo  "usage runCheckProfile \${profile} "
		exit 1
	fi
	
	local SpeedName=$1
	local Flag=""
	let "Flag=0"
	declare -a aOptionList
	aOptionList=(superfast veryfast fast medium veryslow)
	
	for Speed  in ${aOptionList[@]}
	do
		if [  ${SpeedName} =  ${Speed}   ]
		then
			let "Flag=1"
		fi
	done
	
	if [ ${Flag}  -eq 0 ]
	then
		echo "Speed  name is not right"
		echo "Speed option should be set as :  ${aOptionList[@]}"
		exit 1
	fi


}



#usage
#runTest_x264_BR ${profile}  ${Speed} ${InputYUV} ${OutputFile}  ${BitRate}   ${LogFile}
runTest_x264_BR()
{

	if [ ! $# -eq 6 ]
	then
		echo  "runTest_x264_BR \${profile}  \${Speed} \${InputYUV} \${OutputFile}  \${BitRate}   \${LogFile}"
		return 1
	fi
	echo ""
	echo "X264_BR encoder....."
	echo ""

	local Profile=$1
	local Speed=$2
	local InputYUV=$3
	local OutputFile=$4
	local BitRate=$5
	local LogFile=$6

	runCheckProfile  ${Profile}
	runCheckSpeed    ${Speed}
	
	#get YUV detail info $picW $picH $FPS
	local PicW=""
	local PicH=""
	local FPS=""

	local YUVName=`echo  ${InputYUV} | awk 'BEGIN {FS="/"}  {print $FS}'`
	declare -a aYUVInfo
	aYUVInfo=(`./run_ParseYUVInfo.sh  ${InputYUV}`)
	PicW=${aYUVInfo[0]}
	PicH=${aYUVInfo[1]}
	FPS=${aYUVInfo[2]}

	
	if [ $PicW -eq 0  ]
	then 
		echo "Picture info is not right "
		exit 1
	fi

	if [ $FPS -eq 0 ]
	then 		
		let "FPS=30"
	fi
	
	local EncoderCommand="--profile ${Profile} \
						--preset ${Speed}  	   \
						--psnr                 \
						--bitrate ${BitRate}   \
						--fps  ${FPS}          \
						-o ${OutputFile}       \
						${InputYUV}"
						
	echo ""
	echo ${EncoderCommand}

	./x264 ${EncoderCommand} >${LogFile}

}


Profile=$1
Speed=$2
InputYUV=$3
OutputFile=$4
BitRate=$5
LogFile=$6
runTest_x264_BR  ${Profile}  ${Speed} ${InputYUV} ${OutputFile}  ${BitRate}   ${LogFile}



