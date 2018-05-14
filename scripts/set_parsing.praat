# Copyright 2017 Rolando Munoz

include ./../procedures/config.proc
include ./../procedures/sort_string_by_length.proc
include ./../procedures/join_strings.proc

@config.read: "../preferences.txt"

beginPause: "Parse settings"
  comment: "Vowels:"
  comment: "Any character not considered here is a consonant..."
  sentence: "Vowels", config.read.return$["vowel"]
  comment: "Consonants:"
  comment: "Two or more characters that behaves as a consonant unit..."
  sentence: "Consonants", config.read.return$["consonant.complex"]
  comment: "Syllable:"
  comment: "Which consonant clusters are allowed as complex onsets..."
  sentence: "Complex onsets",  config.read.return$["syllable.complex.onset"]
  boolean: "Allow coda", config.read.return["coda.boolean"]
clicked = endPause: "Cancel","Apply", "Ok", 1

if clicked = 1
  exitScript()
endif

# Check
if !length(vowels$)
  pauseScript: "Tokenizer: complete the vowel field first"
  runScript: "set_parsing.praat"
  exitScript()
endif

# Sort vowels by length
str = Create Strings as tokens: vowels$
@sortStringByLength: 0
str_sorted = selected("Strings")
@joinStrings: " "
vowels$ = joinStrings.return$
removeObject: str, str_sorted

# Sort consonant by length
str = Create Strings as tokens: consonants$
@sortStringByLength: 0
str_sorted = selected("Strings")
@joinStrings: " "
consonants$ = joinStrings.return$
removeObject: str, str_sorted

# Sort segments
phon$ = if length(consonants$) then vowels$ + " " + consonants$ else vowels$ fi
str = Create Strings as tokens: phon$
@sortStringByLength: 0
str_sorted = selected("Strings")
@joinStrings: " "
phon$ = joinStrings.return$
removeObject: str, str_sorted

# Sort complex_onset by length
str = Create Strings as tokens: complex_onsets$
@sortStringByLength: 0
str_sorted = selected("Strings")
@joinStrings: " "
complex_onsets$ = joinStrings.return$
removeObject: str, str_sorted

# Sort complex_onset plus complex_consonants by length
complex_onset_all$ = if length(consonants$) then complex_onsets$ + " " + consonants$ else complex_onsets$ fi
str = Create Strings as tokens: complex_onset_all$
@sortStringByLength: 0
str_sorted = selected("Strings")
@joinStrings: " "
complex_onset_all$ = joinStrings.return$
removeObject: str, str_sorted

# Save in preferences values
@config.set: "vowel", vowels$
@config.set: "phonemes", phon$
@config.set: "consonant.complex", consonants$
@config.set: "syllable.complex.onset", complex_onsets$
@config.set: "syllable.complex.onset.all", complex_onset_all$
@config.set: "coda.boolean", string$(allow_coda)
@config.save

if clicked
  runScript: "set_parsing.praat"
endif
