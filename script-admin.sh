#!/bin/bash

#Un script shell piloté par un menu simple pour obtenir des informations sur le serveur / bureau Linux et effectuer rapidement des opérations sur les utilisateurs et les fichiers.

#Définir une variable
LSB=/usr/bin/lsb_release

#Afficher l'invite de pause
# $1-> Message (optionnel)
function pause(){
local message="$@"
[ -z $message ] && message="Appuyez sur la touche [Entrée] pour continuer ..."
read -p "$message" readEnterKey
}
# Afficher le message d'entête
# $1 - message
function write_header(){
center() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}
local h="$@"
echo "---------------------------------------------------------------"| center
echo "                    ${h}" | center
echo "---------------------------------------------------------------"| center
}

# Objectif - Afficher le menu à l'écran
function show_menu(){
center() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}
echo "*************************Plateforme d'administration*************************"
echo "*****************************************************************************"
echo "Notes :"
echo ${txtred}"-Il faut excecuter les commandes en tant que root"${txtrst} | center
echo ${txtred}"-Pour le choix 6 il faut avoir 'netstat' deja installer"${txtrst} | center
echo ${txtred}"-Pour le choix 10 il faut avoir 'curl' deja installer"${txtrst} | center
echo ""
echo "Choisissez le type de l'intervention à faire :"
echo ""
echo "	1.  Gestion des utilisateurs"
echo "	2.  Gestion des fichiers"
echo "	3.  Gestion de  processus"
echo "	4.  Informations sur le système d'exploitation"
echo "	5.  Nom d'hôte et informations DNS"
echo "	6.  Informations sur le réseau"
echo "	7.  Qui est en ligne"
echo "	8.  Derniers utilisateurs connectés" 
echo "	9. Informations sur la mémoire libre et utilisée"
echo "	10. Obtenir mon adresse IP"
echo "	11. Utilisation de mon disque"
echo "	0.  ${txtred}Quitter${txtrst}"
echo ""
}

#--------------------------------------------------------------------------------------------------
#Traitement des choix principales
#--------------------------------------------------------------------------------------------------

#Traitement de la partie gestion des utilisateurs
function Gestion_utilisateurs() {
clear
write_header "Gestion des utilisateurs"

txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)
COLUMNS=$(tput cols)

center() {
	w=$(( $COLUMNS / 2 - 20 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

centerwide() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

while :
do

clear

echo ""
echo ""
echo "${txtcyn}(veuillez entrer le numéro de votre sélection ci-dessous : )${txtrst}" | centerwide
echo ""
echo "1.  Creer un utilisateur" | center
echo "2.  Changer le groupe d'un utilisateur" | center
echo "3.  Creer un groupe" | center
echo "4.  Supprimer un utilisateur" | center
echo "5.  Changer mot de passe" | center
echo "6.  Liste des utilisateurs" | center
echo "7.  Liste des groupes" | center
echo "8.  Supprimer un groupe" | center
echo "9.  ${txtred}Fermer${txtrst}" | center
echo "10.  ${txtpur}Returner au Menu principal${txtrst}" | center
echo ""

read usermenuchoice
case $usermenuchoice in

1 )
	clear && echo "" && echo "Veuillez saisir le nouveau nom d'utilisateur ci-dessous:  ${txtcyn}(PAS D'ESPACES OU DE CARACTÈRE SPÉCIAL!)${txtrst}" | centerwide && echo ""
	read newusername
	echo "" && echo "Please enter a group for the new user:  ${txtcyn}(PAS D'ESPACES OU DE CARACTÈRE SPÉCIAL!)${txtrst}" | centerwide && echo ""
	read newusergroup
	echo "" && echo "Quel est le nom complet du nouveau utilisateur?  ${txtcyn}(VOUS POUVEZ UTILISER LES ESPACES ICI!)${txtrst}" | centerwide && echo ""
	read newuserfullname
	echo "" && echo ""
	groupadd $newusergroup
	useradd -g $newusergroup -c "$newuserfullname" $newusername && echo "${txtgrn}Nouveau utilisateur $newusername créer avec succée.${txtrst}" | center || echo "${txtred}Impossible de créer un nouveau utilisateur.${txtrst}" | center
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center
	read
;;

2 )
	clear && echo "" && echo "Quel utilisateur doit appartenir à un groupe différent? ${txtcyn}(L'UTILISATEUR DOIT EXISTER!)${txtrst}" | centerwide && echo ""
	read usermoduser
	echo "" && echo "Quel devrait être le nouveau groupe pour cet utilisateur ?  ${txtcyn}(PAS D'ESPACES OU DE CARACTÈRE SPÉCIAL!)${txtrst}" | centerwide && echo ""
	read usermodgroup
	echo "" && echo ""
	groupadd $usermodgroup
	usermod -g $usermodgroup $usermoduser && echo "${txtgrn}Utilisateur $usermoduser ajouter au groupe $usermodgroup avec succée.${txtrst}" | center || echo "${txtred}Impossible d'ajouter l'utilisateur au groupe.Veuillez vérifier si l'utilisateur existe.${txtrst}" | centerwide
	echo "" && echo "${txtcyn}(Cliquer sur ENTREE pour continuer)${txtrst}" | center
	read
;;

3 )
	clear && echo "" && echo "Veuillez saisir le nom du nouveau groupe ci-dessous :  ${txtcyn}(PAS D'ESPACES OU DE CARACTÈRE SPÉCIAL!)${txtrst}" | centerwide && echo ""
	read newgroup
	echo "" && echo ""
	groupadd $newgroup && echo "${txtgrn}Groupe $newgroup creer avec succés.${txtrst}" | center || echo "${txtred}Échec de la création du groupe. Veuillez vérifier si le groupe existe déjà.${txtrst}" | centerwide
	echo "" && echo "${txtcyn}(Cliquer sur ENTREE pour continuer)${txtrst}" | center
	read
