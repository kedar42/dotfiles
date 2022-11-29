# DoomOne Color Palette
set -l foreground bbc2cf
set -l red ff6c6b
set -l orange da8548
set -l green 98be65
set -l teal 4db5bd
set -l yellow ECBE7B
set -l blue 51afef
set -l dark_blue 2257A0
set -l magenta c678dd
set -l violet a9a1e1
set -l cyan 46D9FF
set -l dark_cyan 5699AF

set -l selection $dark_blue
set -l comment $dark_cyan

# Syntax Highlighting Colors
set -gx fish_color_normal $foreground
set -gx fish_color_command $magenta
set -gx fish_color_keyword $blue
set -gx fish_color_quote $green
set -gx fish_color_redirection $cyan
set -gx fish_color_end $orange //??
set -gx fish_color_error $red
set -gx fish_color_param $red
set -gx fish_color_comment $comment
set -gx fish_color_selection --background=$selection
set -gx fish_color_search_match --background=$selection
set -gx fish_color_operator $magenta
set -gx fish_color_escape $cyan
set -gx fish_color_autosuggestion $comment
set -gx fish_color_cancel $red --reverse
set -gx fish_color_option $orange // ???

# Default Prompt Colors
set -gx fish_color_cwd $red
set -gx fish_color_host $blue
set -gx fish_color_host_remote $purple
set -gx fish_color_user $green

# Completion Pager Colors
set -gx fish_pager_color_progress $comment
set -gx fish_pager_color_background
set -gx fish_pager_color_prefix $cyan
set -gx fish_pager_color_completion $foreground
set -gx fish_pager_color_description $comment
set -gx fish_pager_color_selected_background --background=$selection
set -gx fish_pager_color_selected_prefix $cyan
set -gx fish_pager_color_selected_completion $foreground
set -gx fish_pager_color_selected_description $comment
set -gx fish_pager_color_secondary_background
set -gx fish_pager_color_secondary_prefix $cyan
set -gx fish_pager_color_secondary_completion $foreground
set -gx fish_pager_color_secondary_description $comment

