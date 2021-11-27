# Ansible CMDB in Docker

This project contains a script which gathers facts for all hosts in a given Ansible inventory and converts them into a static HTML page. This page is then served by a webserver in a Docker container, which is build and run every time the script is executed. The webserver port can be adjusted inside the script.  
The Docker image utilizes the `ansible-cmdb` package, more informations in the [ansible-cmdb repository](https://github.com/fboender/ansible-cmdb).  

[![CodeFactor](https://www.codefactor.io/repository/github/timgrt/docker-ansible-cmdb/badge)](https://www.codefactor.io/repository/github/timgrt/docker-ansible-cmdb)

## Requirements

* Ansible (for gathering the facts)
* Docker (for serving the webserver)

It is expected that the Ansible Ad-hoc command to gather the facts can be run from the inventory itself, if any additional configuration is necessary, this will not work.

## Execution
Run the script (providing the Ansible inventory):
```bash
./run-ansible-cmdb.sh /path/to/inventory
```

## Author
Created 2021 by Tim Grützmacher