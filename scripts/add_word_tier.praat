# Copyright 2017 Rolando Munoz

include ./../procedures/string_as_phonemes.proc
include ./../procedures/get_tier_number.proc

form Add word tier
    sentence Input_tier
endform

src_tier$ = input_tier$

# Get TextGrid info
tg = selected("TextGrid")
tg_name$ = selected$("TextGrid")
# Get the source tier and create a duplicate tier

## Get tier number from tier name
selectObject: tg
getTierNumber.return[src_tier$] = 0
@getTierNumber
src_tier = getTierNumber.return[src_tier$]

## If the tier name is not found, the exit the script
if not src_tier
  writeInfoLine: "The file ", tg_name$, ".TextGrid does not contain the tier <", src_tier$, ">."
  exitScript()
endif

## Duplicate tier
Duplicate tier: src_tier, src_tier, "word"
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
    Create Strings as tokens: interval_text$, " "
    wordList = selected("Strings")
    dur = tmax-tmin
    n_words = Get number of strings
    dur_word = dur/n_words

    selectObject: tg
    for i_words to n_words
      tmin+= dur_word
      word$ = object$[wordList, i_words]
      low_interval = Get low interval at time: dst_tier, tmax
      if i_words < n_words
        Insert boundary: dst_tier, tmin
      endif
      Set interval text: dst_tier, low_interval, word$
    endfor
    removeObject: wordList
  endif
endfor