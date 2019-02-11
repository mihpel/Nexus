#!/bin/bash
check_mega () {
	[[ $(which megals) ]] || {
		[[ $(id -u) -ne 0 ]] && duid=sudo
		${duid} apt-get -qy update
		${duid} apt-get -qy install megatools
	}
	[[ -f ${HOME}/.megarc ]] || {
		echo "[Login]" > ${HOME}/.megarc
		echo "Username = ${megauser}" >> ${HOME}/.megarc
		echo "Password = ${megapass}" >> ${HOME}/.megarc
	}
}

check_dropbox () {
        [[ -f dropbox_uploader.sh ]] || {
                wget https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh
        }
        [[ -f ${HOME}/.dropbox_uploader ]] || {
                echo "OAUTH_ACCESS_TOKEN=${OAUTH_ACCESS_TOKEN}" > ${HOME}/.dropbox_uploader
        }
}

crash_height () {
	cheight=$(grep 'height' ${HOME}/${DOCK_DIR}/${NEXUS_VERSION}.TAO/debug.log | tail -n 1 | tr ' ' '\n' | grep height)
	sed -i '/crash height/,-1 d' ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/compiled_version.txt
	echo -e "\ncrash ${cheight}" >> ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/compiled_version.txt
}

. ./settings.ini

uploaddate="$(date --utc +%y-%m-%d)"
uploadtime="$(date --utc +%H-%M-%S)"
dumpcommit="$(cat ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/compiled_version.txt | grep ^commit | awk '{print $2}')"
timestamp=(date +'%s')
pushd ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/LLL-TAO/
branch="$(git branch | awk '{print $2}')"
popd

crash_height

for i in \
compiled_version.txt \
debug.log \
$(ls -1 ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/ | grep ^core)
do \
[[ -f ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/${i} ]] && {
	[[ "${i}" = "compiled_version.txt" ]] || {
		pushd ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/
		tar -czvf ${uploadtime}-${i}.tar.gz ${i}
		popd
	}
	[[ "${i}" = "compiled_version.txt" ]] && {
		pushd ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/
		cp ${i} ${uploadtime}-${i}
		popd
	}
	[[ ${UPLOAD} = "yes" ]] && {
                extention=".tar.gz"
                [[ "${i}" = "compiled_version.txt" ]] && extention=""
		[[ ",${upload_method}," =~ ",dropbox," ]] && {
			check_dropbox
			bash dropbox_uploader.sh upload ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/${uploadtime}-${i}${extention} dumps/${branch}/${uploaddate}/commit-${dumpcommit}/$(hostname)-${uploadtime}-${i}${extention}
		}
		[[ ",${upload_method}," =~ ",mega," ]] && {
			check_mega
			[[ $(megals | grep commit-${dumpcommit} | grep -v Trash ) ]] || {
				[[ $(megals | grep /Root/dumps) ]] || megamkdir /Root/dumps
				[[ $(megals | grep /Root/dumps/${branch}) ]] || megamkdir /Root/dumps/${branch}
				[[ $(megals | grep /Root/dumps/${branch}/${uploaddate}) ]] || megamkdir /Root/dumps/${branch}/${uploaddate}
				megamkdir /Root/dumps/${branch}/${uploaddate}/commit-${dumpcommit}
			}
			megaput  --path /Root/dumps/${branch}/${uploaddate}/commit-${dumpcommit}/$(hostname)-${uploadtime}-${i}${extention} ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/${uploadtime}-${i}${extention}
		}
		[[ "${i}" = "compiled_version.txt" ]] || rm ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/${i}
		rm ~/${DOCK_DIR}/${NEXUS_VERSION}.TAO/${uploadtime}-${i}${extention}
	}
}
done
