[ha_lb]
%{ for index, group in machine_names ~}
${machine_names[index]}.${instance_domain} ansible_ssh_host=${machine_ips[index]} keepalived_state=%{ if index == 0 }MASTER%{ else }BACKUP%{ endif }
%{ endfor ~}

[ha_lb:vars]
vip_ip = ${vip_ip}
