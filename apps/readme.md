# Apps

This project contains the apps being deployed
See https://github.com/argoproj/argocd-example-apps/tree/master/apps for an example of the app-of-app approach

## Bookstack

This is a wiki service.

### Setup

1. Deploy as normal
2. Log in with one of the LDAP accounts. You will have read-only permissions.
3. Temporarily edit the deployment to set `AUTH_METHOD=standard`.
4. Log in to Bookstack using the default login credentials.
5. Change the default password.
6. Update one of the LDAP accounts to be an Admin.
7. Re-sync the deployment to revert the `AUTH_METHOD` change and configure LDAP access.

## Whoami

This is a basic test application to confirm the service and logged-in account.
