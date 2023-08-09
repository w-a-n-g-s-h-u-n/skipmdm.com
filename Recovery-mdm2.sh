#!/bin/bash
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${CYAN}*******************************************${NC}"
echo -e "${YEL}* Check MDM - Skip MDM Auto for MacOS by *${NC}"
echo -e "${RED}*             SKIPMDM.COM                 *${NC}"
echo -e "${CYAN}*******************************************${NC}"
echo ""
PS3='Please enter your choice: '
options=("Bypass on Recovery" "Exit")
select opt in "${options[@]}"; do
	case $opt in
	"Bypass on Recovery")
		echo -e "${GRN}Bypass on Recovery${NC}"
		if [ -d "/Volumes/Macintosh HD - Data" ]; then
   			diskutil rename "Macintosh HD - Data" "Data"
		fi
		echo -e "${CYAN}Create a new user / Tạo User mới${NC}"
		echo -e "${PUR}Press Enter to continue, Note: Leaving it blank will default to the automatic user / Nhấn Enter để tiếp tục, Lưu ý: có thể không điền sẽ tự động nhận User mặc định${NC}"
  		echo -e "Enter the username (Default: Apple) / Nhập tên User (Mặc định: Apple)"
		read realName
  		realName="${realName:= Apple}"
    	echo -e "${BLUE}Nhận username ${RED}WRITE WITHOUT SPACES / VIẾT LIỀN KHÔNG DẤU ${GRN} (Mặc định: Apple)"
      	read username
		username="${username:=Apple}"
  		echo -e "${BLUE}Enter the password (default: 1234) / Nhập mật khẩu (mặc định: 1234)"
    	read passw
      	passw="${passw:=1234}"
		if [ -d "/Volumes/Data/private/var/db/dslocal/nodes/Default" ]; then
    dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default'
else
    dscl_path='/Volumes/Macintosh\ HD\ -\ Data/private/var/db/dslocal/nodes/Default'
fi
        echo -e "${GREEN}Creating User / Đang tạo User"
  		# Create user
    	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
      	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	 	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
		mkdir "/Volumes/Data/Users/$username"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
	    dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
	    dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
		echo "0.0.0.0 deviceenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
		echo "0.0.0.0 mdmenrollment.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
		echo "0.0.0.0 iprofiles.apple.com" >>/Volumes/Macintosh\ HD/etc/hosts
        echo -e "${GREEN}Successfully blocked host / Thành công chặn host${NC}"
		# echo "Remove config profile"
  	if [ -f "/Volumes/Data/private/var/db/.AppleSetupDone" ]; then
  touch "/Volumes/Data/private/var/db/.AppleSetupDone"
else
  touch "/Volumes/Macintosh HD - Data/private/var/db/.AppleSetupDone"
fi
  rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
		echo "----------------------"
		break
		;;
    "Disable Notification (SIP)")
    	echo -e "${RED}Please Insert Your Password To Proceed${NC}"
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;
    "Disable Notification (Recovery)")
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

        break
        ;;
	"Check MDM Enrollment")
		echo ""
		echo -e "${GRN}Check MDM Enrollment. Error is success${NC}"
		echo ""
		echo -e "${RED}Please Insert Your Password To Proceed${NC}"
		echo ""
		sudo profiles show -type enrollment
		break
		;;
	"Quit")
		break
		;;
	*) echo -e "${RED}Invalid option $REPLY${NC}" ;;
	esac
done