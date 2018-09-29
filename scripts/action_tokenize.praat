# Copyright 2017 Rolando Munoz

#Include libraries
include ../procedures/config.proc

#Select TextGrids
n = numberOfSelected("TextGrid")
tg# = selected#("TextGrid")

# Read variables from preferences.txt
@config.read: "../preferences.txt"

selectObject: tg#

beginPause: "Add new tiers..."
  word: "Input tier", config.read.return$["each_src_tier"]
  boolean: "Add word tier", config.read.return["each_add_word_tier"]
  boolean: "Add syllable tier", config.read.return["each_add_syllable_tier"]
  boolean: "Add segment tier", config.read.return["each_add_segment_tier"]
clicked= endPause: "Cancel","Apply", "Ok", 3

if clicked = 1
    exitScript()
endif

@config.set: "each_src_tier", input_tier$
@config.set: "each_add_segment_tier", string$(add_segment_tier)
@config.set: "each_add_syllable_tier", string$(add_syllable_tier)
@config.set: "each_add_word_tier", string$(add_word_tier)
@config.save

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
if clicked = 2
    runScript: "main_each.praat"
endif
