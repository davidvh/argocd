# Infrastructure

This project contains the basic infrastructure for running additional services (e.g. ingress, certificates, storage)
See https://github.com/argoproj/argocd-example-apps/tree/master/apps for an example of the app-of-app approach

## ArgoCD and Argo-ingress

ArgoCD is the core component of this repo. It allows resources to be defined in GIT repositories and apply them to the cluster.

These resource definitions allow ArgoCD to be self-managed and self-updating, and automatically providing an Ingress so that ArgoCD can be accessed through the browser.

## Blocky

Blocky is primarily an ad blocker DNS service, but is used in this case to provide name resolution for services hosted on the cluster.  
Part of the goal of this project is to avoid exposing the services directly to the public internet. Normally your router would handle resolving service names to the IP of this cluster, but without public access most routers don't support wildcard entries so would need separate entries for each service. Blocky allows a single static entry to route all subdomains to the same IP so that your services automatically become available to you as soon as they are deployed.

And as a bonus it also provides ad blocking.

## Cert-Manager and Cert-Issuer

Cert-Manager is one of the few external Helm charts. It creates CRDs in the cluster that allows the definitino of Cert-Issuers. Combined, Cert-Manager and a CertIssuer allow the creation of trusted Certificates for each service URL so that they can provide trusted HTTPS connections and secure communication.

The current design uses Cloudflare as the Certificate Issuer, though Cert-Manager does support other options.

## LLDAP

LLDAP is a simplified LDAP provider. This allows centralized storage of credentials that can be used by other services to authenticate access. This LDAP provider will be used as the backend whereever possible, so that usernames and passowrds should be automatically kept in sync for all of the hosted services.

There are other options for LDAP providers, but LLDAP was chosen because it has low system requirements and is easy to understand.

## NGINX

NGINX is the Ingress provider, and is one of the few external Helm charts. Combined with Ingress Resources and Certificates created for each service, it allows for HTTPS access.

Traefik is another popular choice. NGINX was chosen instead because Traefik has a bug integrating with ArgoCD where the Ingresses always appear to be 'Progressing'.

## Secrets-Generator

One of the greatest challenges working with Kubernetes is how to manage secrets. Secrets-Generator handles one of these issues by allowing the creation of random secrets.

Services which need to create passwords (e.g. a frontend that uses a backend SQL database) can use this application to define random secrets, which will then be stored in Kubernetes and can be shared to other services. This avoids the need to manually define secrets for backends hosted on the cluster.