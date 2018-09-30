# Copyright 2017-2018 Rolando Munoz

include ./../procedures/string2interval.proc

form Add word tier
    natural Input_tier
endform

# Get TextGrid info
tg = selected("TextGrid")
word_tier = input_tier

## Duplicate tier
Duplicate tier: word_tier, word_tier, "word"

# Segment texts from intervals into phonemes
nIntervals = Get number of intervals: word_tier
for interval to nIntervals
  selectObject: tg
  interval_text$= Get label of interval: word_tier, interval
  tmin = Get start time of interval: word_tier, interval
  tmax = Get end time of interval: word_tier, interval
  if interval_text$ <> ""
    # Create Strings as phonemes
    wordList = Create Strings as tokens: interval_text$, " "
    selectObject: wordList, tg
    @string2interval: word_tier, tmin, tmax
    removeObject: wordList
  endif
endfor

selectObject: tg
