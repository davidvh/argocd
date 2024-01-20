# Apps

This project contains the apps being deployed
See https://github.com/argoproj/argocd-example-apps/tree/master/apps for an example of the app-of-app approach

## Bookstack

This is a wiki service.

### Setup

1. Deploy as normal
1. (TODO) Manually add the bookstack LDAP user account to the LDAP service with read-only and password management permissions.
2. Log in with one of the LDAP accounts. You will have read-only permissions.
3. Temporarily edit the deployment to set `AUTH_METHOD=standard`.
4. Log in to Bookstack using the default login credentials.
5. Change the default password.
6. Update one of the LDAP accounts to be an Admin.
7. Re-sync the deployment to revert the `AUTH_METHOD` change and configure LDAP access.

## Jellyfin

This is a media player.

### Setup

1. Configure Samba shares in Truenas for your Movies, TV Shows, etc.
2. Create a user account for Jellyfin to access the Samba shares. Remember the username and the UID that Truenas assigns.
3. Deploy Jellyfin
   - Configure the UID and GID to match the Truenas user.
   - Configure the smbSecrets with the Truenas username
   - Configure the smbMounts to mount the Samba shares
4. (TODO) Manually update the created SMB secret with the correct password
5. Login to the Jellyfin service. Configure an admin user and add the Samba shares.
6. Add the LDAP plugin and restart Jellyfin
7. Create a new LDAP user account for Jellyfin with read-only and password management permissions.
8. Configure the LDAP plugin to connect to the LLDAP instance using the created LDAP user (see https://github.com/lldap/lldap/blob/main/example_configs/jellyfin.md).

## Whoami

This is a basic test application to confirm the service and logged-in account.