;;

4 )
	clear && echo "" && echo "Veuillez saisir ci-dessous le nom d'utilisateur à supprimer:  ${txtcyn}(ÇA NE PEUT PAS ÊTRE ANNULÉ!)${txtrst}" | centerwide && echo ""
	read deletethisuser
	echo "" && echo "${txtred}Êtes-vous absolument sûr de vouloir supprimer cet utilisateur? AU SÉRIEUX, CELA NE PEUT PAS ÊTRE ANNULÉ! ${txtcyn}y/n${txtrst}" | centerwide
	read deleteuserays
	echo "" && echo ""
	case $deleteuserays in
		y | Y )
			userdel $deletethisuser && echo "${txtgrn}Utilisateur $deletethisuser supprimer avec succés." | center || echo "${txtred}Échec de la suppression de l'utilisateur. Veuillez vérifier le nom d'utilisateur et réessayer.${txtrst}" | centerwide
		;;
		n | N )
			echo "D'accord. Pas de soucis alors." | center
		;;
		* )
			echo "${txtred}S'il vous plaît, faîtes une sélection valide.${txtrst}" | center
		;;
	esac
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center
	read
;;

5 )
	clear && echo "" && echo "Quel mot de passe d'utilisateur doit être changé?" | centerwide
	read passuser
	echo ""
	passwd $passuser && echo "${txtgrn}Mot de passe de $passuser changé avec succés.${txtrst}" | center || echo "${txtred}Échec du changement du mot de passe.${txtrst}" | center
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center
	read
;;
6 ) 
	cat /etc/passwd | cut -d':' -f1 | while read utilisateur
	do
		groupes=$(groups $utilisateur);
		echo "$utilisateur appartient au groupe : $groupes"
	done
echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
;;
7 ) 
	cat /etc/group | awk -F: '{print $ 1}'
echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
;;
8 )
	clear && echo "" && echo "Veuillez saisir ci-dessous le nom du groupe à supprimer:  ${txtcyn}(ÇA NE PEUT PAS ÊTRE ANNULÉ!)${txtrst}" | centerwide && echo ""
	read deletethisgroup
	echo "" && echo "${txtred}Êtes-vous absolument sûr de vouloir supprimer ce groupe? AU SÉRIEUX, CELA NE PEUT PAS ÊTRE ANNULÉ! ${txtcyn}y/n${txtrst}" | centerwide
	read deletegroupays
	echo "" && echo ""
	case $deletegroupays in
		y | Y )
			delgroup $deletethisgroup && echo "${txtgrn}Groupe $deletethisgroup supprimer avec succés." | center || echo "${txtred}Échec de la suppression du groupe. Veuillez vérifier le nom du groupe et réessayer.${txtrst}" | centerwide
		;;
		n | N )
			echo "D'accord. Pas de soucis alors." | center
		;;
		* )
			echo "${txtred}S'il vous plaît, faîtes une sélection valide.${txtrst}" | center
		;;
	esac
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center
	read
