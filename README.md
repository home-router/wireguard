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
