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

## CloudNative Postgresql Operator and Mariadb Operator

The CloudNative Postgresql Operator allows the dynamic provisioning and management of Postgresql databases. The MariaDB Operator allows the dynamic provisioning and management of MariaDB databases. These should cover most database requirements.

When a service requires a database it can define the requirements and load the connection secret to connect to the created database. Although databases can be manually provisioned, the operators provide useful features to expose the databases as services and manage user credentials.

## LLDAP

LLDAP is a simplified LDAP provider. This allows centralized storage of credentials that can be used by other services to authenticate access. This LDAP provider will be used as the backend whereever possible, so that usernames and passowrds should be automatically kept in sync for all of the hosted services.

There are other options for LDAP providers, but LLDAP was chosen because it has low system requirements and is easy to understand.

## Authelia

Authelia is a simple SSO provider supporting LDAP as a backend. It can provide basic authentication requirements for any service, by adding annotations to the ingress, and can serve as an OpenID provider for services that support it. Combined with LLDAP these can allow sharing of most credentials.

## NGINX

NGINX is the Ingress provider, and is one of the few external Helm charts. Combined with Ingress Resources and Certificates created for each service, it allows for HTTPS access.

Traefik is another popular choice. NGINX was chosen instead because Traefik has a bug integrating with ArgoCD where the Ingresses always appear to be 'Progressing'.

## Secrets-Generator and Secrets-Reflector

One of the greatest challenges working with Kubernetes is how to manage secrets. Secrets-Generator handles one of these issues by allowing the creation of random secrets, and Secrets-Reflector allows these secrets to be shared to other namespaces.

Services which need to create passwords (e.g. a frontend that uses a backend SQL database) can use Secrets-Generator attributes to define random secrets, which will then be stored in Kubernetes and can be shared to other services. This avoids the need to manually define secrets for backends hosted on the cluster.  
Services which need to securily access other deployed services can use Secrets-Reflector attributes to read secrets from other namespaces into their own namespace.  
