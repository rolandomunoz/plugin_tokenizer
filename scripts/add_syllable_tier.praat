# Copyright 2017 Rolando Munoz

include ./../procedures/config.proc
include ./../procedures/string_as_phonemes.proc
include ./../procedures/string_as_syllables.proc
include ./../procedures/get_tier_number.proc

form Add syllable tier
    natural Input_tier txt
endform
src_tier = input_tier

# Get TextGrid info
tg = selected("TextGrid")
tg_name$ = selected$("TextGrid")

# Read preferences
@config.read: "./../preferences.txt"

parsingTablePath$ = "../temp/word2syllable.txt"
parsingTable = 0

vowels$ = config.read.return$["vowel"]
vowels$ = replace$(vowels$, " ", "|", 0)
consonants$ = config.read.return$["consonant.complex"]
consonants$ = replace$(consonants$, " ", "|", 0)
onset_complex$ = config.read.return$["syllable.complex.onset.all"]
onset_complex$ = replace$(onset_complex$, " ", "|", 0)
segments$ = consonants$ + "|" + vowels$
coda = number(config.read.return$["coda.boolean"])
if fileReadable(parsingTablePath$)
  parsingTable= Read Table from tab-separated file: parsingTablePath$
endif

# Get the source tier and create a duplicate tier

## Get tier number from tier name
selectObject: tg

Duplicate tier: src_tier, src_tier, "syll"
dst_tier = src_tier 
src_tier += 1

# Segment texts from intervals into phonemes
nIntervals = Get number of intervals: src_tier
for interval to nIntervals
  selectObject: tg
  interval_text$= Get label of interval: src_tier, interval
  tmin = Get start time of interval: src_tier, interval
  tmax = Get end time of interval: src_tier, interval
  dur = tmax-tmin

  if interval_text$ <> ""
    ruleBased_parsing = 1
    
    if parsingTable
      selectObject: parsingTable
      syllableRow= Search column: "word", interval_text$
      if syllableRow
        parsedWord$= object$[parsingTable, syllableRow, "syllable"]
        stringAsSyllables.return= Create Strings as tokens: parsedWord$, " "
        ruleBased_parsing = 0
      endif
    endif
    
    if ruleBased_parsing
      # Create Strings as phonemes
      @stringAsPhonemes: interval_text$, segments$
      @stringAsSyllables: vowels$, coda, onset_complex$
    endif
    
    selectObject: stringAsSyllables.return
    n_sylls = Get number of strings
    dur_syll = dur/n_sylls

    selectObject: tg
    for syll_phoneme to n_sylls
      tmin+= dur_syll
      syll$ = object$[stringAsSyllables.return, syll_phoneme]
      low_interval = Get low interval at time: dst_tier, tmax
      if syll_phoneme < n_sylls
        Insert boundary: dst_tier, tmin
      endif
      Set interval text: dst_tier, low_interval, syll$
    endfor
    if ruleBased_parsing
      removeObject: stringAsPhonemes.return, stringAsSyllables.return
    else
      removeObject: stringAsSyllables.return 
    endif
  endif
endfor

if parsingTable
  removeObject: parsingTable
endif
selectObject: tg
