# Copyright 2017-2018 Rolando Munoz

form Tokenize tier
  natural Input_tier 1
  boolean Add_segment_tier 1
  boolean Add_syllable_tier 0
endform

#Select TextGrids
n = numberOfSelected("TextGrid")
tg# = selected#("TextGrid")
selectObject: tg#

input_tier_constant = input_tier
for i to n
  input_tier = input_tier_constant
  
  selectObject: tg#[i]
  if add_syllable_tier
    runScript: "add_syllable_tier.praat", input_tier
  endif

  if add_segment_tier
    runScript: "add_segment_tier.praat", input_tier
  endif
endfor

selectObject: tg#
