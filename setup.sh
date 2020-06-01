sudo deluser --remove-home guest
sudo deluser --remove-home general
sudo groupdel smbgroup

sudo addgroup smbgroup
sudo useradd -G smbgroup -p $(openssl passwd -1 guest) guest
sudo chage -I -1 -m 0 -M 99999 -E -1 guest
sudo useradd -G smbgroup -p $(openssl passwd -1 general) general
sudo chage -I -1 -m 0 -M 99999 -E -1 general

sudo bash -c "(echo 'guest'; echo 'guest') | smbpasswd -a guest -s"
sudo bash -c "(echo 'general'; echo 'general') | smbpasswd -a general -s"

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
   valid users = guest
   public = no
   browsable = yes
   read only = yes
   writable = no

" >> /etc/samba/smb.conf'


sudo service smbd stop
sudo service smbd start

