
#!/bin/bash


#usage  runGetPerformanceInfo_X264   ${PerformanceLogFile}
runGetPerformanceInfo_X264()
{

	if [ ! $# -eq 1 ]
	then
		echo "usage: runGetPerformanceInfo_X264 \${PerformanceLogFile}"
		return 1
	fi

	local PerformanceLogFile=$1

	local PSNROverAll=""
	local PSNRAverage=""
	local PSNRY=""
	local PSNRU=""
	local PSNRV=""
	
	local BitRate=""
	local FPS=""

	while read line
	do 

		if [[ $line =~ "x264 [info]: PSNR Mean"  ]]
		then
			#x264 [info]: PSNR Mean Y:33.130 U:42.274 V:42.362 Avg:34.622 Global:34.371 kb/s:192.24
			PSNRY=`echo $line | awk 'BEGIN {FS="Y:"} {print $2}'` 
			PSNRY=`echo $PSNRY | awk 'BEGIN {FS="U:"} {print $1}'` 

			PSNRU=`echo $line | awk 'BEGIN {FS="U:"} {print $2}'` 
			PSNRU=`echo $PSNRU | awk 'BEGIN {FS="V:"} {print $1}'` 

			PSNRV=`echo $line | awk 'BEGIN {FS="V:"} {print $2}'` 
			PSNRV=`echo $PSNRV | awk 'BEGIN {FS="Avg:"} {print $1}'`

			PSNRAverage=`echo $line | awk 'BEGIN {FS="Avg:"} {print $2}'` 
			PSNRAverage=`echo $PSNRAverage | awk 'BEGIN {FS="Global:"} {print $1}'`
			
			PSNROverAll=`echo $line | awk 'BEGIN {FS="Global:"} {print $2}'` 
			PSNROverAll=`echo $PSNROverAll | awk 'BEGIN {FS="kb/s:"} {print $1}'`	
			
			BitRate=`echo $line | awk 'BEGIN {FS="kb/s:"} {print $2}'`   # 599.6 fps: 12.000

		fi

		#encoded 299 frames, 999.75 fps, 192.24 kb/s		
		if [[  "$line" =~ ^encoded  ]]
		then
			FPS=`echo $line | awk 'BEGIN {FS="frames,"} {print $2}'` 
			FPS=`echo $FPS | awk 'BEGIN {FS="fps"} {print $1}'`	
		fi

	done <${PerformanceLogFile}

	echo "${BitRate},${PSNRY},${PSNRU},${PSNRV},${FPS} " 
	      

}

PerformanceLogFile=$1
runGetPerformanceInfo_X264  ${PerformanceLogFile}



