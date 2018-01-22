FROM centos:7.4.1708

# install prerequisite
RUN yum -y install \
	build-essential \
	python-setuptools \
	wget \
	nano \
	sudo

# add users without sudo password
ENV SYSTEMUSER=frappe

RUN useradd $SYSTEMUSER \
	&& usermod -aG wheel $SYSTEMUSER \
	&& echo "%wheel  ALL=(ALL)  NOPASSWD: ALL" > /etc/sudoers.d/sudoers
	
# install bench with easy install script
ENV ADMINPASS=12345 \
	MYSQLPASS=12345 \
	BENCHSETUP=develop \
	BENCHNAME=bench-dev

RUN wget https://raw.githubusercontent.com/frappe/bench/master/playbooks/install.py \
	&& python install.py --without-site --$BENCHSETUP --mysql-root-password $MYSQLPASS --admin-password $ADMINPASS --user $SYSTEMUSER --bench-name $BENCHNAME

USER $SYSTEMUSER
WORKDIR /home/$SYSTEMUSER/$BENCHNAME

# create new site & install erpnext
ENV SITENAME=site1.local \
	ERPNEXT_REPO=https://github.com/frappe/erpnext \
	ERPNEXT_BRANCH=develop

RUN sudo service mysql start \
	&& bench new-site $SITENAME --mariadb-root-password $MYSQLPASS --admin-password $ADMINPASS \
	&& bench get-app erpnext $ERPNEXT_REPO  --branch $ERPNEXT_BRANCH \
	&& bench --site $SITENAME install-app erpnext
	
WORKDIR /home/$SYSTEMUSER/frappe-bench

EXPOSE 8000 8001 8002 8003 8004 8005 3306 3307 3308