#!/usr/bin/env bash

# This script is used to convert the performances of some models
# to a LaTeX table to put in the report

# parse the output of the evaluation script
function parse() {
    cat - | sed -n 2p | sed 's/^.*precision: *\(.*\)%; recall: *\(.*\)%; FB1: *\(.*\)$/\1% \2% \3%/'
}

# format as LaTeX table
function format() {
    cat - | sed 's/ / \& /g' | sed 's/$/ \\\\/' | sed 's/_/\\_/g' | sed 's/%/\\%/g'
}

# extract the model name from the file path
function parse_model() {
    cat - | sed 's/^.*\/computations\/\(.*\)\/performances\/performances.txt$/\1/'
}

this=$(dirname $0)
computations="$this/../computations"
table="$this/../../report/table"

mkdir -p $table

# model v1, ngram comparison
echo -e "\n n-gram method comparison"
echo "---------------------------------"
for f in $computations/*/performances/performances.txt; do
    model=$(echo $f | parse_model)

    # extract the ngram order and smoothing
    ngram=$(echo $model | tr '-' '\t' | cut -f 3)
    smoothing=$(echo $model | tr '-' '\t' | cut -f 4)

    for m in $(echo $model | grep v1 | grep word | grep "unsmoothed\|witten_bell"); do
        echo -n $ngram
        echo -n ' '
        echo -n $smoothing
        echo -n ' '
        cat $f | parse
    done
done | cut -f 2,3,4,5 | tee >(format > $table/v1-ngrams.tex)

# model v1, smoothing method comparison
echo -e "\n smoothing method comparison"
echo "---------------------------------"
for f in $computations/*/performances/performances.txt; do
    model=$(echo $f | parse_model)

    # extract the ngram order and smoothing
    ngram=$(echo $model | tr '-' '\t' | cut -f 3)
    smoothing=$(echo $model | tr '-' '\t' | cut -f 4)

    for m in $(echo $model | grep v1 | grep word | grep "\-[25]\-"); do
        echo -n $ngram
        echo -n ' '
        echo -n $smoothing
        echo -n ' '
        cat $f | parse
    done
done | tee >(format > $table/v1-smoothing.tex)

# model v1, features comparison
echo -e "\n features comparison"
echo "---------------------------------"
for f in $computations/*/performances/performances.txt; do
    model=$(echo $f | parse_model)

    # extract the feature
    feature=$(echo $model | tr '-' '\t' | cut -f 2)
    ngram=$(echo $model | tr '-' '\t' | cut -f 3)

    for m in $(echo $model | grep v1 | grep "witten_bell" | grep "\-[25]\-"); do
        echo -n $feature
        echo -n ' '
        echo -n $ngram
        echo -n ' '
        cat $f | parse
    done
done | tee >(format > $table/v1-features.tex)

# model 1 all
echo -e "\n model 1"
echo "---------------------------------"
for f in $computations/*/performances/performances.txt; do
    model=$(echo $f | parse_model)

    # extract the ngram order and smoothing
    feature=$(echo $model | tr '-' '\t' | cut -f 2)
    ngram=$(echo $model | tr '-' '\t' | cut -f 3)
    smoothing=$(echo $model | tr '-' '\t' | cut -f 4)

    for m in $(echo $model | grep v1); do
        echo -n $feature
        echo -n ' '
        echo -n $ngram
        echo -n ' '
        echo -n $smoothing
        echo -n ' '
        cat $f | parse
    done
done

# model 2
echo -e "\n model 2 - report"
echo "---------------------------------"
for f in $computations/*/performances/performances.txt; do
    model=$(echo $f | parse_model)

    # extract the ngram order and smoothing
    feature=$(echo $model | tr '-' '\t' | cut -f 2)
    feature_o=$(echo $model | tr '-' '\t' | cut -f 3)
    ngram=$(echo $model | tr '-' '\t' | cut -f 4)
    smoothing=$(echo $model | tr '-' '\t' | cut -f 5)

    for m in $(echo $model | grep v2 | grep "word-word" | grep "kneser_ney\|witten_bell" | grep "\-[345]\-"); do
        echo -n $ngram
        echo -n ' '
        echo -n $smoothing
        echo -n ' '
        cat $f | parse
    done
done | tee >(format > $table/v2.tex)

# model 2 - all
echo -e "\n model 2 - all"
echo "---------------------------------"
for f in $computations/*/performances/performances.txt; do
    model=$(echo $f | parse_model)

    # extract the ngram order and smoothing
    feature=$(echo $model | tr '-' '\t' | cut -f 2)
    feature_o=$(echo $model | tr '-' '\t' | cut -f 3)
    ngram=$(echo $model | tr '-' '\t' | cut -f 4)
    smoothing=$(echo $model | tr '-' '\t' | cut -f 5)

    for m in $(echo $model | grep v2); do
        echo -n $feature
        echo -n ' '
        echo -n $feature_o
        echo -n ' '
        echo -n $ngram
        echo -n ' '
        echo -n $smoothing
        echo -n ' '
        cat $f | parse
    done
done
