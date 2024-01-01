# argocd

This repo uses ArgoCD (https://argo-cd.readthedocs.io/en/stable/) to deploy resources onto a Kubernetes instance.  
It has been tested to work with TrueNAS Scale (https://www.truenas.com/truenas-scale/). It should also work with a K3s instance that has not installed traefik yet.

## Why?

Docker-Compose definitions are fairly clear and readable, but have some functional limitations (particularly around secrets) that make Kubernetes a preferable solution. Initially I tried using existing Helm charts to manage services, but I found these were usually quite heavy and were often difficult to understand.  
This repo is partly to improve my own understanding of Kubernetes and partly as an exercise in minimalism to create a compose-like solution running on Kubernetes.

ArgoCD is an excellent tool for this, since it helps to visualize the Kubernetes components and show how they are connected. As a bonus, the definitions are stored in a GIT repo so that they can be safely managed. 

## Initialization

1. In TrueNAS, enable Applications
2. In TrueNAS, configure the UI to run on a different port (e.g. 444)
3. Configure TrueNAS to use a static IP address. This will be necessary to route your domain to the created services.
4. Purchase a Cloudflare domain domain and create a token for accessing it (TODO)
5. Open the TrueNAS console and use the `scripts/update_argocd.sh` commands to install argocd and enable temporary port forwarding.
6. Manually edit your local c:\windows\system32\drivers\etc\hosts file to direct `argocd.<yourdomain>` to the TrueNAS IP.
7. Connect to `https://argocd.<yourdomain>`
8. Add the infrastructure chart from this repo. This will create an ingress for argocd and create a DNS server that can be used to forward your domain requests to the server from inside your network.  
   Note that you will need to manually restart the argocd-server deployment to update the configuration.
9. Update your router to use the TrueNAS IP address as the DNS resolver.

## Apps

Argo can add additional applications, including charts from this repo.

### Authoring

Helm supports previewing helm outputs. VSCode also includes this preview capabitliy, and some authoring tools, in a Kubernetes extension. 

### Troubleshooting

- ArgoCD may have problems deleting some resources. To resolve this:

  1. Attempt to use `k3s kubectl delete ...` to delete the resource. This is likely to fail.
  2. Use `k3s kubectl patch some-resource/some-name -n resource-namespace --type json --patch='[ { "op": "remove", "path": "/metadata/finalizers" } ]'` to force completion of the argocd finalizer.