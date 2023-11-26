# Setting up Server

to generate inventory.ini

```bash
do-ansible-inventory -t $DO_PAT --out inventory.ini --no-group-by-region --no-group-by-project
```


to build jumpserver

```bash
ansible-playbook -i inventory.ini jumpserver.yaml --skip-tags vim -u root
```
