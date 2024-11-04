# Introduction

Terraform files to deploy clusters of virtual machines with `libvirt` provider.

# Requisites

Packages:
  * `terraform 1.9.6`
  * `libvirt 1:10.3.0-1`
  * `qemu-base 9.1.0-2`

Terraform providers:
  * `dmacvicar/libvirt 0.8.1`

# How to use

1.  Create your own deployment variables file:
```
touch terraform.tfvars
```

2.  Set variables as you want overwriting them in your file:  
Example of `terraform.tfvars`
```
# Network
net_name = "k3s-net"
net_domain = "k3s.local"
net_dns_forwarder = "8.8.8.8"

# Storage
pool_name = "k3s"
pool_path = "/var/lib/libvirt/k3s_pool"

# Nodes
nodes_quantity = 3
nodes_name = "k3s-node"
nodes_cpu = 1
nodes_ram = "512"
nodes_disk_size = 16106127360 #15GiB in bytes
```

3. Create your own `cloud-init.cfg` file and customize it:
```
touch cloud-init.cfg
```
[Cloud-init oficial documentation examples](https://cloudinit.readthedocs.io/en/latest/reference/examples.html)

> :warning: **Create `cloud-init.cfg` at root level**: Terraform expects `cloud-init.cfg` file on root repository directory.

4.  Execute `terraform` commands:
```
terraform init
terraform plan
terraform apply
```

5.  At the end of the `terraform apply` command, it shows the ip assigned for each node:  
Example of output:
```
[...]
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

nodes-ip = [
  "k3s-node-0: 10.17.3.2",
  "k3s-node-1: 10.17.3.3",
  "k3s-node-2: 10.17.3.4",
]
```

6. If it's necessary to have access to the nat network from outside of it for `NEW` packages (default rule is for `RELATED` and `ESTABLISH`), you must replace the `iptables` default rule:
```
sudo iptables -R LIBVIRT_FWI 1 -d 10.17.3.0/24 -j ACCEPT
```
Or remove port mapping behind NAT (for example, for mounting a nfs share volume)
```
$ sudo iptables -t nat -v -L LIBVIRT_PRT -n --line-number
Chain LIBVIRT_PRT (1 references)
num   pkts bytes target     prot opt in     out     source               destination         
1        6   390 RETURN     0    --  *      *       10.17.3.0/24         224.0.0.0/24        
2        0     0 RETURN     0    --  *      *       10.17.3.0/24         255.255.255.255     
3       33  1980 MASQUERADE  6    --  *      *       10.17.3.0/24        !10.17.3.0/24         masq ports: 1024-65535
4      149 11308 MASQUERADE  17   --  *      *       10.17.3.0/24        !10.17.3.0/24         masq ports: 1024-65535
5        0     0 MASQUERADE  0    --  *      *       10.17.3.0/24        !10.17.3.0/24
```
```
$ sudo iptables -t nat -D LIBVIRT_PRT 3
```
(Last command should be run twice in order to remove both port mapping rules)
