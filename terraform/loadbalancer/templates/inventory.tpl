[ha_lb]
%{ for index, group in machine_names ~}
${machine_names[index]}.${instance_domain}
%{ endfor ~}
