include ./../../procedures/config.proc
include ./../../procedures/strings_object.proc
file_dir_config$  = "./../../.preferences/config.txt"

#Read from config.txt
@config.init: file_dir_config$

@config.get_field: "vowel"
vowel_list$ = config.get_field.return$
@config.get_field: "consonant.more_than_one_char"
consonant_list$ = config.get_field.return$

beginPause: "set segments"
    comment: "Set all characters that work as a vowel unit"
    sentence: "Vowels", vowel_list$
    comment: "Set which characters work as one consonant unit"
    sentence: "Consonants", consonant_list$
clicked = endPause: "Continue", "Quit", 1

#Sort vowels
@strings.create_Strings_from: vowels$, " "
tbID_vowel = selected("Strings")
@strings.sort_by_nchars: 0
tbID_vowel_sorted = selected("Strings")
@strings.get_string_var: " "
vowels$ = strings.get_string_var.return$
removeObject: tbID_vowel, tbID_vowel_sorted

#Sort consonants
@strings.create_Strings_from: consonants$, " "
tbID_consonants = selected("Strings")
@strings.sort_by_nchars: 0
tbID_consonants_sorted = selected("Strings")
@strings.get_string_var: " "
consonants$ = strings.get_string_var.return$
removeObject: tbID_consonants, tbID_consonants_sorted

#Store them in the config.txt
if clicked = 1
    @config.set_field: "vowel", vowels$
    @config.set_field: "consonant.more_than_one_char", consonants$
endif
