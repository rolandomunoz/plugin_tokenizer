# Copyright 2017-2018 Rolando Munoz
include ./../procedures/string2interval.proc

form Add syll & phon tier
  natural Src_tier 1
  comment Phonetic dictionary (csv):
  text Dictionary_path ../temp/urarina.csv
  integer Dictionary_ID 0
endform

phon_tier$ = "phon"
syll_tier$ = "syll"

tg = selected("TextGrid")
Duplicate tier: src_tier, src_tier, syll_tier$
Duplicate tier: src_tier, src_tier, phon_tier$

src_tier +=2
syll_tier = src_tier - 1
phon_tier = src_tier - 2

if dictionary_ID > 0
  tb_dict = dictionary_ID
else
  tb_dict = Read Table from comma-separated file: dictionary_path$
endif
wordCol$ = "word"
pronunciationCol$ = "pronunciation"

# Segment texts from intervals into phonemes
selectObject: tg
nIntervals = Get number of intervals: src_tier
for interval to nIntervals
  selectObject: tg
  label$= Get label of interval: src_tier, interval
  tmin = Get start time of interval: src_tier, interval
  tmax = Get end time of interval: src_tier, interval
  tmid = (tmax + tmin)*0.5
  dur = tmax-tmin
  if label$ <> ""
    selectObject: tb_dict
    isWord = Search column: wordCol$, label$

    if isWord
      row = isWord
      wordParsed$ = object$[tb_dict, row, pronunciationCol$] + " ."
      tokenList = Create Strings as tokens: wordParsed$, " "
      nTokens = Get number of strings

      distribution = To Distributions
      syllBreak_row = Get row index: "."
      nSyll = Get value: syllBreak_row, 1
      nPhon = (nTokens - nSyll)
      durPhon = dur/nPhon
      
      selectObject: tg
      syll$ = ""
      for iToken to nTokens
        token$ = object$[tokenList, iToken]
        tmin += if token$ == "." then 0 else durPhon fi
        syll$ = if token$ == "." then syll$ else syll$ + token$ fi
        dst_tier = if token$ == "." then syll_tier else phon_tier fi
        label$ = if token$ == "." then syll$ else token$ fi

        dst_lowInterval = Get low interval at time: dst_tier, tmax
        Set interval text: dst_tier, dst_lowInterval, label$
        if iToken < nTokens - 1
          Insert boundary: dst_tier, tmin
        endif
        syll$ = if token$ == "." then "" else syll$ fi
      endfor
      removeObject: tokenList, distribution
    else
        selectObject: tg
        phon_interval = Get interval at time: phon_tier, tmid
        syll_interval = Get interval at time: syll_tier, tmid
        Set interval text: phon_tier, phon_interval, "-"
        Set interval text: syll_tier, syll_interval, "-"
    endif
  endif
  selectObject: tg
endfor

if dictionary_ID <= 0
  removeObject: tb_dict
endif
selectObject: tg
