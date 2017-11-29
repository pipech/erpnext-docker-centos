FROM centos:7.4.1708

RUN yum -y install \
	build-essential \
	python-setuptools \
	wget \
	nano \
	sudo

RUN useradd frappe \
	&& usermod -aG wheel frappe \
	&& usermod -aG wheel root \
	&& echo "%wheel  ALL=(ALL)  NOPASSWD: ALL" > /etc/sudoers
	
USER frappe
WORKDIR /home/frappe

RUN wget https://raw.githubusercontent.com/frappe/bench/master/playbooks/install.py \
	&& sudo python install.py --develop --mysql-root-password 12345 --admin-password frappe

WORKDIR /home/frappe/frappe-bench
	
RUN sudo service mysql start \
	&& bench new-site site1.local --mariadb-root-password 12345 --admin-password frappe

RUN bench get-app erpnext https://github.com/frappe/erpnext \
	&& cd /home/frappe/frappe-bench/apps/erpnext \
	&& git checkout 15f8fe01794101f91b083c28cf7971a7077bbca5

RUN sudo service mysql start \
	&& bench --site site1.local install-app erpnext

RUN sudo mv /home/frappe/frappe-bench/apps /home/frappe/frappe-bench/apps-temp \
	&& sudo mv /home/frappe/frappe-bench/sites /home/frappe/frappe-bench/sites-temp
	
COPY ./init.sh /home/frappe/ 
	
CMD sudo service mysql start \
	&& /home/frappe/init.sh \
	&& /bin/bash

EXPOSE 8000 8001 8002 8003 8004 8005 3306 3307 3308
