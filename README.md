# infra

```bash
cat <<EOF > .vault-secret-file
vault-secret
EOF
DO_PAT=dop_v1_***** SERVICE=website ANSIBLE_SECRET_PATH=./.vault-secret-file packer build snapshots/template.json.pkr.hcl
```
