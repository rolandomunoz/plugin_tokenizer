# Copyright 2017-2018 Rolando Munoz

include ./../procedures/string2interval.proc

form Add word tier
    natural Input_tier 1
endform

# Get TextGrid info
tg = selected("TextGrid")
phrase_tier = input_tier

## Duplicate phrase tier
Duplicate tier: phrase_tier, phrase_tier, "word"
word_tier = phrase_tier
phrase_tier += 1

# Segment texts from intervals into phonemes
nIntervals = Get number of intervals: phrase_tier
for interval to nIntervals
  selectObject: tg
  interval_text$= Get label of interval: phrase_tier, interval
  tmin = Get start time of interval: phrase_tier, interval
  tmax = Get end time of interval: phrase_tier, interval
  if interval_text$ <> ""
    # Create Strings as phonemes
    wordList = Create Strings as tokens: interval_text$, " "
    selectObject: wordList, tg
    @string2interval: word_tier, tmin, tmax
    removeObject: wordList
  endif
endfor

selectObject: tg
