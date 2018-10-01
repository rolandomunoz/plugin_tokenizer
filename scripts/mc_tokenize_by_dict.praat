#Copyright 2018 Rolando Munoz

#Include libraries
include ../procedures/config.proc
include ../procedures/get_tier_number.proc
include ../procedures/list_recursive_path.proc

form Tokenize tier (dictionary)
  comment Phonetic dictionary (csv):
  text Dictionary_path ../temp/dictionary.csv
  comment Folder with annotation files:
  text tg_folder_path /home/user/Desktop/corpus
  boolean Recursive_search 0
  comment Tokenize TextGrid:
  word Input_tier phrase
  boolean Add_segment_tier 1
  boolean Add_syllable_tier 1
  boolean Add_word_tier 0
endform

# Open TextGrids one by one
@createStringAsFileList: "fileList",  tg_folder_path$ + "/*.TextGrid", recursive_search
fileList = selected("Strings")
nFiles = Get number of strings

# Check table
wordCol$ = "word"
pronunciationCol$ = "pronunciation"
tb_phonetic = Read Table from comma-separated file: dictionary_path$

is_word= Get column index: wordCol$
is_pronunciation= Get column index: pronunciationCol$

if not is_word or not is_pronunciation
  writeInfoLine: "The phonetic dictionary must contain the columns <'wordCol$'> and <'pronunciationCol$'>"
  exitScript()
endif

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
  input_tier = getTierNumber.return[input_tier$]
  word_tier = input_tier + 2
  syll_tier = input_tier + 1
  phon_tier = input_tier

  if input_tier
    runScript: "add_word_tier.praat", input_tier
    runScript: "add_phon&syll_by_dict.praat", input_tier, dictionary_path$, tb_phonetic
    
    if not add_word_tier
      Remove tier: word_tier
    endif
    
    if not add_syllable_tier
      Remove tier: syll_tier
    endif

    if not add_segment_tier
      Remove tier: phon_tier
    endif
    Save as text file: tgPath$
  else
    number_of_unprocessed_files += 1
    tgList$ = tgList$ + tg$ + newline$
  endif
  removeObject: tg
endfor

selectObject: tb_phonetic
Save as comma-separated file: "../temp/dictionary.csv"
removeObject: fileList, tb_phonetic

writeInfoLine: "Tokenize tier (dictionary)..."
appendInfoLine: "Number of files: ", nFiles
appendInfoLine: "Number of tokenized files: ", nFiles - number_of_unprocessed_files

if number_of_unprocessed_files
  appendInfoLine: ""
  appendInfoLine: "WARNING: There are 'number_of_unprocessed_files' TextGrid files that couldn't be tokenized."
  appendInfoLine: ""
  appendInfoLine: tgList$
endif
