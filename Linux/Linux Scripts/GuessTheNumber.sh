#!/bin/bash
shopt -s extglob

# Guess the Number - Bash
# Author: Michael Miller Jr. | October 2026
# A terminal-based guessing game demonstrating Bash fundamentals, input validation, loops, functions, and error handling.
# Developed as a hands-on learning project with AI-assisted tutoring.

# A classic Guess The Number Game
# It will tell the player if the entered number is too high or too low...
# ...or correct!

# A handy sleep function. ...I should probably get some sleep now. It's 2:30am!
sleeeep() {
        sleep "$1"
        clear
}

# Restore the cursor visibility when the script exits, regardless of how it exits.
trap 'printf "\033[?25h"' EXIT

# Hide the cursor for a cleaner display.
printf '\033[?25l'

clear

for intro in {1..20}
    do
        ShowNum=$((RANDOM % 10 + 1))
        for ((frontSpaces=1; frontSpaces<ShowNum; frontSpaces++))
            do
                echo -n " "
            done

        echo -n "$ShowNum"

        for ((backSpaces=ShowNum; backSpaces<10; backSpaces++))
            do
                echo -n " "
            done
        sleeeep 0.05
    done

echo "Let's play..."
sleeeep 1.5

for animation in {1..5}
    do
        echo "Let's play..."
        echo "( ( ( GUESS THE NUMBER ) ) )"
        sleeeep 0.05
        echo "Let's play..."
        echo " ( (  GUESS THE NUMBER  ) ) "
        sleeeep 0.05
        echo "Let's play..."
        echo "  ( ( GUESS THE NUMBER ) )  "
        sleeeep 0.05
        echo "Let's play..."
        echo "   (  GUESS THE NUMBER  )   "
        sleeeep 0.05
        echo "Let's play..."
        echo "(   ( GUESS THE NUMBER )   )"
        sleeeep 0.05
        echo "Let's play..."
        echo " (    GUESS THE NUMBER    ) "
        sleeeep 0.05
        echo "Let's play..."
        echo "( (   GUESS THE NUMBER   ) )"
        sleeeep 0.05
        echo "Let's play..."
        echo " ( (  GUESS THE NUMBER  ) ) "
        sleeeep 0.05
    done

# Show the cursor again after the animation.
printf '\033[?25h'

PlayAgain="Y"

while [[ $PlayAgain == [Yy] ]]
    do
        # Generate a new secret number for each game.
        RandNumber=$((RANDOM % 10 + 1))

        # Track valid guesses; invalid inputs do not affect the count.
        Score=1

        while true
            do
                # Show the player the current guess number. Invalid inputs will not count as a guess.
                echo "Guess # $Score"

                # Read the guess, preserving whitespace. Exit gracefully if input fails (e.g., EOF).
                if ! IFS= read -r -p "Guess the number from 1-10: " NumGuess
                    then
                        printf '\n'
                        printf '\n'
                        echo "Sorry, there are no door prizes for an early exit."
                        sleeeep 3
                        exit 0
                fi

                # VOID-INPUT CHECK
                # Distinguish completely empty input from whitespace-only input.
                if [[ -z $NumGuess ]]
                    then
                        echo "Hello? Contestant? Are you there?"
                        sleeeep 3
                        continue

                elif [[ -z ${NumGuess//[[:space:]]/} ]]
                    then
                        echo "Hello? Contestant? You need to enter a number!"
                        sleeeep 3
                        continue
                fi

                # DECIMAL NORMALIZATION CHECK
                # Convert integer-equivalent decimals (e.g., 5.000) to whole numbers.
                if [[ $NumGuess =~ ^-?[0-9]+\.0*$ ]]
                    then
                        NumGuess="${NumGuess%%.*}"
                fi

                # LEADING-ZERO CHECK
                # Strip leading zeroes; interpret an all-zero input as 0.
                NumGuess=${NumGuess##+(0)}
                if [[ -z $NumGuess ]]
                    then
                        NumGuess=0
                fi

                # WHOLE-NUMBER CHECK
                # Reject decimal values with a nonzero fractional portion.
                if [[ $NumGuess =~ ^-?[0-9]*\.[0-9]*[1-9][0-9]*$ ]]
                    then
                        echo "Ooooo, sorry! Your answer must be in the form of a whole number."
                        sleeeep 3
                        continue
                fi

                # NON-NUMERIC CHECK
                # Reject input that doesn't match the integer format.
                if [[ ! $NumGuess =~ ^-?[0-9]+$ ]]
                    then
                        echo "Either I'm confused or you're confused...but I'm pretty sure that's not a number."
                        sleeeep 4
                        continue
                fi

                # NEGATIVE CHECK
                # Reject negative values. Even numbers deserve encouragement!
                if [[ $NumGuess == -* ]]
                    then
                        echo "Why so negative...? This is a family-friendly game, you know. Please enter a positive number."
                        sleeeep 4
                        continue
                fi

                # CHARACTER-LIMIT CHECK
                # Reject oversized integers before numerical comparison.
                if [[ ${#NumGuess} -gt 2 ]]
                    then
                        echo "That number is a violation of game show rules. Are you trying to crash our system?"
                        sleeeep 3
                        continue
                fi

                # RANGE CHECK
                # Accept only numbers between 1 and 10.
                if [[ $NumGuess -lt 1 || $NumGuess -gt 10 ]]
                    then
                        echo "I am sorry, but your guess must be a number between 1 and 10."
                        sleeeep 3
                        continue
                fi

                # Now for the actual evaluation of the player's guess.
                if [[ $NumGuess -lt $RandNumber ]]
                    then
                        Score=$((Score + 1))
                        echo "Too low..."
                        sleeeep 1

                elif [[ $NumGuess -gt $RandNumber ]]
                    then
                        Score=$((Score + 1))
                        echo "Too high..."
                        sleeeep 1
                # The player guessed correctly, so break from the loop!
                else
                        clear
                        echo "You got the right number - $RandNumber - in $Score guesses!"
                        break
                fi

    done

# Set PlayAgain to an empty string to prepare it for the subsequent while loop...
PlayAgain=""

# Check to see if the player wants to play again. If they do, the game will restart. If not, the game will exit.
while [[ $PlayAgain == "" ]]
    do

        # Look for a single character input of either Y or N. If the player enters anything else, prompt them to enter a valid response.
        if ! read -r -n 1 -p "Play again...? [Y]es or [N]o? " PlayAgain
            then
                printf "\n"
                printf "\n"
                echo "...okay, I'll take that as a no. Thanks for playing!"
                sleeeep 3
                exit 0
        fi

        printf "\n"

        if [[ $PlayAgain == [Yy] ]]
            then
                clear
                break
            elif [[ $PlayAgain == [Nn] || $PlayAgain == $'\004' ]]
                then
                    clear
                    echo "That's a no. Thanks for playing!"
                    sleeeep 3
                    exit 0
            else
                clear
                echo "Invalid input. Please enter [Y]es or [N]o."
                sleeeep 3
                PlayAgain=""
            fi
    done

done