;;

9 )
	clear && echo "" && echo "Etes-vous sûr de vouloir arrêter? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
	read shutdownays
	case $shutdownays in
		y | Y )
			clear && exit #shutdown -h now
		;;
		n | N )
			clear && echo "" && echo "D'accord. Pas de soucis." | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
		;;
		* )
			clear && echo "" && echo "${txtred}S'il vous plaît, faîtes une sélection valide.${txtrst}" | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
		;;
	esac
;;
10 )
	clear && echo "" && echo "Êtes-vous sûr de vouloir revenir au menu principal? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
	read exitays
	case $exitays in
		y | Y )
			clear && show_menu
		;;
		n | N )
			clear && echo "" && echo "D'accord. Pas de soucis." | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
		;;
		* )
			clear && echo "" && echo "${txtred}S'il vous plaît, faîtes une sélection valide.${txtrst}" | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
		;;
	esac
;;
* )
	clear && echo "" && echo "${txtred}S'il vous plaît, faîtes une sélection valide.${txtrst}" | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
;;

esac

done
pause
}

#Traitement de la partie gestion des fichiers
function Gestion_fichiers() {
clear
write_header "Gestion des fichiers"
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)
COLUMNS=$(tput cols)

center() {
	w=$(( $COLUMNS / 2 - 20 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

centerwide() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

while :
do
clear

echo ""
echo ""
echo "${txtcyn}(Veuillez entrer le numéro de votre choix ci-dessous :)${txtrst}" | centerwide
echo ""
echo "1.  Creer un fichier" | center
echo "2.  Supprimer un fichier" | center
echo "3.  Créer un répertoire" | center
echo "4.  Supprimer un répertoire" | center
echo "5.  Créer un lien symbolique" | center
echo "6.  changer la propriété d'un fichier" | center
echo "7.  Modifier les autorisations sur un fichier" | center
echo "8.  Modifier le texte dans un fichier" | center
echo "9.  Compresser un fichier" | center
echo "10. Decompresser un fichier" | center
echo "11. ${txtpur}Revenir au menu principal${txtrst}" | center
echo "12. ${txtred}Fermer${txtrst}" | center
echo ""

read mainmenuchoice
case $mainmenuchoice in

1 )
	clear && echo "" && echo "Répertoire de travail actuel:" | center && pwd | center
	echo "" && echo "Veuillez entrer ${txtcyn}le chemin complet${txtrst} et le nom du nouveau fichier:" | centerwide && echo ""
	echo "${txtcyn}(si le fichier existe, il sera touché)${txtrst}" | center && echo ""
	read touchfile
	echo "" && echo ""
	touch $touchfile && echo "${txtgrn}Fichier $touchfile toucher avec succés.${txtrst}" | centerwide || echo "${txtred}le toucher a échoué. Comment as-tu fait ça?${txtrst}" | center
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

2 )
	clear && echo "" && echo "Répertoire de travail actuel:" | center && pwd | center && echo "" && ls && echo ""
	echo "Veuillez entrer ${txtcyn}le chemin complet${txtrst} et le nom du fichier à supprimé :" | centerwide && echo ""
	read rmfile
	echo "" && echo ""
	rm -i $rmfile && echo "${txtgrn}Fichier supprimer avec succés.${txtrst}" | center || echo "${txtred}La suppression du fichier a échoué.${txtrst}" | center
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

3 )
	clear && echo "" && echo "Répertoire de travail actuel:" | center && pwd | center && echo "" && ls && echo ""
	echo "Veuillez entrer ${txtcyn}le chemin complet${txtrst} du répertoire à créer:" | centerwide && echo ""
	read mkdirdir
	echo "" && echo ""
	mkdir $mkdirdir && echo "${txtgrn}Répertoire $mkdirdir créer avec succés.${txtrst}" | centerwide || echo "${txtred}Échec de la création du répertoire.${txtrst}" | center
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

