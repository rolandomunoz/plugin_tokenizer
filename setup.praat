# Copyright 2017 Rolando Munoz

if praatVersion < 6040
  appendInfoLine: "Plug-in name: Tokenizer"
  appendInfoLine: "WARNING: This plug-in only works on Praat version 6.0.40 or later. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif

# Commands
## Static menu
Add menu command: "Objects", "Goodies", "Tokenizer", "", 0, ""
Add menu command: "Objects", "Goodies", "Tokenize tier...", "Tokenizer", 1, "scripts/mc_tokenize_by_rule.praat"
Add menu command: "Objects", "Goodies", "Tokenize tier (dictionary)...", "Tokenizer", 1, "scripts/mc_tokenize_by_dict.praat"
Add menu command: "Objects", "Goodies", "Settings...", "Settings", 1, "./scripts/set_parsing.praat" 
Add menu command: "Objects", "Goodies", "-", "Tokenizer", 1, ""
Add menu command: "Objects", "Goodies", "About...", "Tokenizer", 1, "./scripts/about.praat"

# Dynamic menu
## TextGrids
Add action command: "TextGrid", 0, "", 0, "", 0, "Tokenizer", "", 0, ""
Add action command: "TextGrid", 0, "", 0, "", 0, "Tokenize tier (dictionary)...", "Tokenizer", 0, "scripts/ac_tokenize_by_dict.praat"
Add action command: "TextGrid", 0, "", 0, "", 0, "Tokenize tier...", "Tokenizer", 0, "scripts/ac_tokenize_by_rule.praat"

createDirectory: "temp"
