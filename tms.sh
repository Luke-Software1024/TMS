#!/usr/bin/env bash

function error() {
    error=$1
    echo "Error: $error" >&2
    exit 1
}

function prevcol() {
    local color i j
    
    # Print dark colors
    echo "16-color palette:"
    for color in {0..7}; do
        printf "\e[3$color\0m" # the null byte is neccessary, so the 'm' isn't interpreted as part of a variable name.
        printf "\e[4$color\0m"
        printf "EE" # At this point, the bg and fg are set to the same thing, so it appears like a block.
    done
    printf "\r\n\e[0m" # newline, clear formatting
    # Print light colors
    for color in {0..7}; do
        printf "\e[9$color\0m"
        printf "\e[10$color\0m"
        printf "EE"
    done
    printf "\r\n\e[0m"
    
    # Print 256 colors
    echo "256-color palette:"
    for i in {0..15}; do
        for j in {0..15}; do
            color=$(( i*16 + j ))
            printf "\e[38;5;$color\0m"
            printf "\e[48;5;$color\0m"
            printf "EE"
        done
        printf "\r\n"
    done
    printf "\e[0m"
}

# Print text formatting
function prevfmt() {
    echo "Text styles:"
    printf "\e[1m\0Bold\e[0m\r\n"
    printf "\e[4m\0Underline\e[0m\r\n"
    printf "\e[5m\0Blinking\e[0m\r\n"
    printf "\e[7m\0Inverted\e[0m\r\n"
    printf "\e[3m\0Italic\e[0m\r\n"
}

function help() {
    echo "Commands:"
    echo "prevcol = preview color palettes"
    echo "prevfmt = preview text formats"
    echo "help = you're running this right now"
    echo "setcol = set a color in the palette"
    echo "setfmt = set a special formatting color"
    echo "resetcol = reset a color to default"
    echo "resetfmt = reset a special color to default"
    echo "exitsh = exit the shell"
    printf "\r\n"
    echo "Colors:"
    echo "0-3: black, dark red, dark green, dark yellow"
    echo "4-7: dark blue, dark purple, dark cyan, light gray"
    echo "8-11: dark gray, red, green, yellow"
    echo "12-15: blue, purple, cyan, white"
    printf "\r\n"
    echo "Special colors:"
    echo "0, 1: bold, underline"
    echo "2-4: blinking, inverted, italic"
}

function setcol() {
    local color=$1
    local colors=("black" "dark red" "dark green" "dark yellow"
    "dark blue" "dark purple" "dark cyan" "light gray"
    "dark gray" "red" "green" "yellow"
    "blue" "purple" "cyan" "white")
    echo "Editing color $color"
    echo "Suggested: ${colors[color]}"
    echo "Color can be 12-, 24-, 36-, or 48-bit hex"
    echo "Examples: \"96f\", \"09ffbc\""
    printf "Color: "; read value
    printf "\e]4;$color;#$value\e\\" # actually change it
    printf "\r\n"
}

function setfmt() {
    local fmt=$1
    local fmts=("Bold" "Underline" "Blinking" "Inverted" "Italic")
    echo "Editing special color for: ${fmts[fmt]}"
    echo "Color can be 12-, 24-, 36-, or 48-bit hex"
    echo "Examples: \"96f\", \"09ffbc\""
    printf "Color: "; read value
    printf "\e]5;$fmt;#$value\e\\" # actually change it
    printf "\r\n"
}

function resetcol() {
    local color=$1
    local colors=("black" "dark red" "dark green" "dark yellow"
    "dark blue" "dark purple" "dark cyan" "light gray"
    "dark gray" "red" "green" "yellow"
    "blue" "purple" "cyan" "white")
    printf "\e]104;$color\e\\" # actually reset it
    printf "Reset color: ${colors[color]}\r\n"
}

function resetfmt() {
    local fmt=$1
    local fmts=("Bold" "Underline" "Blinking" "Inverted" "Italic")
    printf "\e]105;$fmt\e\\" # actually reset it
    printf "Reset special color for: ${fmts[fmt]}\r\n"
}

function exitsh() {
    exit 0
}

echo "Welcome to the terminal modifier shell. Type \`help\` for help."
while true; do
    printf "tms > "
    read command
    $command
done
