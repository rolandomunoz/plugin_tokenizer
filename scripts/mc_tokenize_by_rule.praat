#Include libraries
include ../procedures/config.proc
include ../procedures/get_tier_number.proc
include ../procedures/list_recursive_path.proc

form Tokenize tier
  comment Folder with annotation files:
  text tg_folder_path /home/user/Desktop/corpus
  boolean Recursive_search 0
  comment Tokenize TextGrid:
  word Input_tier phrase
  boolean Add_segment_tier 1
  boolean Add_syllable_tier 0
  boolean Add_word_tier 0
endform

# Open TextGrids one by one
@createStringAsFileList: "fileList",  tg_folder_path$ + "/*.TextGrid", recursive_search
fileList = selected("Strings")
nFiles = Get number of strings

# Save unprocessed files
tgList$ = ""

number_of_unprocessed_files = 0
for iFile to nFiles
    selectObject: fileList
    tg$ = object$[fileList, iFile]
    tgPath$ = tg_folder_path$ + "/" + tg$
    
    tg = Read from file: tgPath$
    getTierNumber.return[input_tier$] = 0
    # Check for the appropiate structure
    @getTierNumber
    input_tier= getTierNumber.return[input_tier$]

    if input_tier
      if add_word_tier
        runScript: "add_word_tier.praat", input_tier
      endif

      if add_syllable_tier
        runScript: "add_syllable_tier.praat", input_tier
      endif

      if add_segment_tier
        runScript: "add_segment_tier.praat", input_tier
      endif
      Save as text file: tgPath$
    else
      number_of_unprocessed_files += 1
      tgList$ = tgList$ + tg$ + newline$
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
  appendInfoLine: ""
  appendInfoLine: tgList$
endif
