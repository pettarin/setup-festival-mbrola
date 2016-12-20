# setup-festival-mbrola

A Bash script for Linux and Mac OS X to download/compile/install Festival, MBROLA, and voice files.

* Date: 2016-12-20
* Version: 1.1.0
* Developer: [Alberto Pettarin](http://www.albertopettarin.it/)
* License: the MIT License (MIT)
* Contact: [click here](http://www.albertopettarin.it/contact.html)


## Download

```
$ curl -O https://raw.githubusercontent.com/pettarin/setup-festival-mbrola/master/setup_festival_mbrola.sh
```

or use the "Download ZIP" feature of the
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
  $ bash setup_festival_mbrola.sh PATH_TO_DEST_DIR ACTION

Actions:
  clean                   delete all DEST_DIR/build_* directories
  clean-all               delete entire DEST_DIR directory
  festival                download+compile Festival, install basic English voices
  festival-mbrola-voices  download+install Festival wrappers for MBROLA
  festival-voices         download+install all known Festival voices (WARNING: large download)
  italian                 download+install Italian voices for Festival, including wrappers for MBROLA
  mbrola                  download MBROLA binary
  mbrola-voices           download all known MBROLA voices (WARNING: large download)

Examples:
  $ bash setup_festival_mbrola.sh ~/st festival
  $ bash setup_festival_mbrola.sh ~/st mbrola
  $ bash setup_festival_mbrola.sh ~/st festival-mbrola-voices
  $ bash setup_festival_mbrola.sh ~/st italian
  $ bash setup_festival_mbrola.sh ~/st festival-voices        # WARNING: large download
  $ bash setup_festival_mbrola.sh ~/st mbrola-voices          # WARNING: large download
  $ bash setup_festival_mbrola.sh ~/st clean
  $ bash setup_festival_mbrola.sh ~/st clean-all
```

For example, if you want to install Festival, MBROLA,
and the Festival wrappers for MBROLA voices:

```bash
$ mkdir ~/speechtools
$ cd ~/speechtools
$ curl -O https://raw.githubusercontent.com/pettarin/setup-festival-mbrola/master/setup_festival_mbrola.sh
$ bash setup_festival_mbrola.sh st festival
$ bash setup_festival_mbrola.sh st mbrola
$ bash setup_festival_mbrola.sh st festival-mbrola-voices
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