4 )
	clear && echo "" && echo "Répertoire de travail actuel:" | center && pwd | center && echo "" && ls && echo ""
	echo "Veuillez entrer ${txtcyn}le chemin complet${txtrst} du répertoire à supprimé:  ${txtcyn}(DOIT ÊTRE VIDE!)${txtrst}" | centerwide && echo ""
	read rmdirdir
	echo "" && echo ""
	rmdir $rmdirdir && echo "${txtgrn}Répertoire $rmdirdir supprimé avec succés.${txtrst}" | centerwide || echo "${txtred}Échec de supprression du répertoire. Veuillez vous assurer que le répertoire est vide.${txtrst}" | centerwide
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

5 )
	clear && echo "" && echo "Veuillez saisir le fichier d'entrée pour le lien symbolique:  ${txtcyn}(CHEMIN COMPLET!)${txtrst}" | centerwide && echo ""
	read symlinfile
	echo "" && echo "Veuillez saisir le fichier de sortie pour le lien symbolique:  ${txtcyn}(SÉRIEUSEMENT, CHEMIN COMPLET!)${txtrst}" | centerwide && echo ""
	read symloutfile
	echo "" && echo ""
	ln -s $symlinfile $symloutfile
	cat $symloutfile && clear && echo "" && echo "${txtgrn}Lien symbolique créé avec succès à  $symloutfile${txtrst}" | centerwide || echo "${txtred}Échec de la création du lien symbolique. Veuillez vérifier les chemins et les noms de fichiers et réessayer.${txtrst}" | centerwide && rm -f $symloutfile
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

6 )
	clear && echo "" && echo "La propriété de quel fichier doit être modifiée?  ${txtcyn}(DOIT EXISTER, UTILISER LE CHEMIN COMPLET!)${txtrst}" | centerwide && echo ""
	read chownfile
	echo "" && echo "Veuillez saisir le nom d'utilisateur du nouveau propriétaire de  $chownfile:  ${txtcyn}(UTILISATEUR DOIT EXISTER)${txtrst}" | centerwide && echo ""
	read chownuser
	echo "" && echo "Veuillez entrer le nouveau groupe pour $chownfile:  ${txtcyn}(GROUPE DOIT EXISTER)${txtrst}" | centerwide && echo ""
	read chowngroup
	echo "" && echo ""
	chown $chownuser.$chowngroup $chownfile && echo "${txtgrn}Propriété de $chownfile changé avec succés.${txtrst}" | centerwide || echo "${txtred}Échec du changement de propriétaire. Veuillez vérifier si l'utilisateur, le groupe et le fichier existent.${txtrst}" | center
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

7 )
	clear && echo "" && echo "Les autorisations de quel fichier doivent être modifiées?  ${txtcyn}(DOIT EXISTER, UTILISER LE CHEMIN COMPLET!)${txtrst}" | centerwide && echo ""
	read chmodfile
	echo "" && echo "Veuillez saisir la chaîne numérique à trois chiffres pour les autorisations que vous souhaitez définir:" | centerwide
	echo ""
	echo "${txtcyn}( Format est [owner][group][all]  |  ex: ${txtrst}777${txtcyn} pour un contrôle total pour tous )${txtrst}" | centerwide
	echo ""
	echo "${txtcyn}4 = read${txtrst}" | center
	echo "${txtcyn}2 = write${txtrst}" | center
	echo "${txtcyn}1 = execute${txtrst}" | center
	echo ""
	read chmodnum
	echo "" && echo ""
	chmod $chmodnum $chmodfile && echo "${txtgrn}Autorisations pour $chmodfile changée avec succés.${txtrst}" | centerwide || echo "${txtred}Échec de la définition des autorisations.${txtrst}" | center
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

