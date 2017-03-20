#Include libraries
include ./../../procedures/config.proc
include ./../../procedures/textgrid_object.proc
include ./../../procedures/tokenizer.proc

form Add word tier
    sentence Input_tier
endform
src_tier$ = input_tier$

#Get ID object and tier position
tgID = selected("TextGrid")

#Read variables from config.txt
file_dir_config$  = "./../../.preferences/config.txt"

#Read src tiers from tgs
selectObject: tgID
@tg.get_tier_number: src_tier$
src_tier = tg.get_tier_number.return
if not src_tier
    @tg.ask_tier_name: "source"
    src_tier = tg.ask_tier_name.return
endif

@tg.duplicate_tier: src_tier, "word"
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
        @tokenizer.string2words: interval_text$, ",|\."
        strID_words = selected("Strings")

        selectObject: strID_words
        plusObject: tgID
        @tokenizer.Strings2TextGrid: dst_tier, tmid
        removeObject: strID_words
    endif
endfor
