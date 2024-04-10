#!/bin/bash

# get a list of available network interfaces
get_network_interfaces() {
    interfaces=()
    while read -r line; do
        if [[ $line =~ ^[0-9]+:.* ]]; then
            interface=$(echo "$line" | awk -F ':' '{print $2}' | awk '{print $1}')
            interfaces+=("$interface")
        fi
    done < <(ip link show)
    echo "${interfaces[@]}"
}

select_interface() {
    clear
    echo "Available network interfaces:"
    interfaces=("$(get_network_interfaces)")
    if [ ${#interfaces[@]} -eq 0 ]; then
        echo "No network interfaces found."
        exit 1
    fi
    for i in "${!interfaces[@]}"; do
        printf "%3d. %s\n" $((i+1)) "${interfaces[$i]}"
    done
    echo ""
    read -p "Enter the number of the interface you want to monitor: " choice
    if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#interfaces[@]}" ]; then
        echo "Invalid choice. Please try again."
        select_interface
    else
        INTERFACE="${interfaces[$((choice-1))]}"
        echo "Selected interface: $INTERFACE"
    fi
}

display_animation() {
    clear
    echo "      .-') _   ('-.   .-') _               (\`-.                                          "
    echo "     ( OO ) )_(  OO) (  OO) )            _(OO  )_                                        "
    echo ",--../ ,--,'(,------./     '._       ,--(_/   ,. \\ ,-.-')   ,----.     ,-.-')  ,---.      "
    echo "|   \\ |  |\\ |  .---'|'--...__)      \\   \\   /(__/ |  |OO) '  .-./-')  |  |OO) |  |.-')  "
    echo "|    \\|  | )|  |    '--.  .--'       \\   \\ /   /  |  |  \\ |  |_( O- ) |  |  \\ |  | OO ) "
    echo "|  .     |/(|  '--.    |  |           \\   '   /,  |  |(_/ |  | .--, \\ |  |(_/ |  |\`-' | "
    echo "|  |\\    |  |  .--'    |  |            \\     /__),|  |_.'(|  | '. (_/,|  |_.'(|  '---.' "
    echo "|  | \\   |  |  \`---.   |  |             \\   /   (_|  |    |  '--'  |(_|  |    |      |  "
    echo "\`--'  \`--'  \`------'   \`--'              \`-'      \`--'     \`------'   \`--'    \`------'  "
    sleep 2
}

display_menu() {
    echo "1. Start monitoring traffic"
    echo "2. About"
    echo "3. How to use"
    echo "4. Open-source contribution"
    echo "5. Exit"
    echo -n "Enter your choice: "
}

display_about() {
    clear
    echo "About NetVigil - Network Traffic Monitor:"
    echo "NetVigil is a program that monitors network traffic in real-time and performs basic analysis."
    echo "It helps identify suspicious activities or anomalies in network communication."
    echo "This program is still under development."
    echo "Press [Enter] to continue..."
    read -s
}

display_usage() {
    clear
    echo "How to use NetVigil - Network Traffic Monitor:"
    echo "1. Select 'Start monitoring traffic' from the menu."
    echo "2. Once the monitoring starts, you'll see the captured network traffic details."
    echo "3. Press Ctrl+C to stop monitoring."
    echo "Press [Enter] to continue..."
    read -s
}

display_contribution() {
    clear
    echo "Open-source contribution to NetVigil:"
    echo "NetVigil is open-source and welcomes contributions from the community."
    echo "You can contribute by fixing bugs, adding new features, or improving documentation."
    echo "The source code is available on GitHub: https://github.com/jefftrojan/netvigil"
    echo "Press [Enter] to continue..."
    read -s
}

display_description() {
    clear
    echo "Activity Description:"
    case $1 in
        1)
            echo "Start monitoring network traffic in real-time."
            ;;
        2)
            display_about
            ;;
        3)
            display_usage
            ;;
        4)
            display_contribution
            ;;
        5)
            echo "Exiting NetVigil..."
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
    echo "Press [Enter] to continue..."
    read -s
}

monitor_traffic() {
    clear
    echo "Monitoring network traffic on interface $INTERFACE. Press Ctrl+C to stop."

    # start packet capture and analysis
    tcpdump -i "$INTERFACE" -l -n | while read line; do
        echo "$line"
    done
}

main() {
    select_interface

    while true; do
        display_animation
        display_menu

        read choice
        display_description "$choice"

        case $choice in
            1)
                monitor_traffic &
                read -p "Press [Enter] to stop monitoring..." key
                ;;
            2)
                ;;
            3)
                ;;
            4)
                ;;
            5)
                echo "Exiting NetVigil..."
                exit 0
                ;;
            *)
                echo "Invalid option. Please select again."
                ;;
        esac
    done
}

main