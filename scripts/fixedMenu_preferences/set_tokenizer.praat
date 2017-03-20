#Include libraries
include ./../../procedures/config.proc

#Read variables from config.txt
file_dir_config$  = "./../../.preferences/config.txt"
@config.init: file_dir_config$

@config.get_field: "src_tier2segment"
src_tier2segment$ = config.get_field.return$

@config.get_field: "src_tier2syllable"
src_tier2syllable$ = config.get_field.return$

@config.get_field: "src_tier2word"
src_tier2word$ = config.get_field.return$

@config.get_field: "add_tier2segment"
add_segment_tier = number(config.get_field.return$)

@config.get_field: "add_tier2syllable"
add_syllable_tier = number(config.get_field.return$)

@config.get_field: "add_tier2word"
add_word_tier = number(config.get_field.return$)

beginPause: "tokenizer preferences"
    comment: "The 'tier name' which serves as input to add a tokenized tier:"
    sentence: "Add word tier from", src_tier2word$
    boolean: "Add word tier", add_word_tier
    sentence: "Add syllable tier from", src_tier2syllable$
    boolean: "Add syllable tier", add_syllable_tier
    sentence: "Add segment tier from", src_tier2segment$ 
    boolean: "Add segment tier", add_segment_tier
clicked= endPause: "Continue", "Quit", 1

if clicked = 2
    exitScript()
endif

@config.set_field: "src_tier", input_tier$
@config.set_field: "add_segment_tier", string$(add_segment_tier)
@config.set_field: "add_syllable_tier", string$(add_syllable_tier)
@config.set_field: "add_word_tier", string$(add_word_tier)
