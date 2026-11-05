#!/bin/bash

MAX_ATTEMPTS=3
secret_number=0
attempts=0

# in bash script when it receive '0' that only true state other values consider as a some error or something false

# general function
# recevice parameter with calling place
is_yes_no () {

    if [[ $1 == "y" || $1 == "Y" ]];then
        return 0;
    else
        return 1;
    fi
}

create_secret_number() {
    echo $((RANDOM % 100 + 1))
}

is_secret_number_created() {

    secret_number=$(create_secret_number)
    
    while true; do

        if [[ $secret_number -ne 0 ]]; then
            return 0;
        else
            secret_number=$(create_secret_number)
        fi            
    done
}

# function is asking start a game or not?
start_game() {

    local st_flg=""
    # read from user
    read -p "Shall We Play? (y/n) " st_flg
    
    # conditions checking
    if is_yes_no "$st_flg"; then
        
        echo "Game start !!!!"
    else
        echo "See you later, Bye"
        exit 0
    fi
}


next_game() {

    local newgame=""
    read -p "New game?? (y/n) " newgame

    if is_yes_no "$newgame"; then
        return 0
    else
        return 1
    fi
}


check_secret_number() {

    local user_input=0
    # echo "Secrert Number is ($secret_number)"
    while true;
    do
        read -p "Enter a secret number attempts: ($attempts) :" user_input

        if [[ $1 -eq $user_input ]]; then
            echo "Super U Got It !!! Secret Number($1)"
            break
        else
            ((attempts++))
        fi

        if [[ $attempts == $MAX_ATTEMPTS ]]; then
            echo "==================================="
            echo "Secrert Number is ($secret_number)"
            echo "[ GAME OVER ]"
            echo "==================================="
            break
        fi
        
    done
}

main() {

    echo "=========== FIND A SECRET NUMBER ==========="
    
    # Game starting
    start_game
    while true; do
        # just verification
        is_secret_number_created
        # find secret number
        check_secret_number "$secret_number"
        # New game
        if next_game; then
            attempts=0
            continue
        else
            echo "[ Exit GAME ]"
            exit 0
        fi
    done
}

main "$@"