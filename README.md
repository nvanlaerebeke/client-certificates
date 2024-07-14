# Client Certificate Authentication Using Traefic

## Source

For the kubernetes config files see:

https://www.nerdieworks.nl/posts/client-certificate-authentication-with-traefik/

Based on this blog post the Makefile was created to make things easier.

## Configuration Options

The `Makefile` contains the commands and data to create the CA, client certificates and secret.

Use the following parameters to modify the default settings:

```env
NAME:=crazyzone.be
ORGANIZATION:=CrazyTown
COUNTRY:=BE
STATE:=Oost-Vlaanderen
CITY:=Eine
UNIT:=CrazyTown
PASSWORD:=password
```

## Step 1: Create a CA

To create a CA run the following command:

```console
make CA
```

WARNING!: Any previous CA will be deleted!

## Step 2: Create the Client Certificate

```console
make client
```

## Step 3: Create the secret

```console
make secret
```

Apply the secret to kubernetes cluster.

## Step 4: Test

```console
make test
```

## Using an Existing CA

When there is already a CA, add the files in the "CA" directory in the root.  
Make sure the following files are added:

- CA/ca.crt  
- CA/ca.key  
- CA/ca.srl

Now create a new client certificate by running:

```console
make client NAME=<myname>
```

Note: Existing data is saved in bitwarden and/or keypass
