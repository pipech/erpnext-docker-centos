FROM centos:7.4.1708

# install prerequisite
RUN yum -y update \
    && yum -y install \
    build-essential \
    python-setuptools \
    wget \
    nano \
    sudo

# install NodeJS 8.x
RUN curl -sL https://rpm.nodesource.com/setup_8.x | sudo -E bash - \
    && sudo yum install -y nodejs

# add users without sudo password
ENV systemUser=frappe

RUN useradd $systemUser \
    && usermod -aG wheel $systemUser \
    && echo "%wheel  ALL=(ALL)  NOPASSWD: ALL" > /etc/sudoers.d/sudoers

# install bench with easy install script
ENV easyinstallRepo='https://raw.githubusercontent.com/frappe/bench/master/playbooks/install.py' \
    adminPass=12345 \
    mysqlPass=12345 \
    benchSetup=develop \
    benchBranch=master \
    benchName=bench-dev

RUN wget $easyinstallRepo \
    && python install.py \
    --without-site \
    --$benchSetup \
    --mysql-root-password $mysqlPass  \
    --admin-password $adminPass  \
    --user $systemUser  \
    --bench-name $benchName  \
    --bench-branch $benchBranch

# set user and workdir
USER $systemUser
WORKDIR /home/$systemUser/$benchName

# create new site & install erpnext & switch to branch master
ENV erpnextRepo='https://github.com/frappe/erpnext' \
    siteName=site1.local \
    branch=master

RUN  sudo service mysql start \
    # create new site
    && bench new-site $siteName \
    --mariadb-root-password $mysqlPass  \
    --admin-password $adminPass \
    # install erpnext
    && bench get-app erpnext $erpnextRepo \
    && bench --site $siteName install-app erpnext \
    # switch to master branch
    && bench switch-to-branch $branch \
    && bench update --patch

# install supervisor to be use in production setup
RUN sudo yum -y update \
    && sudo yum -y install \
    supervisor
	
# expose port
EXPOSE 8000 8001 8002 8003 8004 8005 3306 3307 3308
