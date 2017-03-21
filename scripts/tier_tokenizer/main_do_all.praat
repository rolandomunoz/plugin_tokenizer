#Include libraries
include ./../../procedures/config.proc
include ./../../procedures/textgrid_object.proc

#Read variables from config.txt
file_dir_config$  = "./../../.preferences/config.txt"
@config.init: file_dir_config$

@config.get_field: "doall_TextGrid_folder_directory"
tg_folder_src$ = config.get_field.return$

@config.get_field: "doall_destination_directory"
tg_folder_dst$ = config.get_field.return$

@config.get_field: "doall_src_tier"
src_tier$ = config.get_field.return$

@config.get_field: "doall_add_segment_tier"
add_segment_tier = number(config.get_field.return$)

@config.get_field: "doall_add_syllable_tier"
add_syllable_tier = number(config.get_field.return$)

@config.get_field: "doall_add_word_tier"
add_word_tier = number(config.get_field.return$)

beginPause: "tokenizer"
    comment: "Set the directories"
    sentence: "TextGrid folder directory", tg_folder_src$
    sentence: "Destination directory", tg_folder_dst$
    comment: "Add tokenized tiers"
    sentence: "Input tier", src_tier$
    boolean: "Add word tier", add_word_tier
    boolean: "Add syllable tier", add_syllable_tier
    boolean: "Add segment tier", add_segment_tier
clicked= endPause: "Continue", "Quit", 1

if clicked = 2
    exitScript()
endif

@config.set_field: "doall_TextGrid_folder_directory", textGrid_folder_directory$
@config.set_field: "doall_destination_directory", destination_directory$
@config.set_field: "doall_src_tier", input_tier$
@config.set_field: "doall_add_segment_tier", string$(add_segment_tier)
@config.set_field: "doall_add_syllable_tier", string$(add_syllable_tier)
@config.set_field: "doall_add_word_tier", string$(add_word_tier)

#Open TextGrids one by one
strID_files = Create Strings as file list: "fileList", textGrid_folder_directory$ + "/*.TextGrid"
nStrings = Get number of strings
for iString to nStrings
    tg_name$ = Get string: iString
    tg_path_src$ = textGrid_folder_directory$ + "/" + tg_name$
    tg_path_dst$ = destination_directory$ + "/" + tg_name$
    tgID = Read from file: tg_path_src$
    # Check for the appropiate structure
    @tg.get_tier_number: input_tier$
    if tg.get_tier_number.return
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
        Save as text file: tg_path_dst$
    endif
    removeObject: tgID
endfor
removeObject: strID_files
