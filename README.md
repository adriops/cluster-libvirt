# Introduction

Terraform files to deploy clusters of virtual machines with `libvirt` provider.

# Requisites

Packages:
  * `terraform 1.3.7-1`
  * `libvirt 1:8.10.0-1`
  * `qemu-base 7.2.0-1`

Terraform providers:
  * `dmacvicar/libvirt 0.7.6`

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

> :warning: **Create `cloud-init.cfg` at root level**: Terraform expects `cloud-init.cfg` file in repository root directory.

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
  "k3s-node-0: 10.17.3.64",
  "k3s-node-1: 10.17.3.18",
  "k3s-node-2: 10.17.3.186",
]
```
