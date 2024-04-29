$env.LS_COLORS = (@vivid@ generate catppuccin-@ctpFlavor@)
$env.config = ($env.config | merge {color_config: {
    separator: "#@overlay0@"
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: "#@blue@" attr: "b" }
    empty: "#@lavender@"
    bool: "#@lavender@"
    int: "#@peach@"
    duration: "#@text@"
    filesize: {|e|
          if $e < 1mb {
            "#@green@"
        } else if $e < 100mb {
            "#@yellow@"
        } else if $e < 500mb {
            "#@peach@"
        } else if $e < 800mb {
            "#@maroon@"
        } else if $e > 800mb {
            "#@red@"
        }
    }
    date: {|| (date now) - $in |
        if $in < 1hr {
            "#@green@"
        } else if $in < 1day {
            "#@yellow@"
        } else if $in < 3day {
            "#@peach@"
        } else if $in < 1wk {
            "#@maroon@"
        } else if $in > 1wk {
            "#@red@"
        }
    }
    range: "#@text@"
    float: "#@text@"
    string: "#@text@"
    nothing: "#@text@"
    binary: "#@text@"
    cellpath: "#@text@"
    row_index: { fg: "#@mauve@" attr: "b" }
    record: "#@text@"
    list: "#@text@"
    block: "#@text@"
    hints: "#@overlay1@"
    search_result: { fg: "#@red@" bg: "#@text@" }

    shape_and: { fg: "#@pink@" attr: "b" }
    shape_binary: { fg: "#@pink@" attr: "b" }
    shape_block: { fg: "#@blue@" attr: "b" }
    shape_bool: "#@teal@"
    shape_custom: "#@green@"
    shape_datetime: { fg: "#@teal@" attr: "b" }
    shape_directory: "#@teal@"
    shape_external: "#@teal@"
    shape_externalarg: { fg: "#@green@" attr: "b" }
    shape_filepath: "#@teal@"
    shape_flag: { fg: "#@blue@" attr: "b" }
    shape_float: { fg: "#@pink@" attr: "b" }
    shape_garbage: { fg: "#@text@" bg: "#@red@" attr: "b" }
    shape_globpattern: { fg: "#@teal@" attr: "b" }
    shape_int: { fg: "#@pink@" attr: "b" }
    shape_internalcall: { fg: "#@teal@" attr: "b" }
    shape_list: { fg: "#@teal@" attr: "b" }
    shape_literal: "#@blue@"
    shape_match_pattern: "#@green@"
    shape_matching_brackets: { attr: "u" }
    shape_nothing: "#@teal@"
    shape_operator: "#@peach@"
    shape_or: { fg: "#@pink@" attr: "b" }
    shape_pipe: { fg: "#@pink@" attr: "b" }
    shape_range: { fg: "#@peach@" attr: "b" }
    shape_record: { fg: "#@teal@" attr: "b" }
    shape_redirection: { fg: "#@pink@" attr: "b" }
    shape_signature: { fg: "#@green@" attr: "b" }
    shape_string: "#@green@"
    shape_string_interpolation: { fg: "#@teal@" attr: "b" }
    shape_table: { fg: "#@blue@" attr: "b" }
    shape_variable: "#@pink@"

    background: "#@base@"
    foreground: "#@text@"
    cursor: "#@blue@"
}})
