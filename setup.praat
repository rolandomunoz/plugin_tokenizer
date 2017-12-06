##Static menu
Add menu command: "Objects", "Praat", "-", "", 0, ""
Add menu command: "Objects", "Praat", "Tokenizer", "", 0, ""

Add menu command: "Objects", "Praat", "-", "Tokenizer", 1, ""
Add menu command: "Objects", "Praat", "Tokenize TextGrids from folder...", "Tokenizer", 1, "scripts/main_do_all.praat"

Add menu command: "Objects", "Praat", "Settings...", "Settings", 1, "./scripts/settings.praat" 

Add menu command: "Objects", "Praat", "-", "Tokenizer", 1, ""
Add menu command: "Objects", "Praat", "About...", "Tokenizer", 1, "./scripts/about.praat"

# Dynamic menu
## Object class
### TextGrid
Add action command: "TextGrid", 0, "", 0, "", 0, "Tokenizer", "", 0, ""
Add action command: "TextGrid", 0, "", 0, "", 0, "Add tokenized tier...", "Tokenizer", 0, "scripts/main_each.praat"
