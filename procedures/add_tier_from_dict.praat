# Copyright 2017-2018 Rolando Munoz
include ./../procedures/get_tier_number.proc

form Add tier
  comment Phonetic dictionary (csv):
  text tablePhonetic ../temp/urarina.csv
  sentence Input_tier syll
  optionmenu Level 1
    option phon
    option syll
endform

# Variables
src_tier$ = input_tier$
wordCol$ = "word"
pronunciationCol$ = "pronunciation"
tg = selected("TextGrid")
object$ = selected$("TextGrid")

tb_phonetic = Read Table from comma-separated file: tablePhonetic$
is_word= Get column index: wordCol$
is_pronunciation= Get column index: pronunciationCol$

# Check table
if not is_word or not is_pronunciation
  writeInfoLine: "The phonetic dictionary must contain the columns <'wordCol$'> and <'pronunciationCol$'>"
  exitScript()
endif

is_column= Get column index: level$

if not is_column
  Append column: level$
  if level$ == "phon"
    Formula: level$, ~replace$(self$["word_sampa"], " . ", " ", 0)
  elsif level$ == "syll"
    Formula: level$, ~replace$(self$["word_sampa"], ".", "<-.->", 0)
    Formula: level$, ~replace$(self$[level$], " ", "", 0)
    Formula: level$, ~replace$(self$[level$], "<-.->", " ", 0)
  endif
  Save as comma-separated file: tablePhonetic$
endif

# Get the source tier and create a duplicate tier
## Get tier number from tier name
selectObject: tg
getTierNumber.return[src_tier$] = 0
@getTierNumber
src_tier = getTierNumber.return[src_tier$]

## Check if the tier name is not found, the exit the script
if not src_tier
  writeInfoLine: "The file 'object$'.TextGrid does not contain the tier <'src_tier$'>."
  exitScript()
endif

## Duplicate tier
Duplicate tier: src_tier, src_tier, level$
dst_tier = src_tier 
src_tier += 1

# Segment texts from intervals into phonemes
nIntervals = Get number of intervals: src_tier
for interval to nIntervals
  selectObject: tg
  label$= Get label of interval: src_tier, interval
  tmin = Get start time of interval: src_tier, interval
  tmax = Get end time of interval: src_tier, interval
  tmid = (tmax + tmin)*0.5
  dur = tmax-tmin

  if label$ <> ""
    selectObject: tb_phonetic
    isWord = Search column: wordCol$, label$
    if isWord
      row = isWord
      wordParsed$ = object$[tb_phonetic, row, level$]
      tokenList = Create Strings as tokens: wordParsed$, " "
      nTokens = Get number of strings
      durToken = dur/nTokens
      selectObject: tg
      for iToken to nTokens
        tmin+= durToken
        token$ = object$[tokenList, iToken]
        lowInterval = Get low interval at time: dst_tier, tmax
        if iToken < nTokens
          Insert boundary: dst_tier, tmin
        endif
        Set interval text: dst_tier, lowInterval, token$
      endfor
      removeObject: tokenList
    else
      selectObject: tg
      dst_interval = Get interval at time: dst_tier, tmid
      Set interval text: dst_tier, dst_interval, "#"
    endif
  endif
endfor

removeObject: tb_phonetic
selectObject: tg
