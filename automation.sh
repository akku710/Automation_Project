#initialising
s3_bucket=upgrad-aakash
name=aakash
#Repo update
sudo apt update -y
#Apache installed or not
installed=$(dpkg -l | grep apache2)
if [ !  "$installed" ];
then sudo apt install apache2 -y 
fi
#Apache active or not 
running=$(systemctl status apache2 | grep active | awk '{print $3}'|  tr -d '()')
if [ 'running' != '${running}' ]
then 
sudo systemctl start apache2
fi
#Apache enabled or not
enabled=$(sudo systemctl is enabled apache2)
if [ 'enabled' != '${enabled}' ]
then
sudo systemctl enable apache2
fi

#Timestamp
timestamp=$(date '+%d%m%Y-%H%M%S')

#Creating tar archive for logs
cd /var/log/apache2
tar -cvf ${name}-httpd-logs-${timestamp}.tar *.log
mv *.tar /tmp/

# Moving script to s3
aws s3 \
cp /tmp/${name}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/Aakash-httpd-logs-${timestamp}.tar
