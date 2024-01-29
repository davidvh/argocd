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
4. Purchase a Cloudflare domain domain and create a token for accessing it, with both READ and WRITE permissions (TODO)
5. Edit the DNS settings for your domain in Cloudflare and add an A entry for the root (TODO)
6. Open the TrueNAS console and use the `scripts/update_argocd.sh` commands to install argocd and enable temporary port forwarding.
7. Manually edit your local c:\windows\system32\drivers\etc\hosts file to direct `argocd.<yourdomain>` to the TrueNAS IP.
8. Connect to `https://argocd.<yourdomain>`
9. Add the infrastructure chart from this repo and manually update the cloudflare API secret with the generated token.  
   This will create an ingress for argocd and create a DNS server that can be used to forward your domain requests to the server from inside your network.  
   Note that you will need to manually restart the argocd-server deployment to update the configuration to enable the ingress to work correctly.
10. Manually update the cloudflare API secret in the inadyn project with the generated token.
11. Update your router to use the TrueNAS IP address as the DNS resolver.

## Apps

Argo can add additional applications, including charts from this repo.

### Authoring

Helm supports previewing helm outputs. VSCode also includes this preview capabitliy, and some authoring tools, in a Kubernetes extension.

When I'm authoring a new application I will:
1. (optional) If the application already has a Helm chart, add this to Argo but do not deploy it. The preview of the deployment may be helpful to identify the resources that need to be created.
2. Create a new Helm chart, make the initial configuration (often using the existing charts for reference), and push the changes to github.
3. Add the new Helm chart to Argo. Edit and push changes until the deployed service is working as expected.
4. Add the new Helm chart to the apps list so that it can be completely managed by Argo.

### Important Kubernetes resources

Refer to official Kubernetes documentation for the most current information.

- Deployment/DaemonSet: The Container that will be deployed, how it should be started, how it should be monitored, etc. It is often the most complicated component to define.
- Service: A selector to search Kubernetes for the Container and how any ports should be exposed within the Kubernetes cluster.
- Ingress: Expose an HTTP/HTTPS service outside of the cluster. This is also the point where HTTPS signing takes place via Cert-Manager and sometimes includes annotations to configure authentication requirements to access services. Note that this is only works for HTTPS connections.
- Volumes, PersistentVolumes, PersistentVolumeClaims: Storage. Ideally services should use SQL connections, but some require their own storage. Most storage, include storage of SQL servers, is tightly tied to the computer running the service (TrueNAS provides OpenEBS zfs-localpv support by default). Sometimes it is necessary for multiple services to share files (e.g. videos, music, books, etc.). In this case Samba shares allow for easy management and sharing of files with good access control.

### Troubleshooting

- ArgoCD may have problems deleting some resources. To resolve this:

  1. Attempt to use `k3s kubectl delete ...` to delete the resource. This is likely to fail.
  2. Use `k3s kubectl patch some-resource/some-name -n resource-namespace --type json --patch='[ { "op": "remove", "path": "/metadata/finalizers" } ]'` to force completion of the argocd finalizer.