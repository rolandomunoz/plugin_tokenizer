# Copyright 2017 Rolando Muñoz Aramburú

include ./../procedures/config.proc
include ./../procedures/string_as_phonemes.proc
include ./../procedures/string_as_syllables.proc
include ./../procedures/get_tier_number.proc

form Add syllable tier
    sentence Input_tier txt
endform
src_tier$ = input_tier$

# Get TextGrid info
tg = selected("TextGrid")
tg_name$ = selected$("TextGrid")

# Get complex characters
@config.init: "./../preferences.txt"

vowels$ = config.init.return$["vowel"]
vowels$ = replace$(vowels$, " ", "|", 0)

consonants$ = config.init.return$["consonant.complex"]
consonants$ = replace$(consonants$, " ", "|", 0)

onset_complex$ = config.init.return$["syllable.complex.onset.all"]
onset_complex$ = replace$(onset_complex$, " ", "|", 0)

segments$ = consonants$ + "|" + vowels$
#segments$ = config.init.return$["phonemes"]
#segments$ = replace$(segments$, " ", "|", 0)

coda = number(config.init.return$["coda.boolean"])

# Get the source tier and create a duplicate tier

## Get tier number from tier name
selectObject: tg
getTierNumber.return[src_tier$] = 0
@getTierNumber
src_tier = getTierNumber.return[src_tier$]

## If the tier name is not found, the exit the script
if not src_tier
  writeInfoLine: "The file ", tg_name$, ".TextGrid does not contain the tier, ", src_tier$, "."
  exitScript()
endif

## Duplicate tier
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
  if interval_text$ <> ""
    # Create Strings as phonemes
    @stringAsPhonemes: interval_text$, segments$
    @stringAsSyllables: vowels$, coda, onset_complex$
    dur = tmax-tmin
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
    removeObject: stringAsPhonemes.return, stringAsSyllables.return
  endif
endfor
