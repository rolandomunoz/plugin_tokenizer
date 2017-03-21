#Include libraries
include ./../../procedures/config.proc
include ./../../procedures/textgrid_object.proc

#SelectObject
tgID = selected("TextGrid")

#Read variables from config.txt
file_dir_config$  = "./../../.preferences/config.txt"
@config.init: file_dir_config$

@config.get_field: "each_src_tier"
src_tier$ = config.get_field.return$

@config.get_field: "each_add_segment_tier"
add_segment_tier = number(config.get_field.return$)

@config.get_field: "each_add_syllable_tier"
add_syllable_tier = number(config.get_field.return$)

@config.get_field: "each_add_word_tier"
add_word_tier = number(config.get_field.return$)

selectObject: tgID
beginPause: "Add tokenized tiers..."
    sentence: "Input tier", src_tier$
    boolean: "Add word tier", add_word_tier
    boolean: "Add syllable tier", add_syllable_tier
    boolean: "Add segment tier", add_segment_tier
clicked= endPause: "Continue", "Quit", 1

if clicked = 2
    exitScript()
endif

@config.set_field: "each_src_tier", input_tier$
@config.set_field: "each_add_segment_tier", string$(add_segment_tier)
@config.set_field: "each_add_syllable_tier", string$(add_syllable_tier)
@config.set_field: "each_add_word_tier", string$(add_word_tier)

selectObject: tgID
if add_word_tier
    runScript: "add_word_tier.praat", input_tier$
    input_tier$ = "word"
endif

if add_syllable_tier
   runScript: "add_syllable_tier.praat", input_tier$
    input_tier$ = "syllable"
endif

if add_segment_tier
    runScript: "add_segment_tier.praat", input_tier$
endif
