#!/bin/sh

CMDB_PORT=8000

if [ -z "$1" ]
  then
    echo "ERROR: No Ansible inventory given! Provide path to inventory file!"
    exit 1
fi

if [ ! -e "$1" ]
  then
    echo "ERROR: Provided inventory file does not exist!"
    exit 1
fi

if [ ! -d ./tmp/ansible-cmdb-facts ]
  then
    echo "Creating temporary directory './tmp/ansible-cmdb-facts' for Ansible output files."
    mkdir -p ./tmp/ansible-cmdb-facts
fi

echo "Copying inventory file to temporary directory."
cp $1 ./tmp/inventory

echo "Gathering facts for CMDB..."
if ! ansible -i ./tmp/inventory all -m setup --tree ./tmp/ansible-cmdb-facts/ > /dev/null
  then
    echo "ERROR: Gathering facts failed!"
    exit 1
fi

if [ -n "$(docker ps -aq --filter name=ansible-cmdb-web)" ]
  then
    echo "Removing old CMDB container."
    docker rm -f ansible-cmdb-web > /dev/null
fi

echo "Building Ansible CMDB image..."
docker build -t ansible-cmdb . > /dev/null

echo "Starting Ansible CMDB container..."
docker run -dit -p $(hostname -I | awk '{print $1}'):$CMDB_PORT:8000/tcp --name ansible-cmdb-web ansible-cmdb > /dev/null

echo "Removing temporary directory."
rm -rf ./tmp

echo "Ansible CMDB is available:"
echo ">>> http://$(hostname -I | awk '{print $1}'):$CMDB_PORT <<<"
