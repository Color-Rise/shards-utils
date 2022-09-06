#!/bin/bash

opt_short="crj:ft:"
opt_long="cmake,rustup,jobs:,format,release,target:"

OPTS=$(getopt -o "$opt_short" -l "$opt_long" -- "$@")

eval set -- "$OPTS"

# default values
build_type=Debug
cmake=0
rustup=0
jobs=10
format=0

# get args
while true
do
    case "$1" in
        -c|--cmake)
            cmake=1
            shift ;;
        -r|--rustup)
            rustup=1
            shift ;;
        -j|--jobs)
            [[ ! "$2" =~ ^- ]] && jobs=$2
            shift 2 ;;
        -f|--format)
            format=1
            shift ;;
        --release)
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

# execute commands
pushd $script_dir/build

if [ $cmake -eq 1 ];
then
cmake -GNinja -DCMAKE_BUILD_TYPE=$build_type -B./$build_type ..
fi

if [ $rustup -eq 1 ];
then
rustup update
fi

if [ $format -eq 1 ];
then
pushd ..
cargo fmt
popd
ninja format
fi

pushd $build_type
echo "ninja shards -j $jobs $*"
ninja shards -j $jobs $*
popd

if [ $build_type == "Debug" ];
then
    cp -p ./$build_type/shards.exe shardsd.exe
    echo "Done building debug version of shards"
elif [ $build_type == "Release" ];
then
    cp -p ./$build_type/shards.exe shardsr.exe
    echo "Done building release version of shards"
else
    echo "Done building $build_type version of shards"
fi

popd
