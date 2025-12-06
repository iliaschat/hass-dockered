#!/bin/sh

# Validate the first argument: must be "up" or "down" to proceed
if { [ "$1" != "up" ] && [ "$1" != "down" ]; }; then
	echo "Usage: ./$0 up|down [sys|tool|hass|full] [basic|extra|full]"
	exit 1
fi

# Initialize opStr with the operation type ("up" or "down")
opStr="$1"
# If the operation is "up", append " -d" for detached mode in docker compose
if [ "$1" = "up" ]; then
	opStr="${opStr} -d"
fi

# Initialize variables
stack=""
profile=""
profileStr=""

# Handle arguments
if [ $# -ge 2 ]; then
	if [ "$2" = "sys" ] || [ "$2" = "tool" ] || [ "$2" = "hass" ] || [ "$2" = "full" ]; then
		stack="$2"
		if [ $# -eq 3 ]; then
			if [ "$3" = "basic" ] || [ "$3" = "full" ] || [ "$3" = "extra" ]; then
				profile="$3"
			else
				echo "Usage: ./$0 $1 [sys|tool|hass|full] [basic|extra|full]"
				exit 1
			fi
		fi
	elif [ "$2" = "basic" ] || [ "$2" = "full" ] || [ "$2" = "extra" ]; then
		profile="$2"
		if [ $# -gt 2 ]; then
			echo "Usage: ./$0 $1 [sys|tool|hass|full] [basic|extra|full]"
			exit 1
		fi
	else
		echo "Usage: ./$0 $1 [sys|tool|hass|full] [basic|extra|full]"
		exit 1
	fi
fi

# Set defaults
if [ -z "$stack" ]; then
	stack="full"
fi
if [ -z "$profile" ]; then
	profile="basic"
fi

# Set profile string
profileStr="--profile $profile"

# Execute commands
if [ "$stack" = "full" ]; then
	# Run docker compose for all stacks in sequence (hass, tool, sys)
	docker compose -f hass-stack/docker-compose.yml --env-file .env ${profileStr} ${opStr}
	docker compose -f tool-stack/docker-compose.yml --env-file .env ${profileStr} ${opStr}
	docker compose -f sys-stack/docker-compose.yml --env-file .env ${profileStr} ${opStr}
else
	# Run docker compose for the specified single stack
	docker compose -f $stack-stack/docker-compose.yml --env-file .env ${profileStr} ${opStr}
fi

echo "Operation: $opStr"
echo "Stack: $stack"
echo "Profile: $profile"
