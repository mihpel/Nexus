while :
do
	if [[ -z $(docker ps | grep tritium-code) && -z $(docker ps | grep nexus) ]]
	then
#		clear
		echo -e "\nWaitting for container with\nname:'nexus'\nand\nimage:'tritium-code'\nto become ready!"
		sleep 5
	else
		docker logs -f nexus
	fi
done
