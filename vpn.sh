#!/bin/bash

##########_header_#######################
#Nom: vpn.sh
#Utilité: se connecter à l'aide de openconnect
#Usage: sudo ./vpn.sh [start/stop]
#Auteur: k-chien
#Mise-à-jour: 20192106
#########################################

##############_VARIABLES_################
user=""
psswd=""
server=""
#########################################

# L'uid d'un process c'est l'id de l'user qui exec ledit process.
# L'euid c'est l'uid effective (utilisé pour les tests d'accès)
if [[ $EUID -ne 0 ]]; then
   echo "Le script doit être executé en root." 
   exit 1
fi

if [[ $# -ne 1 ]] ; then 
	echo "---Un argument est nécessaire."
	echo "---L'utilisation correcte est: ./vpn.sh [start/stop] "
    exit 1
else
    # N.B: &> /dev/null redirige la sortie standard et d'erreur dans le périphérique nul (ça n'affiche rien comme ça)
    # (Le périphérique nul supprime tout ce qui s'y trouve dedans)
    if [[ "$1" == "start" ]] ; then
		# -b c'est pour background ( tâche de fond)
		echo "$psswd" | openconnect -b -u $user -p $psswd $server --authgroup="Personnels de l' UGA" &> /dev/null
		echo "Connexion à votre vpn effectuée."
	elif [[ "$1" == "stop" ]] ; then
		echo "Déconnexion en cours..."
        #Interruption -> -2 ou -SIGINT (c'est ce que le vpn a l'air d'attendre pour quitter)
        sudo pkill -2 openconnect &> /dev/null
        #pkill c'est le kill mais basé sur le nom du process et pas le PID
        sleep 1 ; echo "Déconnexion effectuée."
	else
		echo "Seul les commandes start et stop sont disponibles !"
	fi
fi

sudo rm -f ~/.bash-history
exit 0

