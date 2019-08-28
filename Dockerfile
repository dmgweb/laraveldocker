FROM centos:centos7

###########################################################################################
### Instalamos la paquetería necesaria para el contenedor:
###########################################################################################

RUN yum -y install curl wget unzip git vim \
iproute python-setuptools hostname inotify-tools yum-utils which \
epel-release openssh-server openssh-clients nano net-tools htop

RUN yum -y install python-setuptools \
&& mkdir -p /var/log/supervisor \
&& easy_install supervisor

RUN yum -y install httpd mod_ssl exim

RUN wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
&& rpm -Uvh remi-release-7.rpm \
&& yum-config-manager --enable remi-php73 \
&& yum -y install php php-devel php-gd php-pdo php-soap php-xmlrpc php-zip php-mysql php-mcrypt php-xml php-mbstring

RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf \
&& chown root:apache /var/www/html \
&& chmod g+s /var/www/html




RUN rm -rf /etc/httpd/conf/httpd.conf
ADD httpd.conf /etc/httpd/conf/httpd.conf
##########################################################################################
### Fin de instalación de paqueteria
##########################################################################################


##########################################################################################
### Despliegue de la aplicación
##########################################################################################

# Como simplemente es montar volumen local, no hace falta nada aquí


##########################################################################################
### Fin Despligue de la apliación
##########################################################################################


###########################################################################################
### Construimos el fichero de supervisor, que será el necesario para arrancar el contenedor
###########################################################################################

RUN touch /etc/supervisord.conf

RUN echo $' \n\
[unix_http_server]  \n\
file=/tmp/supervisor.sock \n\
[supervisord] \n\
nodaemon=true \n\
 \n\ 
[program:httpd] \n\
command=/usr/sbin/httpd -DFOREGROUND \n\
 \n\ 
[group:allservices] \n\
programs=httpd \n\
 \n\ 
[rpcinterface:supervisor] \n\
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface \n\
 \n\
[supervisorctl] \n\
serverurl=unix:///tmp/supervisor.sock         ; use a unix:// URL  for a unix socket \n\

' >> /etc/supervisord.conf

##########################################################################################
### Fin de construcción del ficher de supervisor
##########################################################################################

EXPOSE 22 80 443 
CMD ["/usr/bin/supervisord"]
