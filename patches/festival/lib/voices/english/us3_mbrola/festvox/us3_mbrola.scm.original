;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                       ;;
;;;                Centre for Speech Technology Research                  ;;
;;;                     University of Edinburgh, UK                       ;;
;;;                       Copyright (c) 1996-1999                         ;;
;;;                        All Rights Reserved.                           ;;
;;;                                                                       ;;
;;;  Permission is hereby granted, free of charge, to use and distribute  ;;
;;;  this software and its documentation without restriction, including   ;;
;;;  without limitation the rights to use, copy, modify, merge, publish,  ;;
;;;  distribute, sublicense, and/or sell copies of this work, and to      ;;
;;;  permit persons to whom this work is furnished to do so, subject to   ;;
;;;  the following conditions:                                            ;;
;;;   1. The code must retain the above copyright notice, this list of    ;;
;;;      conditions and the following disclaimer.                         ;;
;;;   2. Any modifications must be clearly marked as such.                ;;
;;;   3. Original authors' names are not deleted.                         ;;
;;;   4. The authors' names are not used to endorse or promote products   ;;
;;;      derived from this software without specific prior written        ;;
;;;      permission.                                                      ;;
;;;                                                                       ;;
;;;  THE UNIVERSITY OF EDINBURGH AND THE CONTRIBUTORS TO THIS WORK        ;;
;;;  DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING      ;;
;;;  ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT   ;;
;;;  SHALL THE UNIVERSITY OF EDINBURGH NOR THE CONTRIBUTORS BE LIABLE     ;;
;;;  FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES    ;;
;;;  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN   ;;
;;;  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,          ;;
;;;  ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF       ;;
;;;  THIS SOFTWARE.                                                       ;;
;;;                                                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  A voice using the MBROLA us3 database
;;;  This uses the standard kal/ked top end and executes the external
;;;  mbrola program to form the waveform.
;;;
;;;  Note this requires MBROLA which has its own licence different
;;;  from the one above
;;;
;;;
;;;  To install
;;;  Get the mrbola programs and us3 database from 
;;;     http://tcts.fpms.ac.be/synthesis/mbrola.html
;;;  1) put the mbrola executable in festival/lib/etc/[OSTYPE]/
;;;     where [OSTYPE] is the os type of your installation, there
;;;     will already be a directory of the appropriate name in
;;;     festival/lib/etc/ after you have installed festival (if there
;;;     isn't just add mbrola to festival/lib/etc/ instead)
;;;     The directory you put it in should also contain audsp (the
;;;     the audio spooler) as that directory is already in Festival's
;;;     path.
;;;  2) put the us3 database is
;;;        festival/lib/voices/english/us2_mbrola/us3/us3
;;;     that is unpack the us3-XXXXXX.zip file in this directory
;;;  3) If you have an older version of mbrola you will need to change
;;;     the calling sequence for mbrola itself look below at *OLD MBROLA*
;;;
;;;  call (voice_us3_mrbola) in festival to select the voice or
;;;  add to siteinit.scm 
;;;     (set! voice_default 'voice_us3_mbrola)
;;;  to make it always select this voice as the default


;;; We need to know where the MBROLA us3 database and usradio file is
;;; You may need to change this unless you unpack this in 
;;; festival/lib/voices/english/us3_mbrola/
(set! us3_mbrola_dir (cdr (assoc 'us3_mbrola voice-locations)))
(set! load-path (cons (path-append us3_mbrola_dir "festvox/") load-path))

(require 'radio_phones)
(require 'pos)
(require 'phrase)
(require 'tobi)
(require 'f2bf0lr)
(require 'mrpa_durs)
(require 'mbrola)

(setup_cmu_lex)

(define (us3_postlex_syllabics utt)
"(us3_postlex_syllabics utt)
Becuase the lexicon is somewhat random in its used of syllable l n and
m this is designed to post process the output inserting schwa before
them.  Ideally the lexicon should be fixed."
  (mapcar
   (lambda (s)
     (if (and (member_string (item.name s) '("l" "n" "m"))
	      (string-equal "coda" (item.feat s "seg_onsetcoda"))
	      ;; r wont exist for British English so this is OK
	      (string-equal "-" (item.feat s "p.ph_vc")))
	 (item.relation.insert 
	  s 'SylStructure
	  (item.insert s (list "@") 'before)
	  'before)))
   (utt.relation.items utt 'Segment)))

(define (us3_hh-y_fix utt)
  "(us3_hh-y-fix utt)
This db is missing hh-y diphone so map y after hh to ih."
  (mapcar
   (lambda (s)
     (if (and (string-equal "y" (item.name s))
	      (string-equal "hh" (item.feat s "p.name")))
	 (item.set_name s "ih")))
   (utt.relation.items utt 'Segment)))

(define (voice_us3_mbrola)
"(voice_us3_mbrola)
 Set up the current voice to be an American Female speaker using
 the MBROLA us3 diphone set."
  (voice_reset)
  (Parameter.set 'Language 'americanenglish)
  (require 'radio_phones)
  (Parameter.set 'PhoneSet 'radio)
  (PhoneSet.select 'radio)
  ;; Tokenization rules
  (set! token_to_words english_token_to_words)
  ;; POS tagger
  (require 'pos)
  (set! pos_lex_name "english_poslex")
  (set! pos_ngram_name 'english_pos_ngram)
  (set! pos_supported t)
  (set! guess_pos english_guess_pos)   ;; need this for accents
  ;; Lexicon selection
  (lex.select "cmu")
  (set! postlex_rules_hooks (list postlex_apos_s_check us3_hh-y_fix))
  ;; Phrase prediction
  (require 'phrase)
  (Parameter.set 'Phrase_Method 'prob_models)
  (set! phr_break_params english_phr_break_params)
  ;; Accent and tone prediction
  (require 'tobi)
  (set! int_tone_cart_tree f2b_int_tone_cart_tree)
  (set! int_accent_cart_tree f2b_int_accent_cart_tree)

  (set! postlex_vowel_reduce_cart_tree 
	postlex_vowel_reduce_cart_data)
  ;; F0 prediction
  (require 'f2bf0lr)
  (set! f0_lr_start f2b_f0_lr_start)
  (set! f0_lr_mid f2b_f0_lr_mid)
  (set! f0_lr_end f2b_f0_lr_end)
  (Parameter.set 'Int_Method Intonation_Tree)
  (set! int_lr_params
	'((target_f0_mean 105) (target_f0_std 16)
	  (model_f0_mean 170) (model_f0_std 34)))
  (Parameter.set 'Int_Target_Method Int_Targets_LR)
  ;; Duration prediction
  (require 'usdurtreeZ)
  (set! duration_cart_tree us_duration_cart_tree)
  (set! duration_ph_info us_durs)
  (Parameter.set 'Duration_Method Duration_Tree_ZScores)
  (Parameter.set 'Duration_Stretch 1.0)
  ;; Waveform synthesizer: MBROLA us3 diphones
  (Parameter.set 'Synth_Method MBROLA_Synth)
  ;;  Because we need an extra parameter in the new version of mbrola
  ;;  we add that parameter to the database "name"
  (set! mbrola_progname "mbrola")
  ;;  Newer versions of mbrola require the -I flag
  (set! mbrola_database 
	(format 
	 nil
	 "-I %s%s %s%s "
         us3_mbrola_dir "usradio"
	 us3_mbrola_dir "us3/us3" 
	 ))
  ;; *OLD MBROLA* doesn't require the -I flag and does it by argumnent order
  ;; uncomment the following if you are using an older version of mbrola
;  (set! mbrola_database 
;	(format 
;	 nil
;	 "%s%s %s%s "
;	 us3_mbrola_dir "us3/us3" 
;         us3_mbrola_dir "usradio"
;	 ))

  (set! current-voice 'us3_mbrola)
)

(proclaim_voice
 'us3_mbrola
 '((language english)
   (gender male)
   (dialect american)
   (description
    "This voice provides a American English male voice using the
     MBROLA synthesis method.  It uses a 
     modified CMU lexicon for pronunciations.
     Prosodic phrasing is provided by a statistically trained model
     using part of speech and local distribution of breaks.  Intonation
     is provided by a CART tree predicting ToBI accents and an F0 
     contour generated from a model trained from natural speech.  The
     duration model is also trained from data using a CART tree.")))

(provide 'us3_mbrola)

