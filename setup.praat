##Static menu
Add menu command: "Objects", "Praat", "-", "", 0, ""
Add menu command: "Objects", "Praat", "Tokenizer", "", 0, ""

menu_preferences$ = "./scripts/fixedMenu_preferences/"

Add menu command: "Objects", "Praat", "Settings", "Tokenizer", 1, ""
Add menu command: "Objects", "Praat", "Set working directory...", "Settings", 2, menu_preferences$ + "set_working_directory.praat"
Add menu command: "Objects", "Praat", "Set segment inventory...", "Settings", 2, menu_preferences$ + "set_segments_chars.praat"
Add menu command: "Objects", "Praat", "Set tokenizer...", "Settings", 2, menu_preferences$ + "set_tokenizer.praat"

Add menu command: "Objects", "Praat", "-", "Tokenizer", 1, ""
Add menu command: "Objects", "Praat", "About...", "Tokenizer", 1, "./scripts/about.praat"

# Dynamic menu
## Object class
### TextGrid
tokenizer_path$ = "./scripts/dynamicMenu_add_tokenized_tier/"
Add action command: "TextGrid", 0, "", 0, "", 0, "Tokenizer", "", 0, ""
Add action command: "TextGrid", 1, "", 0, "", 0, "Add tokenized tier...", "Tokenizer", 0, tokenizer_path$ + "main.praat"
