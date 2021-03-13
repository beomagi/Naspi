# remove users and groups if they already exist
sudo deluser --remove-home guest > /dev/null 2>&1
sudo deluser --remove-home general > /dev/null 2>&1
sudo groupdel smbgroup > /dev/null 2>&1
# create users and group. 
sudo addgroup smbgroup

fnuseradd () {
  username=$1
  sudo useradd -G smbgroup -p $(openssl passwd -1 ${username}) ${username}
  sudo chage -I -1 -m 0 -M 99999 -E -1 ${username}
  echo -e "${username}\n${username}" | smbpasswd -a ${username} -s
}

fnuseradd guest
fnuseradd general


cd ~
mkdir shares
chmod a+rx ./shares
cd shares
ln -s /media/pi/major/major major
cd /media
sudo chmod a+rx pi
cd /home/pi/shares


sudo bash -c 'grep "\[major\]" /etc/samba/smb.conf || echo "
[major]
   comment = Library
   path = /home/pi/shares/major
   public = no
   browsable = yes
   read only = yes
   writeable = no
   valid users = guest general
   write list = general

" >> /etc/samba/smb.conf'


sudo service smbd stop
sudo service smbd start

