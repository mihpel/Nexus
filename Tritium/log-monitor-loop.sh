while : ;do
[[ -z $(docker ps | grep tritium-code) ]] && {
#clear
echo -e "\nWaitting for container with\nname:'nexus'\nand\nimage:'tritium-code'\nto become ready!"
sleep 5
}
[[ -z $(docker ps | grep tritium-code) && -z $(docker ps | grep nexus) ]] || docker logs -f nexus
done
