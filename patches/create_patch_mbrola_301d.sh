#!/bin/sh

DEST="../dist/patch_mbrola_301d.tar.gz"

rm -f $DEST

tar czvf "$DEST" \
  festival/lib/voices/english/en1_mbrola/festvox/en1_mbrola.scm \
  festival/lib/voices/english/en1_mbrola/festvox/en1_mbrola.scm.original \
  festival/lib/voices/english/us1_mbrola/festvox/us1_mbrola.scm \
  festival/lib/voices/english/us1_mbrola/festvox/us1_mbrola.scm.original \
  festival/lib/voices/english/us2_mbrola/festvox/us2_mbrola.scm \
  festival/lib/voices/english/us2_mbrola/festvox/us2_mbrola.scm.original \
  festival/lib/voices/english/us3_mbrola/festvox/us3_mbrola.scm \
  festival/lib/voices/english/us3_mbrola/festvox/us3_mbrola.scm.original

