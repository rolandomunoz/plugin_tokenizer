#Include libraries
include ./../procedures/config.proc

#Select TextGrids
n = numberOfSelected("TextGrid")
for i to n
  tg[i] = selected("TextGrid", i)
endfor

# Read variables from preferences.txt
@config.init: "./../.preferences.txt"

src_tier$ = config.init.return$["each_src_tier"]
add_segment_tier = number(config.init.return$["each_add_segment_tier"])
add_syllable_tier = number(config.init.return$["each_add_syllable_tier"])
add_word_tier = number(config.init.return$["each_add_word_tier"])

selectObject()
for i to n
  plusObject: tg[i]
endfor

beginPause: "Add new tiers..."
  sentence: "Input tier", src_tier$
  boolean: "Add word tier", add_word_tier
  boolean: "Add syllable tier", add_syllable_tier
  boolean: "Add segment tier", add_segment_tier
clicked= endPause: "Continue", "Quit", 1

if clicked = 2
    exitScript()
endif

@config.setField: "each_src_tier", input_tier$
@config.setField: "each_add_segment_tier", string$(add_segment_tier)
@config.setField: "each_add_syllable_tier", string$(add_syllable_tier)
@config.setField: "each_add_word_tier", string$(add_word_tier)


input_tier_constant$ = input_tier$
for i to n
  input_tier$ = input_tier_constant$
  selectObject: tg[i]
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

selectObject()
for i to n
  plusObject: tg[i]
endfor

