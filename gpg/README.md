# PGP - SSH Setup

For out setup we are using a master key with different sub-keys. The sub-keys are used for handling the basic functionality. The master key on the other hand is used as a long term digital identity for our self

For out setup we are going to use a master key witch will provide a long term digital identity for our self
(possibly 10+ years). This key will be only used to create other sub keys. These sub keys can have other capabilities
such as `Sign`, `Encrypt` or `Authenticate`. The master key has only `Certify` as capability.

## Generating a master-key
Run the following command to start the master key generation process.

```shell
$ gpg --full-generate-key --expert
```

Select the set your own capabilities creation process (type 8 or 11)

```
gpg (GnuPG) 2.2.25; Copyright (C) 2020 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
(1) RSA and RSA (default)
(2) DSA and Elgamal
(3) DSA (sign only)
(4) RSA (sign only)
(7) DSA (set your own capabilities)
(8) RSA (set your own capabilities)
(9) ECC and ECC
(10) ECC (sign only)
(11) ECC (set your own capabilities)
(13) Existing key
Your selection?
```

Disable sign and encrypt capability (type S, E and Q)

```
Possible actions for a RSA key: Sign Certify Encrypt Authenticate
  Current allowed actions: Certify

  (S) Toggle the sign capability
  (E) Toggle the encrypt capability
  (A) Toggle the authenticate capability
  (Q) Finished

  Your selection?
```

Setup the expiration for the master key, I use no expiration date for my master key.

```
Please specify how long the key should be valid.
	0 = key does not expire
	<n>  = key expires in n days
	<n>w = key expires in n weeks
	<n>m = key expires in n months
	<n>y = key expires in n years
Key is valid for? (0)
Key expires at Sat Jul 27 17:59:59 2019 BST
Is this correct? (y/N) y
```

Construct your user ID (input your full name and email, leave comment empty). Type O to complete

```
GnuPG needs to construct a user ID to identify your key.

Real name: Max Mustermann
Email address: max.mustermann@muster.com
Comment:
You selected this USER-ID:
"Max Mustermann <max.mustermann@muster.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
```

Enter a pass-phrase for your master key and remember it for a long time.  
When you did the above steps correctly, you should have the following result

```
We need to generate a lot of random bytes.
It is a good idea to perform some other action  
(type on the keyboard, move the mouse, utilize the disks)
during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

gpg: key <number> marked as ultimately trusted
gpg: revocation certificate stored as '*.rev'
public and secret key created and signed.

pub   rsa4096 2020-07-27 [C] [expires: never]
	0000000000000000000000000000000000000000
uid                      Max Mustermann <max.mustermann@muster.com>
```

## Generate Sign, Encrypt and Authentication sub-keys

## Remove the master-key from the keychain and backup all keys

In order to remove the master key we are going to export all secret keys into a file called `master-secret-key.asc`.
After that we are going to export all sub-keys into another file called `sub-secret-keys.asc`. When we have exported all
secret keys we are going to delete all secret keys and re-import our `sub-secret-keys.asc` which will give us our working
sub-keys back.  
When removing the secret keys, one must confirm the deletion of the keys multiple times.

```shell
gpg -a --export-secret-keys    > master-secret-key.asc && \
gpg -a --export-secret-subkeys > sub-secret-keys.asc && \
gpg --delete-secret-key 'Max Mustermann' && \
gpg --import sub-secret-keys.asc
```

To check the result use `gpg --list-secret-keys`, the output should contain something like:

```
  --------------------------------------------
  sec#  rsa4096 2018-09-14 [C] [expires: 2020-09-13]
        0000000000000000000000000000000000000000
  uid           [ultimate] Max Mustermann <max.mustermann@muster.com>
  ssb   rsa4096 2018-09-14 [S] [expires: 2021-09-13]
  ssb   rsa4096 2018-09-14 [E] [expires: 2021-09-13]
  ssb   rsa4096 2018-09-14 [A] [expires: 2021-09-13]
```

The `#` after the master key means that the key is not stored locally.