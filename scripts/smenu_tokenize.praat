#Include libraries
include ../procedures/config.proc
include ../procedures/get_tier_number.proc
include ../procedures/list_recursive_path.proc

form Tokenize tier
  sentence Folder_with_annotation_files
  comment Add tiers:
  sentence Input_tier phrase
  boolean Add_segment_tier 1
  boolean Add_syllable_tier 0
  boolean Add_word_tier 0
endform

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
