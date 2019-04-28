# local provision

local machine provision playbook

## premise

install ansible commnand

```
brew install ansible
```

## provision

```
ansible-playbook site_localhost.yml -i hosts_localhost --check
```