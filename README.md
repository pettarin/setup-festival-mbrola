# setup-festival-mbrola

A Bash script for Linux and Mac OS X to download and install Festival and MBROLA from source.

* Date: 2016-12-17
* Version: 1.0.0
* License: MIT


## Download

```
$ curl -O https://raw.githubusercontent.com/pettarin/setup-festival-mbrola/master/setup_festival_mbrola.sh
```

or use the "Download master as ZIP" feature of the
[GitHub repo](https://github.com/pettarin/setup-festival-mbrola/).

Note: you need to have a compiler
(e.g., ``gcc`` on Linux, ``Xcode`` command line tools on Mac)
and the libraries required to compile Festival.
If the compilation of Festival fails, please read the error message
printed by its ``configure`` or ``Makefile``,
and act accordingly.


## Usage

```bash
Usage:
  $ bash setup_festival_mbrola.sh [clean|clean-all|festival|festival-mbrola-voices|festival-voices|mbrola|mbrola-voices] DESTINATION_DIRECTORY

Examples:
  $ # download and compile festival and basic English voices
  $ bash setup_festival_mbrola.sh festival speechtools

  $ # download mbrola executable
  $ bash setup_festival_mbrola.sh mbrola speechtools

  $ # download and install festival wrappers for mbrola voices
  $ bash setup_festival_mbrola.sh festival-mbrola-voices speechtools

  $ # download and install additional festival voices (large download!)
  $ bash setup_festival_mbrola.sh festival-voices speechtools

  $ # download and unpack additional mbrola voices (large download!)
  $ bash setup_festival_mbrola.sh mbrola-voices speechtools

  $ # delete all speechtools/build_* directories
  $ bash setup_festival_mbrola.sh clean speechtools

  $ # delete the entire directory speechtools
  $ bash setup_festival_mbrola.sh clean-all speechtools
```

For example, if you want to install Festival, MBROLA,
and the Festival wrappers for MBROLA voices:

```bash
$ mkdir ~/speechtools
$ cd ~/speechtools
$ curl -O https://raw.githubusercontent.com/pettarin/setup-festival-mbrola/master/setup_festival_mbrola.sh
$ bash setup_festival_mbrola.sh festival st
$ bash setup_festival_mbrola.sh mbrola st
$ bash setup_festival_mbrola.sh festival-mbrola-voices st
$ export PATH=`pwd`/st/build_festival/festival/bin:$PATH
$ export PATH=`pwd`/st/build_mbrola:$PATH
$ echo "Hello world! This is the US 1 MBROLA American English voice." | text2wave -eval "(voice_us1_mbrola)" -o /tmp/out.us1_mbrola.wav
```


## License

The scripts and patches in this repository
are released under the terms of the MIT License.

They should be used for research and/or personal purposes only,
and according to the licensing terms of
[Festival](http://www.cstr.ed.ac.uk/projects/festival/),
[MBROLA](http://tcts.fpms.ac.be/synthesis/mbrola.html),
and their voice files.
