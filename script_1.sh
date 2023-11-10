#Vasile Ciprian Stefan
while true
do
    echo "Press any key to continue..."
    read dummy_text

    echo "Meniu:"
    echo "1. Ieșire"
    echo "2. Afișare informații despre sistem"
    echo "3. Afișare numărul săptămânii și ziua Crăciunului"
    echo "4. Afișare primele 2 shell-uri instalate"
    echo "5. Afișare informații despre utilizatori"
    echo "6. Afișare ultimele linii din /etc/protocols"
    echo "7. Afișare informații despre procesor"
    echo "8. Afișare nume directoare din /proc"
    echo "9. Căutare în fișiere de log"

    read opt

    case $opt in 
        1)
            echo "La revedere!"
            exit
        ;;

        2)
            echo "ID procesului scriptului: $$"
            echo "Tipul sistemului de operare: $(uname)"
            #$(date +%s) calculează numărul de secunde trecute de la 1 ianuarie 1970, cunoscut ca "Unix Epoch"
            #$SECONDS este o variabilă specială în shell care păstrează numărul de secunde trecute de când shell-ul a fost pornit
            echo "Numarul de secunde de la pornire: $(($(date +%s) - $SECONDS))"
            echo "Calea curenta: $PWD"
        ;;
        
        3)
            TODAY=$(date +%j)
            WEEK=$(date +%U)
            echo "Astazi este ziua cu numarul: $TODAY"
            echo "Aceasta este saptamana cu numarul: $WEEK"

            #Afisez data
            date -jf "%Y-%m-%d" "$(date +%Y)-12-25" "+Data Craciunului: %A, %d %B %Y"
            date -jf "%Y-%m-%d" "$(date +%Y)-12-25" "+Saptamana Craciunului: %U"

            #CHRISTMAS=$(date -d "12/25" +%j)
            #echo "Mai sunt $(($CHRISTMAS - $TODAY)) pana la Craciun."
        ;;

        4)
            echo "Primele doua shell-uri instalate:"
            tail -n +6 /etc/shells | tail -n 2 #Folosesc un pipe
        ;;

        5)
            #Afisam informatii despre utilizatori din /etc/passwd
            tail -n +11 /etc/passwd | awk -F: '{print "Nume login:", $1, "User ID:", $3, "Nume complet:", $5, "Director home:", $6}'
        ;;

        6)
            echo "Afisare linii din /etc/protocols incepand cu linia 9:"
            tail -n +9 /etc/protocols
        ;;

        7)
            echo "Informații despre procesor:"
            sysctl -a machdep.cpu.brand_string #MacBook M1
            cat /proc/cpuinfo | grep -E 'model name|cache size' #Linux
        ;;

        8)
            echo "Directoarele din /proc care nu reprezinta imagini ale proceselor pe disc:"
            ls -d /dev/*/
            ls /proc | grep -E '^[^0-9]'
        ;;

        9)
            read -p "Introduceți numele fișierului de log: " file_name
            read -p "Introduceți textul de căutat: " search_text
            if [ "$file_name" ]; then
                grep "$search_text" "$file_name"
            else
                echo "Fisierul nu exista."
            fi
        ;;

        *)
            echo "Optiune invalida. Apasa o tasta pentru a continua..."
        ;;
    esac
done