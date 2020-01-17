FROM registry.redhat.io/rhscl/php-72-rhel7

USER root

RUN subscription-manager register --username <USER_REDHAT> --password <PW_REDHAT>
RUN subscription-manager attach --auto
RUN yum-config-manager --enable remi-php72

RUN yum install yum-utils

RUN yum update -y

RUN yum install -y rh-php72-php-devel install libapache2-mod-php72 php72-cgi php72-cli php72-common php72-curl php7.2-gd php72-imap php72-intl php72-json php72-ldap php72-mbstring php72-mysql php72-opcache php72-pspell php72-readline php72-soap php72-xml gcc-c++ gcc make

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
RUN yum remove unixODBC-utf16 unixODBC-utf16-devel
RUN ACCEPT_EULA=Y yum -y --assumeyes install msodbcsql17
RUN ACCEPT_EULA=Y yum -y --assumeyes install mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc
RUN yum install -y unixODBC-devel

RUN pecl install sqlsrv
RUN echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/sqlsrv.ini

RUN pecl install pdo_sqlsrv
RUN echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/pdo_sqlsrv.ini

USER 1001
