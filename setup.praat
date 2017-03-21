menu_preferences$ = "./scripts/menu_preferences/"
tkn_script$ = "./scripts/tier_tokenizer/"

##Static menu
Add menu command: "Objects", "Praat", "-", "", 0, ""
Add menu command: "Objects", "Praat", "Tokenizer", "", 0, ""

Add menu command: "Objects", "Praat", "Settings", "Tokenizer", 1, ""
Add menu command: "Objects", "Praat", "Set segments...", "Settings", 2, menu_preferences$ + "set_segments_chars.praat"

Add menu command: "Objects", "Praat", "-", "Tokenizer", 1, ""
Add menu command: "Objects", "Praat", "Tokenize various TextGrids...", "Tokenizer", 1, tkn_script$ + "main_do_all.praat"

Add menu command: "Objects", "Praat", "-", "Tokenizer", 1, ""
Add menu command: "Objects", "Praat", "About...", "Tokenizer", 1, "./scripts/about.praat"

# Dynamic menu
## Object class
### TextGrid
Add action command: "TextGrid", 0, "", 0, "", 0, "Tokenizer", "", 0, ""
Add action command: "TextGrid", 1, "", 0, "", 0, "Add tokenized tier...", "Tokenizer", 0, tkn_script$ + "main_each.praat"
