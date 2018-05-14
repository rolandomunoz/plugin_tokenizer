#Include libraries
include ../procedures/config.proc
include ../procedures/get_tier_number.proc

# Read variables from preferences.txt
@config.read: "../preferences.txt"

beginPause: "Tokenize (Do all)"
  sentence: "Folder with annotation files", config.read.return$["doall_TextGrid_folder_directory"]
  sentence: "Save results in", config.read.return$["doall_destination_directory"]
  comment: "Add tokenized tiers"
  sentence: "Input tier", config.read.return$["doall_src_tier"]
  boolean: "Add segment tier", config.read.return["doall_add_segment_tier"]
  boolean: "Add syllable tier", config.read.return["doall_add_syllable_tier"]
  boolean: "Add word tier", config.read.return["doall_add_word_tier"]
clicked= endPause: "Cancel", "Apply","Ok", 3

if clicked = 1
  exitScript()
endif

# Save in preferences values
@config.set: "doall_TextGrid_folder_directory", folder_with_annotation_files$
@config.set: "doall_destination_directory", save_results_in$
@config.set: "doall_src_tier", input_tier$
@config.set: "doall_add_segment_tier", string$(add_segment_tier)
@config.set: "doall_add_syllable_tier", string$(add_syllable_tier)
@config.set: "doall_add_word_tier", string$(add_word_tier)
@config.save

#Open TextGrids one by one
fileList = Create Strings as file list: "fileList", folder_with_annotation_files$ + "/*.TextGrid"
nFiles = Get number of strings
number_of_unprocessed_files = 0
for iFile to nFiles
    selectObject: fileList
    tg$ = object$[fileList, iFile]
    tgPath$ = folder_with_annotation_files$ + "/" + tg$
    tgPathDst$ = save_results_in$ + "/" + tg$
    
    tg = Read from file: tgPath$
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
      Save as text file: tgPathDst$
    else
      number_of_unprocessed_files += 1
    endif
    removeObject: tg
endfor
removeObject: fileList

writeInfoLine: "Tokenize (Do all)"
appendInfoLine: "Number of files: ", nFiles
appendInfoLine: "Number of tokenized files: ", nFiles - number_of_unprocessed_files

if number_of_unprocessed_files
  appendInfoLine: ""
  appendInfoLine: "WARNING: There are 'number_of_unprocessed_files' TextGrid files that couldn't be tokenized."
endif

if clicked = 2
  runScript: "main_do_all.praat"
endif
