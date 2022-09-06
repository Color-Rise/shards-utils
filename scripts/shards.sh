#!/bin/bash

opt_short="rt:"
opt_long="release,target:"

OPTS=$(getopt -o "$opt_short" -l "$opt_long" -- "$@")

eval set -- "$OPTS"

# default values
build_type=Debug

# get args
while true
do
    case "$1" in
        -r|--release)
            build_type=Release
            shift ;;
        -t|--target)
            [[ ! "$2" =~ ^- ]] && build_type=$2
            shift 2 ;;
        --) # End of input reading
            shift; break ;;
    esac
done

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $build_type == "Debug" ];
then
    shards_exe="shardsd.exe"
elif [ $build_type == "Release" ];
then
    shards_exe="shardsr.exe"
    # required on Windows for release build
    . $script_dir/env.sh
else
    shards_exe="$build_type/shards.exe"
    # required on Windows for release build
    . $script_dir/env.sh
fi

# execute commands
$script_dir/build/$shards_exe $*
