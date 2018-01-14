#!/bin/bash
# Read a random page from Wikiquote and parse output to extract quotes.
# Output a randomly selected quote.
LINK="http://en.wikiquote.org/wiki/Special:Random"

# Sed clean html 
COMM='s#\<\([^\<,^\>]*\)\>##g'

# Search tokens
TITLE_TOKEN="<title>"
QUOTE_START_TOKEN='class="mw-headline"'
QUOTE_END_TOKEN='id="Quotes_about_\|id="Cast"\|id="External_links"'
LI_START_TOKEN='<li>'
LI_END_TOKEN='</li>'

# State variables
QUOTE_START=0
QUOTE_COUNT=0
QUOTE_ARRAY=()
QUOTE=""
LI_COUNT=0
PERSON=""

# Redirect wget output to while loop
wget -q -O - $LINK | {
    while IFS= read -r line
    do

        # Extract title
        T=`echo $line | grep -c $TITLE_TOKEN`
        if [ $T -gt 0 ] ; then
            PERSON=`echo $line | sed "$COMM" | sed 's/ - Wikiquote//g'` 
        fi

        # Check if quote list start
        T=`echo $line | grep -c "$QUOTE_START_TOKEN"`
        if [ $T -gt 0 ] ; then 
            QUOTE_START=1 
        fi

        # Skip if not in quote mode
        if [ $QUOTE_START -eq 0 ] ; then 
            continue
        fi

        # Increment LI
        T=`echo $line | grep -c $LI_START_TOKEN`
        LI_COUNT=$(($LI_COUNT+$T))

        # If LI is non-zero add contents to current quote
        # Enter only the first part of quote.
        if [ $LI_COUNT -eq 1 ] ; then
            CLEAN=`echo $line | sed "$COMM" | awk '{$1=$1;print}'` 

            if [[ "$CLEAN" != "" ]] ; then
                QUOTE="$QUOTE \n $CLEAN"
            fi
        fi    

        # Close LI
        T=`echo $line | grep -c $LI_END_TOKEN`
        LI_COUNT=$(($LI_COUNT-$T))

        # Check if LI is zero and QUOTE is non-empty
        # Add to quotes list
        if [[ $LI_COUNT -eq 0 && "$QUOTE" != "" ]] ; then
            QUOTE_ARRAY[$QUOTE_COUNT]=$QUOTE
            QUOTE_COUNT=$(($QUOTE_COUNT+1))        
            QUOTE=""
        fi

        # Break when direct quotes end
        T=`echo $line | grep -c $QUOTE_END_TOKEN`
        if [ $T -gt 0 ] ; then
            break
        fi   
    done 

    # Check quotes
    N=${#QUOTE_ARRAY[@]}
    if [ $N -eq 0 ] ; then 
        echo "No quotes found. Your shell may not have access to the internet."
        exit
    fi

    # Select a quote randonmly
    COMM="BEGIN{srand();print int(rand()*($N))}"
    i=`awk "$COMM"`
    Q="${QUOTE_ARRAY[$i]}" 
    echo -e "$Q"
    echo -e "\t - $PERSON"
    echo
}
