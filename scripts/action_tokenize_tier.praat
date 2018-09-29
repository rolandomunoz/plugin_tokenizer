# Copyright 2017 Rolando Munoz

#Include libraries
include ../procedures/config.proc

form Tokenize tier
  word Input_tier phrase
  boolean Add_segment_tier 1
  boolean Add_syllable_tier 0
  boolean Add_word_tier <add_segment_tier>
endform

#Select TextGrids
n = numberOfSelected("TextGrid")
tg# = selected#("TextGrid")
selectObject: tg#

input_tier_constant$ = input_tier$
for i to n
  input_tier$ = input_tier_constant$
  selectObject: tg#[i]
  if add_word_tier
    runScript: "add_word_tier.praat", input_tier$
    input_tier$ = "word"
  endif

  if add_syllable_tier
    runScript: "add_syllable_tier.praat", input_tier$
    input_tier$ = "syll"
  endif

  if add_segment_tier
    runScript: "add_segment_tier.praat", input_tier$
  endif
endfor

selectObject: tg#
