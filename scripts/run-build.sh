#!/usr/bin/bash

opt_short="cfj:rt:"
opt_long="cmake,format,jobs:,release,rustup,target:,type:"

OPTS=$(getopt -o "$opt_short" -l "$opt_long" -- "$@")

eval set -- "$OPTS"

# default values
build_type=Debug
cmake=0
format=0
jobs=8
rustup=0
target=shards

# get args
while true
do
    case "$1" in
        -c|--cmake)
            cmake=1
            shift;;
        --format)
            format=1
            shift;;
        -j|--jobs)
            [[ ! "$2" =~ ^- ]] && jobs=$2
            shift 2 ;;
        --release)
            build_type=Release
            shift;;
        -r|--rustup)
            rustup=1
            shift;;
        --target)
            [[ ! "$2" =~ ^- ]] && target=$2
            shift 2 ;;
        -t|--type)
            [[ ! "$2" =~ ^- ]] && build_type=$2
            shift 2 ;;
        --) # End of input reading
            shift; break ;;
    esac
done

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! -d $script_dir/build ];
then
mkdir -p $script_dir/build
fi

# execute commands
pushd $script_dir/build

if [ $cmake -eq 1 ];
then
cmake -GNinja -DCMAKE_BUILD_TYPE=$build_type -B./$build_type ..
fi

if [ $format -eq 1 ];
then
pushd ..
cargo fmt
popd
ninja format -C $build_type
fi

if [ $rustup -eq 1 ];
then
rustup update
fi

ninja $target -C $build_type -j $jobs $*

popd
