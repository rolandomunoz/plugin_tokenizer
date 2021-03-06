# Copyright 2017-2018 Rolando Munoz

form Tokenize tier (dictionary)
  comment Phonetic dictionary (csv):
  text Dictionary_path ../temp/dictionary.csv
  comment Tokenize TextGrid:
  natural Input_tier 1
  boolean Add_segment_tier 1
  boolean Add_syllable_tier 1
endform

# Remember that the position of the input_tier will increase by 3 when added the word, phon and syll tiers 
syll_tier = input_tier + 1
phon_tier = input_tier

#Select TextGrids
nSelected = numberOfSelected("TextGrid")
tg# = selected#("TextGrid")

# Check table
tb_phonetic = Read Table from comma-separated file: dictionary_path$
wordCol$ = "word"
pronunciationCol$ = "pronunciation"

selectObject: tg#
for i to nSelected
  selectObject: tg#[i]
  runScript: "add_phon&syll_by_dict.praat", input_tier, dictionary_path$, tb_phonetic
    
  if not add_syllable_tier
    Remove tier: syll_tier
  endif

  if not add_segment_tier
    Remove tier: phon_tier
  endif
endfor

selectObject: tb_phonetic
Save as comma-separated file: "../temp/dictionary.csv"

removeObject: tb_phonetic
selectObject: tg#
