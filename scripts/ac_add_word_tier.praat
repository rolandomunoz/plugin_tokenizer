# Copyright 2017-2018 Rolando Munoz

form Add word tier
  natural Input_tier 1
endform

#Select TextGrids
nSelected = numberOfSelected("TextGrid")
tg# = selected#("TextGrid")

selectObject: tg#
for i to nSelected
  selectObject: tg#[i]
  runScript: "add_word_tier.praat", input_tier
endfor

selectObject: tg#
