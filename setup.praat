# Copyright 2017 Rolando Munoz

if praatVersion < 6040
  appendInfoLine: "Plug-in name: Tokenizer"
  appendInfoLine: "WARNING: This plug-in only works on Praat version 6.0.40 or later. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif

# Commands
## Static menu
Add menu command: "Objects", "Goodies", "Tokenizer", "", 0, ""
Add menu command: "Objects", "Goodies", "Add word tier...", "Tokenizer", 1, "scripts/mc_add_word_tier.praat"
Add menu command: "Objects", "Goodies", "Add phon/syll tier (dictionary)...", "Tokenizer", 1, "scripts/mc_tokenize_by_dict.praat"
Add menu command: "Objects", "Goodies", "-", "Tokenizer", 1, ""
Add menu command: "Objects", "Goodies", "Add phon/syll tier (by rules)...", "Tokenizer", 1, "scripts/mc_tokenize_by_rule.praat"
Add menu command: "Objects", "Goodies", "Settings...", "Settings", 1, "./scripts/set_parsing.praat" 
Add menu command: "Objects", "Goodies", "-", "Tokenizer", 1, ""
Add menu command: "Objects", "Goodies", "About...", "Tokenizer", 1, "./scripts/about.praat"

# Dynamic menu
## TextGrids
Add action command: "TextGrid", 0, "", 0, "", 0, "Tokenizer", "", 0, ""
Add action command: "TextGrid", 0, "", 0, "", 0, "Add tier -", "Tokenizer", 0, ""
Add action command: "TextGrid", 0, "", 0, "", 0, "Add word tier...", "Add tier -", 1, "scripts/ac_add_word_tier.praat"
Add action command: "TextGrid", 0, "", 0, "", 0, "Add phon/syll tier (dictionary)...", "Add tier -", 1, "scripts/ac_tokenize_by_dict.praat"
Add action command: "TextGrid", 0, "", 0, "", 0, "Add phon/syll tier (by rules)...", "Add tier -", 1, "scripts/ac_tokenize_by_rule.praat"
