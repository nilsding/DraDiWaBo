# Deployment

Deployment is done via Ansible 2.6.

## Requirements (server)

- CentOS 7
- SystemD

## Usage

Create a file `./inventory` which looks like this:

```
[bot_servers]
srv1.example.com
```

And run the playbook from this directory:

```
ansible-playbook bot.yml -i ./inventory
```

It's that simple.  Well... almost.  You have to edit `/etc/sysconfig/dradiwabo`
on the server to update the configuration.  After that, maybe restart the
`dradiwabo` service via `systemctl restart dradiwabo`. But that's it, really.
