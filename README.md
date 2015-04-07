## Docker

If you are using OS X... I am glad because you are probably using:

[Homebrew - The missing package manager for OS X](http://brew.sh/)

Boot2Docker is a "lightweight Linux distribution made specifically to run Docker containers on Windows and Mac."

```
brew update
brew install docker
brew install boot2docker

boot2docker init

boot2docker up
```

More: [Install Docker on Mac](https://docs.docker.com/installation/mac/)

How to install a working Docker environment on Windows using Boot2docker?

[Install Docker on Windows](https://docs.docker.com/installation/windows/)

[humor] If you are using linux... I am very glad, you are probably a "badass curious monkey". [/humor]

## docker pull [image]

https://docs.docker.com/reference/commandline/cli/

```
docker pull ubuntu:14.04.2
```

## Port forwarding workaround

Accessing container exposed ports from our LAN:

```
boot2docker down

VBoxManage modifyvm "boot2docker-vm" --natpf1 "SSHD,tcp,127.0.0.1,2222,,22"
VBoxManage modifyvm "boot2docker-vm" --natpf1 "HTTPD,tcp,127.0.0.1,80,,80"
VBoxManage modifyvm "boot2docker-vm" --natpf1 "MYSQLD,tcp,127.0.0.1,3606,,3606"

boot2docker up
```

### Map Virtual Machine ip to www.localhost.com

```
sudo vi /etc/hosts

# boot2docker ip
192.168.59.103	www.localhost.com
```

### If the Virtual machine is already running, you should run:

```
VBoxManage controlvm "boot2docker-vm" natpf1 "SSHD,tcp,127.0.0.1,2222,,22";
VBoxManage controlvm "boot2docker-vm" natpf1 "HTTPD,tcp,127.0.0.1,80,,80";
VBoxManage controlvm "boot2docker-vm" natpf1 "MYSQLD,tcp,127.0.0.1,3606,,3606";
```

## Useful boot2docker options

```
boot2docker status

boot2docker version

boot2docker info

boot2docker ip
```

### Create a local app skeleton for your local/host development environment:

```
mkdir -p ~/Docker/lamp

cd ~/Docker/lamp

mkdir -p www Dockerfile \
    data/mysqldump data/backup \
    etc/apache2 etc/mysql \
    var/log/apache2 var/log/mysql var/lib/mysql

cd ~/Docker/lamp
```

## Save our new custom image build

```
docker build -t ubuntu/lamp:stable .
```

### Check the virtual machine "/dev/sda1" size:

```
df -h

Filesystem                Size      Used Available Use% Mounted on
rootfs                    1.8G     87.0M      1.7G   5% /
tmpfs                     1.8G     87.0M      1.7G   5% /
tmpfs                  1004.2M         0   1004.2M   0% /dev/shm
/dev/sda1                18.2G    267.0M     17.0G   2% /mnt/sda1
cgroup                 1004.2M         0   1004.2M   0% /sys/fs/cgroup
none                    232.6G     89.0G    143.6G  38% /Users
/dev/sda1                18.2G    267.0M     17.0G   2% /mnt/sda1/var/lib/docker/aufs
```

## Use your OS X user folder as Document Root

OS X users should use a shared local resource inside /Users folder:

```
cd ~/Docker/lamp

tree
.
|____Dockerfile
|____data
| |____backup
| |____mysqldump
|____development
|____etc
| |____apache2
| |____mysql
|____var
| |____lib
| | |____mysql
| |____log
| | |____apache2
| | |____mysql
```

## Run our custom container

```
docker run -d \
-p 2222:22 -p 80:80 -p 3306:3306 -p 9000:9000 \
-v /Users/josoroma/Docker/lamp/data:/data \
-v /Users/josoroma/Docker/lamp/www:/var/www \
-h www.localhost.com \
--name lamp \
ubuntu/lamp:stable

watch docker logs lamp
```

## Create a new Bash session in the lamp container

```
docker exec -it lamp bash
```

## Go to the document root and pull your base project repository

```
cd ~/Docker/lamp/development

git clone git@github.com:josoroma/lamp.git .
```

## Deleting unsuccessful image and container "builds"

```
docker stop lamp && docker rm lamp && docker rmi ubuntu/lamp:stable
```

### List all your available containers:

```
docker ps

docker ps -a
```

### List all your available images:

```
docker images
```

## Use your Browser

If you are using boot2docker get the Virtual Machine IP binded to the Container:

```
boot2docker ip && docker port lamp
```

 - http://192.168.59.103:80/

 - http://www.localhost.com/

## Use SSH to connect to the remote container:

```
ssh root@www.localhost.com -p 2222
```

## Exec commands on the container

### Access remote container using ssh:

```
docker exec -i -t lamp bash
```

### Display remote container process status:

```
docker exec lamp ps -aux
```

### List directory contents of the Remote Container:

```
docker exec lamp ls -la /var/www/development
```

### Gathering software versions of remote container:

```
docker exec lamp apache2 -v

docker exec lamp php -v

docker exec lamp mysql --version

docker exec lamp convert --version
```

### Watching main logs of the remote container:

```
docker exec lamp tail -f /var/log/apache2/error.www.localhost.com.log

docker exec lamp tail -f /var/log/mysql/error.log
```

## MySQL connection to the remote container

### Development connection:

```
mysql -u usrdevelopment -ppassdevelopment dbdevelopment -P 3306 -h www.localhost.com
```

### Development backup:

```
backups

mysqldump -u usrdevelopment -ppassdevelopment dbdevelopment -P 3306 -h www.localhost.com > development_`date +%F_%T | sed 's/[:-]/_/g'`_.sql
```

### Staging connection:

```
backups

mysql -u usrstaging -ppassstaging dbstaging -P 3306 -h www.localhost.com
```

### Staging backup:

```
mysqldump -u usrstaging -ppassstaging dbstaging -P 3306 -h www.localhost.com > staging_`date +%F_%T | sed 's/[:-]/_/g'`_.sql
```

## Display lamp container IP

```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' lamp
```

## Display lamp container PID

```
docker inspect --format '{{ .State.Pid }}' lamp
```

## Delete "ubuntu/lamp:stable" image and "lamp" container

```
docker stop lamp && docker rm lamp && docker rmi ubuntu/lamp:stable
```
