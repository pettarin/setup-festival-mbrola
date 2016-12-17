#!/bin/sh

# __author__ = "Alberto Pettarin"
# __copyright__ = "Copyright 2016, Alberto Pettarin (www.albertopettarin.it)"
# __license__ = "MIT"
# __version__ = "1.0.0"
# __email__ = "alberto@albertopettarin.it"
# __status__ = "Production"

#
# NOTE this script will create a directory with the following structure:
#
#      DESTINATION_DIRECTORY
#        |
#        | build_festival
#        |   | festival
#        |   |   | bin
#        |   |   |   | festival (exec)
#        |   |   |   | text2wave (exec)
#        |   |   |   | ...
#        |   |   |
#        |   |   | lib
#        |   |   |   | voices
#        |   |   |   | ...
#        |   |   | ...
#        |
#        | build_mbrola
#        |   | mbrola (exec)
#        |
#        | build_mbrola_voices
#        |   | several mbrola voice dirs
#        |
#        | download_festival
#        |   | several .tar.gz files
#        |
#        | download_festival_mbrola
#        |   | several .tar.gz or .zip files
#        |
#        | download_festival_voices
#        |   | several .tar.gz files
#        |
#        | download_mbrola
#        |   | several .tar.gz or .zip files
#        |
#        | download_mbrola_voices
#        |   | several.zip files
#        |
#

usage() {
    echo ""
    echo "Usage:"
    echo "  $ bash $0 [clean|clean-all|festival|festival-mbrola-voices|festival-voices|mbrola|mbrola-voices] DESTINATION_DIRECTORY"
    echo ""
    echo "Examples:"
    echo "  $ # download and compile festival and basic English voices"
    echo "  $ bash $0 festival speechtools"
    echo ""
    echo "  $ # download mbrola executable"
    echo "  $ bash $0 mbrola speechtools"
    echo ""
    echo "  $ # download and install festival wrappers for mbrola voices"
    echo "  $ bash $0 festival-mbrola-voices speechtools"
    echo ""
    echo "  $ # download and install additional festival voices (large download!)"
    echo "  $ bash $0 festival-voices speechtools"
    echo ""
    echo "  $ # download and unpack additional mbrola voices (large download!)"
    echo "  $ bash $0 mbrola-voices speechtools"
    echo ""
    echo "  $ # delete all speechtools/build_* directories"
    echo "  $ bash $0 clean speechtools"
    echo ""
    echo "  $ # delete the entire directory speechtools"
    echo "  $ bash $0 clean-all speechtools"
    echo ""
}

clean() {
  R=$1
  rm -rf "$R/build_festival"
  rm -rf "$R/build_mbrola"
  rm -rf "$R/build_mbrola_voices"
  echo "[INFO] Removed directories $R/build_*"
}

clean_all() {
  R=$1
  if [ -d "$R/build_festival" ] || [ -d "$R/build_mbrola" ] || [ -d "$R/download_festival" ] || [ -d "$R/download_mbrola" ] || [ -d "$R/download_festival_mbrola" ]
  then
    rm -rf "$R"
    echo "[INFO] Removed directory $R"
  else
    echo "[ERRO] Directory $R does not look like a valid Festival/MBROLA directory, aborting."
  fi
}

ensure_directory() {
  D=$1
  if [ ! -d "$D" ]
  then
    mkdir -p "$D"
    echo "[INFO] Created directory $D"
  fi
}

