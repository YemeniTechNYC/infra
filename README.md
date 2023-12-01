# infra

```bash
cat <<EOF > .vault-secret-file
vault-secret
EOF
SOURCE_SNAPSHOT="fedora-38-x64" ANSIBLE_PLAYBOOK="playbooks/source.yaml" ANSIBLE_INVENTORY_HOST_GROUP=source DO_PAT=dop_v1_***** SERVICE=source ANSIBLE_SECRET_PATH=./.vault-secret-file packer build snapshots/template.json.pkr.hcl
```
