# argocd

This repo uses ArgoCD (https://argo-cd.readthedocs.io/en/stable/) to deploy resources onto a Kubernetes instance.  
It has been tested to work with TrueNAS Scale (https://www.truenas.com/truenas-scale/). It should also work with a K3s instance that has not installed traefik yet.

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
