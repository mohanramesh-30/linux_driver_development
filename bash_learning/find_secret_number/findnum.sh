#!/bin/bash

MAX_ATTEMPTS=3
secret_number=0
attempts=0
MIN_RANGE=0
MAX_RANGE=10

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
    echo $((RANDOM % $MAX_RANGE + $MIN_RANGE))
}

range_of_secret_number() {
    echo "<< Range of secret number ($MIN_RANGE - $MAX_RANGE)>>"
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

clue() {

    local clu clu1 clu2
    echo "++++++++++++++++++++++++++++++++++++"
    read -p "Clue ?? (y/n)" clu

    if is_yes_no "$clu"; then
       
       while true; do

            clu1=$(create_secret_number)

            if [[ $clu1 -ne $secret_number ]]; then
                break
            fi
       done

        while true; do

            clu2=$(create_secret_number)

            if [[ $clu2 -ne $secret_number && $clu2 -ne $clu1 ]]; then
                break
            fi
       done

       arry_num=($secret_number $clu1 $clu2)

        arry_num=($(shuf -e ${arry_num[@]})) 
        echo "Find a Number: << ${arry_num[@]} >>"
    fi

}

# function is asking start a game or not?
start_game() {

    local st_flg=""
    # read from user
    echo "++++++++++++++++++++++++++++++++++++"
    read -p "Shall We Play? (y/n) " st_flg
    # conditions checking
    if is_yes_no "$st_flg"; then
        
        echo "<< Game start !!! >>"
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
    echo "Secrert Number is ($secret_number)"
    while true;
    do
        read -p "Enter a secret number attempts: ($attempts) :" user_input

        if [[ $1 -eq $user_input ]]; then
            echo "####################################"
            echo "Super U Got It !!! Secret Number($1)"
            echo "####################################"
            break
        else
            ((attempts++))
        fi

        if [[ $attempts == 2 ]]; then
            clue
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
    range_of_secret_number
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