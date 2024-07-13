# Ansible role to deploy WireGuard

Generate a key pair:

```
wg genkey | tee wgprivate.key | wg pubkey >wgpublic.key
```

Then take a look at [defaults/main.yml](defaults/main.yml).

## Update remote server IP address with dynamic DNS

If remote server uses dynamic DNS, set `resolve_dns` section in `defaults/main.yml`
and run `wireguard-resolve-dns.sh` script on client system.

Note this role assums peer1 is the remote server. Change the template if you have
different configurations.

## Running inside LXC container

Please refer to docs in [Xray ansible role](https://github.com/home-router/xray?tab=readme-ov-file#running-inside-lxc-container).

Basically config inventory as follows (assume container running wireguard is named `router`):

```
# Mark pve1 as PVE host, thus only execute kernel module setup tasks.
[pve_host]
pve1

# Mark router as lxc_container. Thus should not make kernel module related changes.
[lxc_container]
router

[wireguard]
router
pve1
```
