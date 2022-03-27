#!/usr/bin/env python3

import socket
import json
from yaml import dump
import yaml

file_name = 'hosts.json'
file_name_yml = 'hosts.yml'
names = ['drive.google.com', 'mail.google.com', 'google.com']

try:
    with open(file_name) as json_file:
        file_data = json.load(json_file)
except IOError:
    file_data = {}


for name_ip in names:
    # get ip by host name_ip
    ip_address = socket.gethostbyname(name_ip)
    # compare IPs
    if name_ip in file_data:
        previous_ip = file_data[name_ip]
        if previous_ip != ip_address:
            print('[ERROR] {name_ip} IP mismatch: {previous_ip} {ip_address}'.format(name_ip=name_ip, previous_ip=previous_ip, ip_address=ip_address))

    print('{name_ip} - {ip_address}'.format(name_ip=name_ip, ip_address=ip_address))
    # save to file data
    file_data[name_ip] = ip_address

# write to file
with open(file_name, 'w') as outfile:
    json.dump(file_data, outfile)

with open(file_name_yml, 'w') as outfile_yml:
    yaml.dump(file_data, outfile_yml)
