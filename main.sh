#!/bin/bash

# create a users.json file if it does not exist
if [ ! -f users.json ]; then
    echo "[]" > users.json
fi

# create a notes directory if it does not exist
if [ ! -d notes ]; then
    mkdir notes
fi

# function to show the main menu
main_menu() {
    echo -e "\n📝 Welcome to the Note Taking App 📝"
    echo -e "1. 📝 Create a Note"
    echo -e "2. 📖 View Notes"
    echo -e "3. 📝 Update a Note"
    echo -e "4. 🗑️ Delete a Note"
    echo -e "5. ❌ Exit"
    read -p "Choose an option: " option
    case $option in
        1)
            create_note
            ;;
        2)
            view_notes
            ;;
        3)
            update_note
            ;;
        4)
            delete_note
            ;;
        5)
            exit 0
            ;;
        *)
            echo -e "\e[31m❌ Invalid option\e[0m"
            main_menu
            ;;
    esac
}

# function to create a note
create_note() {
    read -p "Enter the title of the note: " title
    read -p "Enter the body of the note: " body
    echo "{\"title\": \"$title\", \"body\": \"$body\"}" > notes/$title.json
    echo -e "\e[32m📝 Note created successfully\e[0m"
    main_menu
}

# function to view notes
view_notes() {
    echo -e "1. 📖 View all notes"
    echo -e "2. 📖 View a specific note"
    read -p "Choose an option: " option
    case $option in
        1)
            for note in notes/*.json; do
                title=$(jq -r '.title' $note)
                body=$(jq -r '.body' $note)
                echo -e "\n\e[34mTitle: $title\e[0m"
                echo -e "\e[34mBody: $body\e[0m"
            done
            ;;
        2)
            read -p "Enter the title of the note: " title
            if [ -f notes/$title.json ]; then
                body=$(jq -r '.body' notes/$title.json)
                echo -e "\n\e[34mTitle: $title\e[0m"
                echo -e "\e[34mBody: $body\e[0m"
            else
                echo -e "\e[31m❌ Note does not exist\e[0m"
            fi
            ;;
        *)
            echo -e "\e[31m❌ Invalid option\e[0m"
            view_notes
            ;;
    esac
    main_menu
}

# function to update a note
update_note() {
    read -p "Enter the title of the note: " title
    if [ -f notes/$title.json ]; then
        read -p "Enter the new body of the note: " body
        echo "{\"title\": \"$title\", \"body\": \"$body\"}" > notes/$title.json
        echo -e "\e[32m📝 Note updated successfully\e[0m"
    else
        echo -e "\e[31m❌ Note does not exist\e[0m"
    fi
    main_menu
}

# function to delete a note
delete_note() {
    read -p "Enter the title of the note: " title
    if [ -f notes/$title.json ]; then
        rm notes/$title.json
        echo -e "\e[32m📝 Note deleted successfully\e[0m"
    else
        echo -e "\e[31m❌ Note does not exist\e[0m"
    fi
    main_menu
}

# function to register a user
register() {
    read -p "Enter your username: " username
    read -s -p "Enter your password: " password
    echo
    hash=$(echo -n $password | sha256sum | awk '{print $1}')
    # echo "Registering user: $username with hash: $hash"  # Debug statement
    if ! grep -q "\"username\": \"$username\"" users.json; then
        jq ". += [{\"username\": \"$username\", \"password\": \"$hash\"}]" users.json > temp.json
        mv temp.json users.json
        echo -e "\n\e[32m🎉 User registered successfully\e[0m"
        main_menu
    else
        echo -e "\n\e[31m❌ Username already exists\e[0m"
        register
    fi
}

# function to login a user
login() {
    read -p "Enter your username: " username
    read -s -p "Enter your password: " password
    echo
    hash=$(echo -n $password | sha256sum | awk '{print $1}')
    # echo "Logging in user: $username with hash: $hash"  # Debug statement
    stored_hash=$(jq -r --arg username "$username" '.[] | select(.username == $username) | .password' users.json)
    if [ "$hash" == "$stored_hash" ]; then
        echo -e "\n\e[32m✅ Login successful\e[0m"
        main_menu
    else
        echo -e "\n\e[31m❌ Invalid username or password\e[0m"
        login
    fi
}

# check if the user is registered or not
if [ $(jq '. | length' users.json) -eq 0 ]; then
    echo -e "📝 Welcome to the Note Taking App 📝"
    register
else
    echo -e "📝 Welcome to the Note Taking App 📝"
    echo -e "1. 📝 Login"
    echo -e "2. 📝 Register"
    read -p "Choose an option: " option
    case $option in
        1)
            login
            ;;
        2)
            register
            ;;
        *)
            echo -e "\e[31m❌ Invalid option\e[0m"
            ;;
    esac
fi

main_menu


# Tools and libraries used in the project
# jq: https://stedolan.github.io/jq/

# Alogrithm in .tex format

# multiple line comment
: '
\documentclass{article}
\usepackage{amsmath}
\begin{document}
\section{Algorithm}
\begin{verbatim}
1. Start
2. Create a users.json file if it does not exist
3. Create a notes directory if it does not exist
4. Show the main menu
5. Read the option from the user
6. Perform the action based on the option
7. If the option is 1, call create_note function
8. If the option is 2, call view_notes function
9. If the option is 3, call update_note function
10. If the option is 4, call delete_note function
11. If the option is 5, exit the program
12. End
\end{verbatim}
\end{document}
'