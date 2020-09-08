" Vim syntax file
" Language: Superfly Chord Chart
" Maintainer: Ifor Waldo Williams
" Latest Revision: 8 September 2020

if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "superfly"

syntax match sfKeyword "\(t\|title\|c\|composer\|te\|tempo\|ts\|time_signature\|k\|key\|g\|genre\):"
syntax match sfKeyword "\(.*\):"
highlight link sfKeyword Keyword

syntax match sfOperator ","
syntax match sfOperator "---"
syntax match sfOperator "+++"
highlight link sfOperator Operator