8 )
	clear && echo "" && echo "Veuillez entrer le chemin complet et le nom du fichier que vous souhaitez modifier:" | centerwide && echo ""
	read editfile
	echo "Quel programme souhaitez-vous utiliser pour éditer ce fichier?" | centerwide && echo ""
	echo "${txtcyn}(veuillez entrer le numéro de votre sélection ci-dessous :)${txtrst}" | centerwide
	echo "1. vim" | center
	echo "2. nano" | center
	echo "3. mcedit" | center
	echo "4. emacs" | center
	echo "5. pico" | center
	echo ""
	read editapp
	echo ""
	case $editapp in
		1 )
			vim $editfile || echo "${txtred}Échec de l'ouverture de vim. Veuillez vérifier s'il est installé.${txtrst}" | centerwide
		;;
		
		2 )
			nano $editfile || echo "${txtred}Échec de l'ouverture de nano. Veuillez vérifier s'il est installé.${txtrst}" | centerwide
		;;

		3 )
			mcedit $editfile || echo "${txtred}Échec de l'ouverture de mcedit. Veuillez vérifier s'il est installé.${txtrst}" | centerwide
		;;

		4 )
			emacs $editfile || echo "${txtred}Échec de l'ouverture de emacs. Veuillez vérifier s'il est installé${txtrst}" | centerwide
		;;

		5 )
			pico $editfile || echo "${txtred}Échec de l'ouverture de pico. Veuillez vérifier s'il est installé.${txtrst}" | centerwide
		;;

		* )
			echo "${txtred}S'il vous plaît, faîtes un choix valide.${txtrst}" | center
		;;
	esac
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

9 ) 
	clear && echo "" && echo "Veuillez entrer le ${txtcyn}chemin complet${txtrst} et le nom du fichier que vous souhaitez compresser:" | centerwide && echo ""
	read pressfile
	echo "" && echo "quelle méthode de compression souhaitez-vous utiliser?" | centerwide && echo ""
	echo "${txtcyn}(veuillez entrer le numéro de votre choix ci-dessous)${txtrst}" | centerwide
	echo ""
	echo "1. gzip" | center
	echo "2. bzip2" | center
	echo "3. compress" | center
	echo ""
	read pressmethod
	echo ""
	case $pressmethod in
		1 )
			gzip $pressfile && echo "${txtgrn}Fichier compressé avec succès.${txtrst}" | center || echo "${txtred}Le fichier n'a pas pu être compressé.${txtrst}" | center
		;;

		2 )
			bzip2 $pressfile && echo "${txtgrn}Fichier compressé avec succès.${txtrst}" | center || echo "${txtred}Le fichier n'a pas pu être compressé.${txtrst}" | center
		;;

		3 )
			compress $pressfile && echo "${txtgrn}Fichier compressé avec succès.${txtrst}" | center || echo "${txtred}Le fichier n'a pas pu être compressé.${txtrst}" | center
		;;

		* )
			echo "${txtred}S'il vous plaît, faîtes un choix valide.${txtrst}" | center
		;;
	esac
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

10 )
	clear && echo "" && echo "Veuillez entrer le ${txtcyn}chemin complet${txtrst} et le nom du fichier que vous souhaitez décompresser:" | centerwide && echo ""
	read depressfile
	case $depressfile in
		*.gz | *.GZ )
			gunzip -l $depressfiles && echo "${txtgrn}Fichier décompressé avec succès.${txtrst}" | center || echo "${txtred}Le fichier n'a pas pu être décompressé.${txtrst}" | center
		;;

		*.bz2 | *.BZ2 )
			bunzip2 -f $depressfile && echo "${txtgrn}Fichier décompressé avec succès.${txtrst}" | center || echo "${txtred}Le fichier n'a pas pu être décompressé.${txtrst}" | center
		;;
		
		*.z | *.Z )
			uncompress -f $depressfile && echo "${txtgrn}Fichier décompressé avec succès.${txtrst}" | center || echo "${txtred}Le fichier n'a pas pu être décompressé.${txtrst}" | center
		;;
		
		* )
			echo "${txtred}Le fichier ne semble pas utiliser une méthode de compression valide (gzip, bzip2 ou compress). Veuillez décompresser manuellement.${txtrst}" | centerwide
	esac
	echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer)${txtrst}" | center && read
;;

11 )
	clear && echo "" && echo "Êtes-vous sûr de vouloir revenir au menu principal? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
	read exitays
	case $exitays in
		y | Y )
			clear && show_menu
		;;
		n | N )
			clear && echo "" && echo "D'accord. Pas de soucis." | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
		;;
		* )
			clear && echo "" && echo "${txtred}S'il vous plaît, faîtes un choix valide.${txtrst}" | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
	esac
;;

