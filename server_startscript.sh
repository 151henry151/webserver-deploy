#!/bin/sh
# Created by Henry Romp on 08192023

# Add admin user
adduser --disabled-password admin
mkdir -p /home/admin/.ssh
chmod 700 /home/admin/.ssh

# Add t440p ssh key
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHS6u7HVacvpB6bQtq0SS8/dpQPyH3S4d1/WTzBUWDNHrKM7HY0JDcUGiozo/lsNh83O/FxxeigZ3uyd6dCd2mtuii89WLQBToP24ofTmc2cm5qqZ7DNreCMyORhzc8IqvACXRBpOYhxrkKCDEoRXec0ukt6kwxNdYizs96VgS3HSaAPuIbqKMwITUOExHZ8RKrob/t+vhPeoOdmZxJyVzD/860irNuTvNmP/NkDnppw4hOGy1Mx+GjU1Y+oqlwmCIkAi6zMuwqCaDAfuYZgGFOtHSSMYLhSLCOAxwofBkZi8yV+Ltph2+gtDVDcAwsObwyfUOKos03uCvf7KpIclZzZDHIKwvcXiLB0U0UVIr/Z0OvW5o1tbXWmKhxn5uBGRBCJDnKaCVbpWoOfTYeWQM7N3Amxghzq3XkFpn6z6gYZNdkrTCygtb6w7p1ynQKYsouP3LyQqtMRgNSkdb1TBp77Ote4ww0vKYN6eKkSZNSl9awj8ldVJlTkrBVdE7Sts= henry@debian" > /home/admin/.ssh/authorized_keys
chmod 600 /home/admin/.ssh/authorized_keys

# Disable password authentication
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

# Forbid root login
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes//g' /etc/ssh/sshd_config

# Allow empty passwords
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/g' /etc/ssh/sshd_config

# Use authorized keys file
sed -i 's/#AuthorizedKeysFile	.ssh\/authorized_keys .ssh\/authorized_keys2/AuthorizedKeysFile	.ssh\/authorized_keys .ssh\/authorized_keys2/g' /etc/ssh/sshd_config

# Enable public key authentication
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

# Update and upgrade system
apt-get update -y
apt-get upgrade -y

# Install configure and enable UFW firewall
apt-get -y install ufw
ufw allow OpenSSH
ufw enable

# Install Apache2 Webserver
apt-get -y install apache2

# Install Certbot
apt-get -y install certbot

# Restart ssh daemon
systemctl restart sshd.service


