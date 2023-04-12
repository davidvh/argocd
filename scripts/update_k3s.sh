#!/bin/bash
source gitops.env
# gitops.env should specify K3S_TOKEN=...
curl -sfL https://get.k3s.io | sh -s - server --disable traefik --default-local-storage-path /export/fast/kubestorage
