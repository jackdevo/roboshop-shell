StatusCheck() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
}

echo "COnfiguring NodeJS yum Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
StatusCheck

echo Installing NodeJS
yum install nodejs -y
StatusCheck

useradd roboshop

curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
cd /home/roboshop
rm -rf catalogue
unzip -o /tmp/catalogue.zip
mv catalogue-main catalogue
cd /home/roboshop/catalogue
npm install

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
