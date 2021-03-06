# Copyright 2017 Rolando Munoz

include ./../procedures/config.proc
include ./../procedures/string_as_phonemes.proc
include ./../procedures/get_tier_number.proc

form Add segment tier
    natural Input_tier
endform

src_tier = input_tier

# Get TextGrid info
tg = selected("TextGrid")
tg_name$ = selected$("TextGrid")

# Read preferences
@config.read: "./../preferences.txt"

vowels$ = config.read.return$["vowel"]
vowels$ = replace$(vowels$, " ", "|", 0)

consonants$ = config.read.return$["consonant.complex"]
consonants$ = replace$(consonants$, " ", "|", 0)

segments$ = consonants$ + "|" + vowels$

# Get the source tier and create a duplicate tier

## Get tier number from tier name
selectObject: tg

## Duplicate tier
Duplicate tier: src_tier, src_tier, "phon"
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
    phonemeList = selected("Strings")
    dur = tmax-tmin
    n_phonemes = Get number of strings
    dur_phoneme = dur/n_phonemes

    selectObject: tg
    for i_phoneme to n_phonemes
      tmin+= dur_phoneme
      phoneme$ = object$[phonemeList, i_phoneme]
      low_interval = Get low interval at time: dst_tier, tmax
      if i_phoneme < n_phonemes
        Insert boundary: dst_tier, tmin
      endif
      Set interval text: dst_tier, low_interval, phoneme$
    endfor
    removeObject: phonemeList
  endif
endfor

selectObject: tg
