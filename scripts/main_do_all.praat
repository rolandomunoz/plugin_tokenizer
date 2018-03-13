#Include libraries
include ./../procedures/config.proc
include ./../procedures/get_tier_number.proc

# Read variables from preferences.txt
@config.init: "./../preferences.txt"

tg_folder_src$ = config.init.return$["doall_TextGrid_folder_directory"]
tg_folder_dst$ = config.init.return$["doall_destination_directory"]
src_tier$ = config.init.return$["doall_src_tier"]
add_segment_tier = number(config.init.return$["doall_add_segment_tier"])
add_syllable_tier = number(config.init.return$["doall_add_syllable_tier"])
add_word_tier = number(config.init.return$["doall_add_word_tier"])

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

@config.setField: "doall_TextGrid_folder_directory", textGrid_folder_directory$
@config.setField: "doall_destination_directory", destination_directory$
@config.setField: "doall_src_tier", input_tier$
@config.setField: "doall_add_segment_tier", string$(add_segment_tier)
@config.setField: "doall_add_syllable_tier", string$(add_syllable_tier)
@config.setField: "doall_add_word_tier", string$(add_word_tier)

#Open TextGrids one by one
fileList = Create Strings as file list: "fileList", textGrid_folder_directory$ + "/*.TextGrid"
nFiles = Get number of strings
number_of_unprocessed_files = 0
for iFile to nFiles
    selectObject: fileList
    tg_name$ = object$[fileList, iFile]
    tg_path_src$ = textGrid_folder_directory$ + "/" + tg_name$
    tg_path_dst$ = destination_directory$ + "/" + tg_name$
    
    tg = Read from file: tg_path_src$
    temp_input_tier$ = input_tier$
    getTierNumber.return[temp_input_tier$] = 0
    # Check for the appropiate structure
    @getTierNumber
    
    if getTierNumber.return[temp_input_tier$]
      if add_word_tier
        runScript: "add_word_tier.praat", temp_input_tier$
        temp_input_tier$ = "word"
      endif

      if add_syllable_tier
        runScript: "add_syllable_tier.praat", temp_input_tier$
        temp_input_tier$ = "syll"
      endif

      if add_segment_tier
        runScript: "add_segment_tier.praat", temp_input_tier$
      endif
      Save as text file: tg_path_dst$
    else
      number_of_unprocessed_files += 1
    endif
    removeObject: tg
endfor
removeObject: fileList

writeInfoLine: "The tokenization process is done."
if number_of_unprocessed_files
  appendInfoLine: "'number_of_unprocessed_files' TextGrid(s) couldn't be tokenized. Check the input tier."
endif