#! /bin/bash
# PENDU BY P BORIS / NOTFOUND
# LICENCE GPLv2
#########################################################
######################  FONCTIONS #######################
_iLOLDSOHARD(){
	T=('/ \' '| |' '_o_' '<o>' '\o/')
        ( sleep 1 ; for (( j=2 ; j<40 ; j++)); do
                tput cup 11 "$j" ; echo "   YOUPI GOOD JOB MISTER XXXXX  " ; sleep 0.5
        done ) &
	for (( i=0 ; i<10 ; i++ )); do
		tput cup 14 30; echo "${T[2]}"
		tput cup 15 30; echo " |"
		tput cup 16 30; echo "${T[0]}"
		sleep 0.8
		tput cup 14 30; echo "${T[3]}"
		tput cup 15 30; echo " |"
		tput cup 16 30; echo "${T[1]}"
		sleep 0.8
                tput cup 14 30; echo "${T[4]}"
                tput cup 15 30; echo " |"
                tput cup 16 30; echo "${T[0]}"
                sleep 0.8
	done
}


_leaveClean(){
        clear
        PROG=$(echo "$0" |awk -F"/" '{print $2}')
        pgrep "$PROG" |xargs kill -9
}

_test(){
        grep -o "$PUSHED" <<< $WORD >/dev/null
}

_retireLetter(){
        tput cup 7 5 ; echo -e "                    " 
        THE_WORD="${THE_WORD}${PUSHED}"
        tput cup 2 5 ; echo "Mot (${NB_LETTER} lettres) : ${WORD//[^$THE_WORD]/_}"
        tput cup 4 5 ; echo -e "Lettres utilisees : ${KEY_PRESS}"
        : $((CPT++))
        tput cup 5 25 ; echo -e " "
}

_randomizeWord(){
        NB_INDICE="${#ALL_WORD[*]}"
        WORD=${ALL_WORD[$((RANDOM%NB_INDICE))]}
}
#########################################################
##################     MAIN     #########################
#########################################################

trap _leaveClean SIGINT

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage: $0 <nb_letter> <nb_VIE>" ; exit 2
fi

#### SOME VARIABLES
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
ROUGE="\\033[1;31m"
NB_LETTER="$1"
VIE="$2"
ALL_WORD=($(cat /usr/share/dict/french | grep -Pe "^\w{$NB_LETTER}$"))
_randomizeWord
NB_LETTER="${#WORD}"
CPT=0

clear
### A COMMENTER, affiche le mot en bas a droite
tput cup $(($(tput lines)-1)) $(($(tput cols)-NB_LETTER)) ; echo $WORD

tput cup 0 30 ; echo "Pendu par les ...."
tput cup 2 5 ; echo -e "Mot (${NB_LETTER} lettres) : ${WORD//[a-z-A-Z-0-9]/-}"

tput cup 3 5 ; echo "Nombre de VIE : $VIE"
tput cup 4 5 ; echo "Lettres utilisees : ${KEY_PRESS}"


while [ "$CPT" -lt "$NB_LETTER" ]; do
        tput cup 5 5 ; read -p "Lettre: " PUSHED
        KEY_PRESS="${KEY_PRESS}${PUSHED}"
        _test ; CODERET="$?"
        case "$CODERET" in
                0)      _retireLetter
                        if [ "${WORD//[^$THE_WORD]/_}" == "${WORD}" ]; then
                                tput cup 8 30 ; echo -e "${VERT}YOU WIN${NORMAL}"
                                _iLOLDSOHARD ## MAGIK FEATURE
                                break
                        else continue
                        fi ;;
                1)      tput cup 7 5 ; echo "FAIL"
                        : $((VIE--))
                        tput cup 3 5 ; echo -e "Nombre de VIE : $VIE  "
                        
                        tput cup 4 5 ; echo -e "Lettres utilisees : $KEY_PRESS"
                        
                        
                        if [ "$VIE" = 0 ]; then
                		tput cup 12 30 ; echo -e "${ROUGE}YOU FAIL${NORMAL}"
                		tput cup 13 25 ; echo "Le mot etait : ${WORD}"
                		break
                	else continue
                        fi ;;
                esac
done

###### END
##########################
