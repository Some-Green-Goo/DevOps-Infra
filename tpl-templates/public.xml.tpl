<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>Public</short>
  <description>For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted.</description>
  <service name="ssh"/>
  <service name="dhcpv6-client"/>
  <service name="cockpit"/>
  %{ for port in ingress_ports ~}
  <port protocol="tcp" port="${port}"/>
  %{ endfor ~}
  <forward/>
</zone>