12 )
	clear && echo "" && echo "Etes-vous sûr de vouloir arrêter? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
	read shutdownays
	case $shutdownays in
		y | Y )
			clear && exit
		;;
		n | N )
			clear && echo "" && echo "D'accord. Pas de soucis." | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
		;;
		* )
			clear && echo "" && echo "${txtred}S'il vous plaît, faîtes un choix valide.${txtrst}" | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
		;;
	esac
;;

* )
	clear && echo "" && echo "${txtred}S'il vous plaît, faîtes un choix valide.${txtrst}" | center && echo "" && echo "${txtcyn}(Cliquez sur ENTREE pour continuer.)${txtrst}" | center && read
;;

esac

done
pause
}

#Gestion du processus
function Gestion_processus() {
clear
write_header "Informations sur l'utilisation du processus"
txtred=$(tput setaf 1)
txtgrn=$(tput setaf 2)
txtylw=$(tput setaf 3)
txtblu=$(tput setaf 4)
txtpur=$(tput setaf 5)
txtcyn=$(tput setaf 6)
txtrst=$(tput sgr0)
COLUMNS=$(tput cols)

center() {
	w=$(( $COLUMNS / 2 - 20 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

centerwide() {
	w=$(( $COLUMNS / 2 - 30 ))
	while IFS= read -r line
	do
		printf "%${w}s %s\n" ' ' "$line"
	done
}

while :
do

clear

echo ""
echo ""
echo "${txtcyn}(Veuillez entrer le numéro de votre choix ci-dessous)${txtrst}" | centerwide
echo ""
echo "1.  Show all processes" | center
echo "2.  Kill a process" | center
echo "3.  Bring up top" | center 
echo "4.  ${txtpur}Return to Main Menu${txtrst}" | center
echo "5.  ${txtred}Exit${txtrst}" | center
echo ""

read processmenuchoice
case $processmenuchoice in

1 )
	clear && echo "" && echo "${txtcyn}(appuyez sur ENTRÉE ou utiliser les touches fléchées pour faire défiler la liste, appuyez sur Q pour revenir au menu)${txtrst}" | centerwide && read
	ps -ef | less
;;

2 )
	clear && echo "" && echo "veuillez entrer le PID du processus que vous souhaitez supprimer:" | centerwide
	read pidtokill
	kill -2 $pidtokill && echo "${txtgrn}Processus terminé avec succès.${txtrst}" | center || echo "${txtred}Le processus n'a pas pu se terminer. Veuillez vérifier le PID et réessayer.${txtrst}" | centerwide
	echo "" && echo "${txtcyn}(appuyez sur ENTRÉE pour continuer.)${txtrst}" | center && read
;;

3 )
	top
;;

4 )
	clear && echo "" && echo "Êtes-vous sûr de vouloir revenir au menu principal? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
	read exitays
	case $exitays in
		y | Y )
			clear && exit
		;;
		n | N )
			clear && echo "" && echo "D'accord. Pas de soucis." | center && echo "" && echo "${txtcyn}(appuyez sur ENTRÉE pour continuer.)${txtrst}" | center && read
		;;
		* )
			clear && echo "" && echo "${txtred}S'il vous plaît, faîtes un choix valide.${txtrst}" | center && echo "" && echo "${txtcyn}(appuyez sur ENTRÉE pour continuer.)${txtrst}" | center && read
	esac
;;

5 )
	clear && echo "" && echo "Êtes-vous sûr de vouloir arrêter? ${txtcyn}y/n${txtrst}" | centerwide && echo ""
	read shutdownays
	case $shutdownays in
		y | Y )
			clear && exit
		;;
		n | N )
			clear && echo "" && echo "D'accord. Pas de soucis." | center && echo "" && echo "${txtcyn}(appuyez sur ENTRÉE pour continuer.)${txtrst}" | center && read
		;;
		* )
			clear && echo "" && echo "${txtred}S'il vous plaît, faîtes un choix valide.${txtred}" | center && echo "" && echo "${txtcyn}(appuyez sur ENTRÉE pour continuer.)${txtrst}" | center && read
		;;
	esac
;;

* )
	clear && echo "" && echo "${txtred}S'il vous plaît, faîtes un choix valide.${txtred}" | center && echo "" && echo "${txtcyn}(appuyez sur ENTRÉE pour continuer.)${txtrst}" | center && read
