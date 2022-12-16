#!/usr/bin/bash

opt_short="d"
opt_long="debug"

OPTS=$(getopt -o "$opt_short" -l "$opt_long" -- "$@")

eval set -- "$OPTS"

# default values
build_type=Release

# get args
while true
do
    case "$1" in
        -d|--debug)
            build_type=Debug
            shift;;
        --) # End of input reading
            shift; break ;;
    esac
done

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $build_type == "Debug" ];
then
    echo "Will run the sample using the debug version of shards"
else
    echo "Will run the sample using the release version of shards"
    # required on Windows for release build
    . $script_dir/env.sh
fi

# execute commands
$script_dir/build/$build_type/shards $script_dir/docs/samples/run-sample.edn --file $*
