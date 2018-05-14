# Copyright 2017 Rolando Munoz

if praatVersion < 6040
  appendInfoLine: "Plug-in name: Finder"
  appendInfoLine: "WARNING: This plug-in only works on Praat version 6.0.39 or later. Please, get a more recent version of Praat."
  appendInfoLine: "Praat website: http://www.fon.hum.uva.nl/praat/"
endif

# Commands
## Static menu
Add menu command: "Objects", "Goodies", "Tokenizer", "", 0, ""
Add menu command: "Objects", "Goodies", "Tokenize (do all)...", "Tokenizer", 1, "scripts/main_do_all.praat"
Add menu command: "Objects", "Goodies", "Settings...", "Settings", 1, "./scripts/set_parsing.praat" 
Add menu command: "Objects", "Goodies", "-", "Tokenizer", 1, ""
Add menu command: "Objects", "Goodies", "About...", "Tokenizer", 1, "./scripts/about.praat"

# Dynamic menu
## TextGrids
Add action command: "TextGrid", 0, "", 0, "", 0, "Tokenizer", "", 0, ""
Add action command: "TextGrid", 0, "", 0, "", 0, "Insert tokenized tier...", "Tokenizer", 0, "scripts/main_each.praat"

createDirectory: "temp"
