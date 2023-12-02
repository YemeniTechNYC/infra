# infra

```bash
cat <<EOF > .vault-password-file
vault-secret
EOF

DO_PAT="dop_v1_*****" \
ANSIBLE_PLAYBOOK="playbooks/source.yaml" \
ANSIBLE_INVENTORY_HOST_GROUP="source" \
ANSIBLE_SECRET_PATH="./.vault-password-file" \
SERVICE="source" \
SERVICE_VERSION="0.1.0" \
SOURCE_SNAPSHOT="fedora-38-x64" \
packer build snapshots/template.json.pkr.hcl
```
