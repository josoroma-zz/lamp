# ------------------------------------------------------------------------------

FROM ubuntu:14.04.2

MAINTAINER Josoroma <jorozco@cecropiasolutions.com>

# ------------------------------------------------------------------------------

# Enable multiverse

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list

# ------------------------------------------------------------------------------

# Keep upstart from complaining.

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# ------------------------------------------------------------------------------

# Let the container know that there is no tty.

ENV DEBIAN_FRONTEND noninteractive

# ------------------------------------------------------------------------------

# Installing our custom base server packages.

RUN apt-get -y update && apt-get -y install openssh-server \

    lamp-server^ \

    php5-curl \
    php5-mcrypt \
    php5-pspell \
    php5-xdebug \

    imagemagick \
    php5-imagick \
    php5-gd \

    curl \
    git \
    wget \

    vim \
    nmap \
    htop \
    zip \

    supervisor \

    && apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# ------------------------------------------------------------------------------

# Adding our custom scripts and configuration files.

RUN mkdir /docker /public

ADD . /docker

RUN chmod -R 755 /docker/bin

# ------------------------------------------------------------------------------

# Set HOME so bashrc is sourced

ENV HOME /root

# ------------------------------------------------------------------------------

# Our custom environment variables.

ENV ROOT_PASSWORD root

ENV MYSQL_DEVELOPMENT_TAG development
ENV MYSQL_STAGING_TAG staging

# ------------------------------------------------------------------------------

# Set the locale

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# ------------------------------------------------------------------------------

# Removing default MySQL Databases and Document Root.

RUN rm -fr /var/lib/mysql/* /var/www/html

RUN mkdir -p /var/www/development

# ------------------------------------------------------------------------------

# Run our custom scripts.

RUN /docker/bin/run_setup_root_account.sh \

    && /docker/bin/run_setup_ssh.sh \
    && /docker/bin/run_setup_sudoers.sh \

    && /docker/bin/run_setup_mysql.sh \
    && /docker/bin/run_setup_apache.sh \
    && /docker/bin/run_setup_php.sh \

    && /docker/bin/run_setup_supervisord.sh \

    && /docker/bin/run_setup_bashrc.sh

# ------------------------------------------------------------------------------

# Our custom data volumes ready to persist or share data.

VOLUME  ["/public"]

VOLUME  ["/var/www", "/etc/apache2", "/var/log/apache2"]

VOLUME  ["/var/lib/mysql", "/etc/mysql", "/var/log/mysql"]

# ------------------------------------------------------------------------------

EXPOSE 22 80 3306 9000

# ------------------------------------------------------------------------------

CMD ["/docker/bin/run.sh"]

# ------------------------------------------------------------------------------
