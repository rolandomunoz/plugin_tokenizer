include ./../../procedures/config.proc
file_dir_config$  = "./../../.preferences/config.txt"

@config.init: file_dir_config$

@config.get_field: "tg_folder_dir"
tg_folder$ = config.get_field.return$
@config.get_field: "sd_folder_dir"
sd_folder$ = config.get_field.return$

beginPause: "preferences"
    sentence: "TextGrid folder directory", tg_folder$
    sentence: "Sound folder directory", sd_folder$
clicked = endPause: "Continue", "Quit", 1

if clicked = 1
    @config.set_field: "tg_folder_dir", textGrid_folder_directory$
    @config.set_field: "sd_folder_dir", sound_folder_directory$
endif