install_festival() {
  P=`pwd`
  R=$1
  REPO="download_festival"
  BUILD="build_festival"

  ensure_directory "$R"
  ensure_directory "$R/$REPO"
  ensure_directory "$R/$BUILD"
  cd "$R"

  echo "[INFO] Installing Festival..."

  echo "[INFO]   Downloading files..."
  cd "$REPO"
  #
  # NOTE this will download the minimum number of files required
  #      to have a working Festival with UK and US basic voices:
  #
  #      Edinburgh speech tools (EST)
  #      Festival
  #      Festlex CMU, OALD, POSLEX lexica
  #      Diphone voices: don, kal, ked, rab
  #
  # NOTE order is important! Always have:
  #      first EST,
  #      then Festival,
  #      then lexica,
  #      then voices
  #
  declare -a URLS=(
    "http://festvox.org/packed/festival/2.4/speech_tools-2.4-release.tar.gz"
    "http://festvox.org/packed/festival/2.4/festival-2.4-release.tar.gz"
    "http://festvox.org/packed/festival/2.4/festlex_CMU.tar.gz"
    "http://festvox.org/packed/festival/2.4/festlex_OALD.tar.gz"
    "http://festvox.org/packed/festival/2.4/festlex_POSLEX.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_kallpc16k.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_rablpc16k.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_don.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_kedlpc16k.tar.gz"
  )
  for URL in "${URLS[@]}"
  do
    BASE=`basename $URL`
    if [ ! -e "$BASE" ]
    then
      curl -O "$URL"
    fi
  done
  cd ..
  echo "[INFO]   Downloading files... done"

  echo "[INFO]   Unpacking files..."
  cd "$BUILD"
  #
  # NOTE here the order of URLS matters!
  #
  for URL in "${URLS[@]}"
  do
    BASE=`basename $URL`
    tar zxvf "../$REPO/$BASE"
  done
  echo "[INFO]   Unpacking files... done"

  echo "[INFO]   Compiling speech tools..."
  export ESTDIR=`pwd`/speech_tools
  cd speech_tools
  ./configure && make && make make_library
  cd ..
  echo "[INFO]   Compiling speech tools... done"

  echo "[INFO]   Compiling festival..."
  cd festival
  ./configure && make
  cd ..
  cd ..
  echo "[INFO]   Compiling festival... done"

  echo "[INFO] Installing Festival... done"

  echo ""
  echo "[INFO] You might want to append:"
  echo "[INFO]   $R/$BUILD/festival/bin"
  echo "[INFO] to your PATH environment variable."
  echo ""

  cd "$P"
}

install_festival_voices() {
  P=`pwd`
  R=$1
  REPO="download_festival_voices"
  BUILD="build_festival"

  ensure_directory "$R"
  ensure_directory "$R/$REPO"
  ensure_directory "$R/$BUILD"
  cd "$R"

  echo "[INFO] Installing additional voices..."
  echo "[INFO]   Downloading files..."
  cd "$REPO"
  declare -a URLS=(
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_ahw_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_aup_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_awb_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_axb_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_bdl_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_clb_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_fem_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_gka_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_jmk_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_ksp_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_rms_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_rxr_cg.tar.gz"
    "http://festvox.org/packed/festival/2.4/voices/festvox_cmu_us_slt_cg.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_cmu_us_awb_arctic_hts.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_cmu_us_bdl_arctic_hts.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_cmu_us_jmk_arctic_hts.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_cmu_us_slt_arctic_hts.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_cstr_us_awb_arctic_multisyn-1.0.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_cstr_us_jmk_arctic_multisyn-1.0.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_ellpc11k.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_kallpc8k.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_kedlpc8k.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_rablpc8k.tar.gz"
  )
  for URL in "${URLS[@]}"
  do
    BASE=`basename $URL`
    if [ ! -e "$BASE" ]
    then
      curl -O "$URL"
    fi
  done
  cd ..
  echo "[INFO]   Downloading files... done"

  echo "[INFO]   Unpacking files..."
  cd "$BUILD"
  for F in `ls ../$REPO/*.tar.gz`
  do
    tar zxvf $F
  done
  cd ..
  echo "[INFO]   Unpacking files... done"

  echo "[INFO] Installing additional voices... done"

  cd "$P"
}

