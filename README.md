# MSPM0 SVDs

This repository contains SVD files for the MSPM0L and MSPM0G series of Cortex-M0+ MCUs with patches fixing some issues.

The goal of this project is mostly to keep track of changes and provide a source of patched SVDs which can then be used to build
rust PACs with svd2rust or zig files with regz, but is not tied to either.

The SVD files are from the Keil pack files, which in turn link to TI.

In case the SVD files are out of date, the can simply be updated by running

```sh
./scripts/update_packs.py
```

The script checks the current version and fetches and extracts newer pack files automatically if the version number changed.
The version in the script should be manually updated in case of an update then.
