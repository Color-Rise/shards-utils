# Utility scripts for shards

*Note: the scripts are meant to be used on Windows from a MinGW prompt. They can easily be adapted to work on a Linux shell as well: just edit them and remove the executable extension (`.exe`).*

## Building

The script `run-build.sh` can be used to build shards with several options. Shards will be built into a child folder of `build/` (e.g. `build/Debug` for the DEBUG version).

In addition a copy of the final executable will be copied into `build` with a different name based on whether in is the DEBUG or the RELEASE build (resp. `shardsd.exe` and `shardsr.exe`). This helps keeping both side by side.

**Debug**
```sh
./run-build.sh
# or
./run-build.sh --target Debug
```

**Release**
```sh
./run-build.sh --release
# or
./run-build.sh --target Release
```

**Invoke cmake**
```sh
./run-build.sh -c
# or
./run-build.sh --cmake
```

**Invoke rustup**
```sh
./run-build.sh -r
# or
./run-build.sh --rustup
```

**Format the code**
```sh
./run-build.sh -f
# or
./run-build.sh --format
```

**Set the max number of parallel jobs**
```sh
# max 4 in this example
./run-build.sh -j 4
# or
./run-build.sh --jobs 4
```

## Running a shards script

Assuming shards has been built using `run-build.sh`, we can run a shard script using `shards.sh`.

**Run in DEBUG mode**
```sh
./shards.sh myscript.edn
# or
./shards.sh --target Debug myscript.edn
```

**Run in RELEASE mode**
```sh
./shards.sh --release myscript.edn
# or
./shards.sh --target Release myscript.edn
```

## Running the documentation samples

**Run in DEBUG mode**
```sh
./run-samples.sh --debug
```

**Run in RELEASE mode**
```sh
./run-samples.sh
# or
./run-samples.sh --release
```

## Running the documentation

**Generating with `mkdocs`**
```sh
./run-doc.sh
```

**Serving the documentation**
```sh
./run-doc.sh --serve
```

**Serving the documentation without generating**
```sh
./run-doc.sh --no-generate --serve
```