;;
esac

done
pause
}

#Obtenir des informations sur le système d'exploitation
function info_systeme_exploitation(){
clear
write_header " Systeme d'information "
echo "système d'exploitation : $(uname)"
[ -x $LSB ] && $LSB -a || echo "$LSB commande non insallée (ensemble \$LSB variable)"

pause
}

#Obtenir des informations sur l'hôte telles que DNS, IP et nom d'hôte
function host_info(){
clear
local dnsips=$(sed -e '/^$/d' /etc/resolv.conf | awk '{if (tolower($1)=="nameserver") print $2}')
write_header " Hostname and DNS information "
echo "Hostname : $(hostname -s)"
echo "DNS domain : $(hostname -d)"
echo "Fully qualified domain name : $(hostname -f)"
echo "Network address (IP) : $(hostname -i)"
echo "DNS name servers (DNS IP) : ${dnsips}"
pause
}

#Interface réseau et informations de routage
function reseau_info(){
clear
devices=$(netstat -i | cut -d" " -f1 | egrep -v "^Kernel|Iface|lo")
write_header " information des réseaux "
echo "Nombre total d'interfaces réseau trouvées: $(wc -w <<<${devices})"

echo "*** Informations sur les adresses IP ***"
ip -4 address show

echo "***********************"
echo "*** Routage réseau ***"
echo "***********************"
netstat -nr

echo "*************************************************"
echo "*** Informations sur le trafic de l'interface ***"
echo "*************************************************"

netstat -i

pause 
}

# Afficher une liste des utilisateurs actuellement connectés
# Afficher une liste des utilisateurs récemment connectés
function utilisateur_info(){
clear
local cmd="$1"
case "$cmd" in 
who) write_header " Who is online "; who -H; pause ;;
last) write_header " List of last logged in users "; last ; pause ;;
esac 
}

#Afficher les informations sur la mémoire utilisée et libre
function memoire_info(){
clear
write_header " La mémoire utilisée et libre "
free -m

echo "********************************************"
echo "*** Statistiques de la mémoire virtuelle ***"
echo "********************************************"
vmstat
echo "******************************************************"
echo "*** Top 5 des processus de consommation de mémoire ***"
echo "******************************************************" 
ps auxf | sort -nr -k 4 | head -5 
pause
}

# Obtenir l'adresse IP publique du fournisseur d'accès Internet
function ip_info(){
clear

#cmd='curl -s'
cmd='curl'
write_header " Informations IP publiques "
#ipservice=checkip.dyndns.org
ipservice=https://ipinfo.io/ip
#pipecmd=(sed -e 's/.*Adresse IP actuelle : //' -e 's/<.*$//') #en utilisant des crochets pour l'utiliser comme un tableau et éviter d'avoir besoin d'échapper
$cmd "$ipservice"
echo
pause

}

# Obtenir des informations sur l'utilisation du disque
function disque_info() {
clear
usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
write_header " Informations sur le disque"
if [ "$EXCLUDE_LIST" != "" ] ; then
  df -H | grep -vE "^Filesystem|tmpfs|cdrom|${EXCLUDE_LIST}" | awk '{print $5 " " $6}'
else
  df -H | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{print $5 " " $6}'
fi
pause
}

#Obtenir une entrée via le clavier et prenez une décision en utilisant case
function read_input(){
local c
read -p "Entrez votre choix entre 0 et 12 " c
case $c in
1) Gestion_utilisateurs ;;
2) Gestion_fichiers ;;
3) Gestion_processus ;;
4) info_systeme_exploitation;;
5) host_info ;;
6) reseau_info ;;
7) utilisateur_info "who" ;;
8) utilisateur_info "last" ;;
9) memoire_info ;;
10) ip_info ;;
11) disque_info ;;
0 ) clear && echo "Au revoir!"; exit 0 ;;
*) 
echo "Veuillez saisir un choix entre 0 et 11."
pause
esac
}

# ignorer CTRL+C, CTRL+Z
trap '' SIGINT SIGQUIT SIGTSTP

# Main principale
while true
do
clear
show_menu # Afficher le menu
read_input # attendre l'entrée de l'utilisateur
done
