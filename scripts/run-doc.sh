#!/usr/bin/bash

opt_short="rs"
opt_long="release,no-generate,serve"

OPTS=$(getopt -o "$opt_short" -l "$opt_long" -- "$@")

eval set -- "$OPTS"

# default values
build_type=Debug
generate=1
serve=0

# get args
while true
do
    case "$1" in
        -r|--release)
            build_type=Release
            shift ;;
        --no-generate)
            generate=0
            shift ;;
        -s|--serve)
            serve=1
            shift ;;
        --) # End of input reading
            shift; break ;;
    esac
done

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# execute commands
if [ $generate -eq 1 ];
then
    if [ $build_type == "Debug" ];
    then
        echo "Will build the documentation using the debug version of shards"
    else
        echo "Will build the documentation using the release version of shards"
        # required on Windows for release build
        . $script_dir/env.sh
    fi

    $script_dir/build/$build_type/shards $script_dir/docs/generate.edn
fi

if [ $serve -eq 1 ];
then
    pushd $script_dir/docs
    mkdocs serve
    popd
fi
