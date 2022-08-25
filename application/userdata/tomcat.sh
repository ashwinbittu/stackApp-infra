sudo apt update -y  > /tmp/user-data.log
sudo apt install default-jre -y >>  /tmp/user-data.log
sudo apt install default-jdk -y >> /tmp/user-data.log
sudo apt install tomcat9 tomcat9-admin tomcat9-docs tomcat9-common git -y >> /tmp/user-data.log
touch /home/ubuntu/user-data.log
cat /tmp/user-data.log > /home/ubuntu/user-data.log
