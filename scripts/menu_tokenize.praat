#Include libraries
include ../procedures/config.proc
include ../procedures/get_tier_number.proc
include ../procedures/list_recursive_path.proc

form Tokenize tier
  comment Folder with annotation files:
  text tg_folder_path /home/rolando/Desktop/test
  boolean Recursive_search 0
  comment Tokenize TextGrid:
  word Input_tier phrase
  boolean Add_segment_tier 1
  boolean Add_syllable_tier 0
  boolean Add_word_tier 0
endform

# Save preferences
## Save fields in preferences.txt
@config.read: "../preferences.txt"
@config.set: "annotation_folder_path", tg_folder_path$
@config.set: "recursive_search", string$(recursive_search)
@config.set: "menu_input_tier", input_tier$
@config.set: "menu_add_segment_tier", string$(add_segment_tier)
@config.set: "menu_add_syllable_tier", string$(add_syllable_tier)
@config.set: "menu_add_word_tier", string$(add_word_tier)
@config.save

@config.read: "../preferences.txt"
script$ = readFile$("template_menu_tokenize.praat")
script$ = replace$(script$, "<tg_folder_path>", config.read.return$["annotation_folder_path"], 1)
script$ = replace$(script$, "<recursive_search>", config.read.return$["recursive_search"], 1)
script$ = replace$(script$, "<input_tier>", config.read.return$["menu_input_tier"], 1)
script$ = replace$(script$, "<add_segment_tier>", config.read.return$["menu_add_segment_tier"], 1)
script$ = replace$(script$, "<add_syllable_tier>", config.read.return$["menu_add_syllable_tier"], 1)
script$ = replace$(script$, "<add_word_tier>", config.read.return$["menu_add_word_tier"], 1)
writeFile: "menu_tokenize.praat", script$

# Open TextGrids one by one
@createStringAsFileList: "fileList",  tg_folder_path$ + "/*.TextGrid", recursive_search
fileList = selected("Strings")
nFiles = Get number of strings

number_of_unprocessed_files = 0
for iFile to nFiles
    selectObject: fileList
    tg$ = object$[fileList, iFile]
    tgPath$ = tg_folder_path$ + "/" + tg$
    
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
      Save as text file: tgPath$
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
