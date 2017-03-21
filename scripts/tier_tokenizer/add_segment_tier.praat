#Include libraries
include ./../../procedures/config.proc
include ./../../procedures/textgrid_object.proc
include ./../../procedures/tokenizer.proc

form Add segment tier
    sentence Input_tier
endform
src_tier$ = input_tier$

#Get ID object and tier position
tgID = selected("TextGrid")

#Read variables from config.txt
file_dir_config$  = "./../../.preferences/config.txt"
@config.init: file_dir_config$

@config.get_field: "vowel"
vowels$ = config.get_field.return$
vowels$ = replace$(vowels$, " ", "|", 0)

@config.get_field: "consonant.more_than_one_char"
consonants$ = config.get_field.return$
consonants$ = replace$(consonants$, " ", "|", 0)

segments$ = consonants$ + "|" +vowels$

#Read src tiers from tgs
selectObject: tgID
@tg.get_tier_number: src_tier$
src_tier = tg.get_tier_number.return
if not src_tier
    @tg.ask_tier_name: "source"
    src_tier = tg.ask_tier_name.return
endif

@tg.duplicate_tier: src_tier, "segment"
src_tier = tg.duplicate_tier.position_input
dst_tier = tg.duplicate_tier.position_output

nIntervals = Get number of intervals: src_tier
for interval to nIntervals
    selectObject: tgID
    interval_text$= Get label of interval: src_tier, interval
    tmin = Get start time of interval: src_tier, interval
    tmax = Get end time of interval: src_tier, interval
    tmid = (tmax - tmin)*0.5 + tmin
    
    if interval_text$ <> ""
        @tokenizer.string2segments: interval_text$, segments$, ",|\."
        strID_segments = selected("Strings")

        selectObject: strID_segments
        plusObject: tgID
        @tokenizer.Strings2TextGrid: dst_tier, tmid
        removeObject: strID_segments
    endif
endfor
