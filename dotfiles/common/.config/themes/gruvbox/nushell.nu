# Gruvbox Dark color theme for Nushell
# Based on https://github.com/morhetz/gruvbox

export def main [] { {
    separator: "#a89984"
    leading_trailing_space_bg: { attr: n }
    header: { fg: "#b8bb26" attr: b }
    empty: "#83a598"
    bool: {|| if $in { "#8ec07c" } else { "light_gray" } }
    int: "#a89984"
    filesize: {|e|
        if $e == 0b {
            "#a89984"
        } else if $e < 1mb {
            "#8ec07c"
        } else {{ fg: "#83a598" }}
    }
    duration: "#a89984"
    date: {|| (date now) - $in |
        if $in < 1hr {
            { fg: "#fb4934" attr: b }
        } else if $in < 6hr {
            "#fb4934"
        } else if $in < 1day {
            "#fabd2f"
        } else if $in < 3day {
            "#b8bb26"
        } else if $in < 1wk {
            { fg: "#b8bb26" attr: b }
        } else if $in < 6wk {
            "#8ec07c"
        } else if $in < 52wk {
            "#83a598"
        } else { "dark_gray" }
    }
    range: "#a89984"
    float: "#a89984"
    string: "#a89984"
    nothing: "#a89984"
    binary: "#a89984"
    cellpath: "#a89984"
    row_index: { fg: "#a89984" attr: n }
    record: "#a89984"
    list: "#a89984"
    block: "#a89984"
    hints: "dark_gray"
    search_result: { fg: "#fb4934" bg: "#a89984" }

    # Table elements - for consistent ls output appearance
    table_row_even: { fg: "#ebdbb2" bg: "#282828" }
    table_row_odd: { fg: "#ebdbb2" bg: "#32302f" }
    table_header_separator: "#a89984"
    table_cell_separator: "#a89984"

    shape_and: { fg: "#d3869b" attr: b }
    shape_binary: { fg: "#d3869b" attr: b }
    shape_block: { fg: "#83a598" attr: b }
    shape_bool: "#8ec07c"
    shape_custom: "#b8bb26"
    shape_datetime: { fg: "#8ec07c" attr: b }
    shape_directory: "#8ec07c"
    shape_external: "#8ec07c"
    shape_externalarg: { fg: "#b8bb26" attr: b }
    shape_filepath: "#a89984"  # Changed to match string color for consistency
    shape_flag: { fg: "#83a598" attr: b }
    shape_float: { fg: "#d3869b" attr: b }
    shape_garbage: { fg: "#FFFFFF" bg: "#FB4934" attr: b }
    shape_globpattern: { fg: "#8ec07c" attr: b }
    shape_int: { fg: "#d3869b" attr: b }
    shape_internalcall: { fg: "#8ec07c" attr: b }
    shape_list: { fg: "#8ec07c" attr: b }
    shape_literal: "#83a598"
    shape_match_pattern: "#b8bb26"
    shape_matching_brackets: { attr: u }
    shape_nothing: "#8ec07c"
    shape_operator: "#fabd2f"
    shape_or: { fg: "#d3869b" attr: b }
    shape_pipe: { fg: "#d3869b" attr: b }
    shape_range: { fg: "#fabd2f" attr: b }
    shape_record: { fg: "#8ec07c" attr: b }
    shape_redirection: { fg: "#d3869b" attr: b }
    shape_signature: { fg: "#b8bb26" attr: b }
    shape_string: "#a89984"  # Changed to match string color for consistency
    shape_string_interpolation: { fg: "#b8bb26" attr: n }
    shape_table: { fg: "#83a598" attr: b }
    shape_variable: "#d3869b"

    background: "#282828"
    foreground: "#ebdbb2"
    cursor: "#ebdbb2"
}}
