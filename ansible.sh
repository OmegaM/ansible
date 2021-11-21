#!/bin/bash

hosts=($(ansible all --list-host -i playbook/inventory/prod.yml))
for host in ${hosts[@]:1}
do
	name=$host
	if [[ $name == 'localhost' ]] ; then
		continue
	fi
	if [[ $host == "centos" ]] ; then
		host='centos:7'
	fi
	docker run --rm --name $name "pycontribs/$host" sleep 99999 &
done 

ansible-playbook -i playbook/inventory/prod.yml playbook/site.yml --vault-password-file ./secret

docker stop $(docker ps -aq)
