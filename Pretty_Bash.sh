#!/bin/bash

Pretty_title() {
    echo ;
    echo ---------------------------------------------------------------- ;
    echo $1
    echo ---------------------------------------------------------------- ;
    echo ; 
}

Pretty_1statement() {
    echo [][][][][][][][][][][][][][][][][][][][][][][][] ;
    echo ;
    echo $1 ;
    echo ;
    echo [][][][][][][][][][][][][][][][][][][][][][][][] ;
}

Pretty_2statements() {
    echo [][][][][][][][][][][][][][][][][][][][][][][][] ;
    echo ;
    echo $1 ;
    echo $2 ;
    echo ;
    echo [][][][][][][][][][][][][][][][][][][][][][][][] ;
}

Pretty_3statements() {
    echo [][][][][][][][][][][][][][][][][][][][][][][][] ;
    echo ;
    echo $1 ;
    echo $2 ;
    echo $3 ;
    echo ;
    echo [][][][][][][][][][][][][][][][][][][][][][][][] ;
}

Pretty_1result() {
    echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ;
    echo ;
    echo $1 ;
    echo ;
    echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ;
}

Pretty_2results() {
    echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ;
    echo ;
    echo $1 ;
    echo $2 ;
    echo ;
    echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ;
}

Pretty_3results() {
    echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ;
    echo ;
    echo $1 ;
    echo $2 ;
    echo $3 ;
    echo ;
    echo xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ;
}

Pretty_header() {
    echo ;
    echo =============== $1 =============== ;
}

Pretty_break() {
    echo +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ ;
}

PrettySuggestion="[Suggestion]"
PrettyAdvice="[Advice]"
PrettyError="[ERROR]"
PrettyWarning="[WARNING]"
PrettyInfo="[INFO]"