install_mbrola() {
  P=`pwd`
  R=$1
  REPO="download_mbrola"
  BUILD="build_mbrola"

  ensure_directory "$R"
  ensure_directory "$R/$REPO"
  ensure_directory "$R/$BUILD"
  cd "$R"

  echo "[INFO] Installing mbrola..."
  cd "$REPO"
  UNAME=`uname`
  DOWNLOADED=0
  if [ "$UNAME" == "Linux" ]
  then
    # download mbrola for Linux
    echo "[INFO]   Downloading mbrola binary for Linux..."
    curl -O "http://tcts.fpms.ac.be/synthesis/mbrola/bin/pclinux/mbr301h.zip"
    echo "[INFO]   Downloading mbrola binary for Linux... done"

    # extract
    echo "[INFO]   Copying mbrola binary to $BUILD ..."
    unzip mbr301h.zip "mbrola-linux-i386" -d "../$BUILD/"
    mv "../$BUILD/mbrola-linux-i386" "../$BUILD/mbrola"
    echo "[INFO]   Copying mbrola binary to $BUILD ... done"

    DOWNLOADED=1
  elif [ "$UNAME" == "Darwin" ]
  then
    # download mbrola for Mac OS X
    echo "[INFO]   Downloading mbrola binary for OS X..."
    curl -O "http://tcts.fpms.ac.be/synthesis/mbrola/bin/macintosh/mbrola"
    echo "[INFO]   Downloading mbrola binary for OS X... done"

    echo "[INFO]   Copying mbrola binary to $BUILD ..."
    chmod 744 "mbrola"
    cp "mbrola" "../$BUILD/mbrola"
    echo "[INFO]   Copying mbrola binary to $BUILD ... done"

    DOWNLOADED=1
  else
    # unknown OS
    echo "[ERRO]   Unknown OS, aborting."
  fi

  if [ "$DOWNLOADED" == "1" ]
  then
    echo ""
    echo "[INFO] You might want to append:"
    echo "[INFO]   $R/$BUILD"
    echo "[INFO] to your PATH environment variable."
    echo ""
  fi

  cd ..
  echo "[INFO] Installing mbrola... done"

  cd "$P"
}

install_festival_mbrola_voices() {
  P=`pwd`
  R=$1
  REPO="download_festival_mbrola"
  BUILD="build_festival"

  ensure_directory "$R"
  ensure_directory "$R/$REPO"
  ensure_directory "$R/$BUILD"
  cd "$R"

  echo "[INFO] Installing festival-mbrola voices..."
  echo "[INFO]   Downloading files..."
  cd "$REPO"
  declare -a URLS=(
    "http://festvox.org/packed/festival/1.95/festvox_en1.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_us1.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_us2.tar.gz"
    "http://festvox.org/packed/festival/1.95/festvox_us3.tar.gz"
    "http://tcts.fpms.ac.be/synthesis/mbrola/dba/en1/en1-980910.zip"
    "http://tcts.fpms.ac.be/synthesis/mbrola/dba/us1/us1-980512.zip"
    "http://tcts.fpms.ac.be/synthesis/mbrola/dba/us2/us2-980812.zip"
    "http://tcts.fpms.ac.be/synthesis/mbrola/dba/us3/us3-990208.zip"
  )
  for URL in "${URLS[@]}"
  do
    BASE=`basename $URL`
    if [ ! -e "$BASE" ]
    then
      curl -O "$URL"
    fi
  done
  cd ..
  echo "[INFO]   Downloading files... done"

  echo "[INFO]   Unpacking files..."
  cd "$BUILD"
  for F in `ls ../$REPO/*.tar.gz`
  do
    tar zxvf $F
  done
  cd ..
  unzip -o "$REPO/en1-980910.zip" -d "$BUILD/festival/lib/voices/english/en1_mbrola/"
  unzip -o "$REPO/us1-980512.zip" -d "$BUILD/festival/lib/voices/english/us1_mbrola/"
  unzip -o "$REPO/us2-980812.zip" -d "$BUILD/festival/lib/voices/english/us2_mbrola/"
  unzip -o "$REPO/us3-990208.zip" -d "$BUILD/festival/lib/voices/english/us3_mbrola/"
  echo "[INFO]   Unpacking files... done"

  UNAME=`uname`
  if [ "$UNAME" == "Darwin" ]
  then
    echo "[INFO]   Downloading and patching Festival wrappers for mbrola 3.01d ..."
    # on Mac OS X only mbrola 3.01d is available,
    # hence we need to download the patched Festival wrappers
    cd "$P"
    cd "$R"
    cd "$REPO"
    curl -O "https://raw.githubusercontent.com/pettarin/setup-festival-mbrola/master/dist/patch_mbrola_301d.tar.gz"
    cd ..
    cd "$BUILD"
    tar zxvf "../$REPO/patch_mbrola_301d.tar.gz"
    cd ..
    cd "$P"
    echo "[INFO]   Downloading and patching Festival wrappers for mbrola 3.01d ... done"
  fi

  echo "[INFO] Installing festival-mbrola voices... done"

  cd "$P"
}

download_mbrola_voices() {
  P=`pwd`
  R=$1
  REPO="download_mbrola_voices"
  BUILD="build_mbrola_voices"

  ensure_directory "$R"
  ensure_directory "$R/$REPO"
  ensure_directory "$R/$BUILD"
  cd "$R"

  echo "[INFO] Installing additional mbrola voices..."
  echo "[INFO]   Downloading files..."
  cd "$REPO"
  declare -a URLS=(
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/af1/af1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/us1/us1-980512.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/us2/us2-980812.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/us3/us3-990208.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/ar1/ar1-981103.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/ar2/ar2-001015.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/br1/br1-971105.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/br2/br2-000119.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/br3/br3-000119.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/br4/br4.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/bz1/bz1-980116.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/en1/en1-980910.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/ca1/ca1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/ca2/ca2.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/cn1/cn1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/cr1/cr1-981028.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/cz1/cz1-991020.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/cz2/cz2-001009.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/nl1/nl1-980609.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/nl2/nl2-990507.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/nl3/nl3-001013.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/nz1/nz1-000911.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/ee1/ee1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/pt1/pt1-000509.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/fr1/fr1-990204.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/fr2/fr2-980806.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/fr3/fr3-990324.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/fr4/fr4-990521.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/fr5/fr5-991020.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/fr6/fr6-010330.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/fr7/fr7-010330.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/de1/de1-980227.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/de2/de2-990106.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/de3/de3-000307.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/de4/de4.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/de5/de5.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/de6/de6.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/de7/de7.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/de8/de8.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/es1/es1-980610.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/es2/es2-989825.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/es3/es3.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/es4/es4.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/gr1/gr1-990610.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/gr2/gr2-010521.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/hb1/hb1-000308.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/hb2/hb2.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/hn1/hn1-990923.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/hu1/hu1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/ic1/ic1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/id1/id1-001010.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/in1/in1-010206.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/in2/in2-010202.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/ir1/ir1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/it1/it1-010213.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/it2/it2-010406.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/it3/it3-010304.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/it4/it4-010926.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/jp1/jp1-000314.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/jp2/jp2-270202.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/jp3/jp3.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/la1/la1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/lt1/lt1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/lt2/lt2.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/ma1/ma1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/pl1/pl1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/mx1/mx1-990208.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/mx2/mx2.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/ro1/ro1-980317.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/sw1/sw1-980623.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/sw2/sw2-140102.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/tl1/tl1.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/tr1/tr1-010209.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/tr2/tr2-010212.zip"
    "http://www.tcts.fpms.ac.be/synthesis/mbrola/dba/vz1/vz1.zip"
  )
  for URL in "${URLS[@]}"
  do
    BASE=`basename $URL`
    if [ ! -e "$BASE" ]
    then
      curl -O "$URL"
    fi
  done
  cd ..
  echo "[INFO]   Downloading files... done"

  echo "[INFO]   Unpacking files..."
  cd "$BUILD"
  for F in `ls ../$REPO/*zip`
  do
    unzip "$F" -d .
  done
  cd ..
  echo "[INFO]   Unpacking files... done"

  echo "[INFO] Installing additional mbrola voices... done"

  cd "$P"
}



# NOTE begin of the main script

if [ "$#" -lt "2" ]
then
  usage
  exit 2
fi

ACTION=$1
DESTINATION=$2

if [ "$ACTION" == "clean" ]
then
  clean "$DESTINATION"
elif [ "$ACTION" == "clean_all" ]
then
  clean_all "$DESTINATION"
elif [ "$ACTION" == "festival" ]
then
  install_festival "$DESTINATION"
elif [ "$ACTION" == "mbrola" ]
then
  install_mbrola "$DESTINATION"
elif [ "$ACTION" == "festival-voices" ]
then
  install_festival_voices "$DESTINATION"
elif [ "$ACTION" == "festival-mbrola-voices" ]
then
  install_festival_mbrola_voices "$DESTINATION"
elif [ "$ACTION" == "mbrola-voices" ]
then
  download_mbrola_voices "$DESTINATION"
else
  usage
  exit 2
fi

exit 0
