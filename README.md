# Fetchmail plus MSMTP

[cguenther/docker-fetchmail](https://github.com/cguentherTUChemnitz/docker-fetchmail) plus MSMTP. Particularly useful for auto-forwarding emails from email providers who don't have the functionality built in (ie AOL).

## Example configuration:

Will forward username@aol.com to example@gmail.com:

```
docker run -it --name fetchmail -v /fetchmail_config:/data -e TIMECRON:300 zweizs/docker-fetchmail-plus-msmtp
```

`/fetchmail_config/etc/fetchmailrc`
```
set no syslog
set logfile /data/log/fetchmail.log

set postmaster "fetchmail"

poll imap.aol.com with proto IMAP
  user 'username' there with password 'passw0rd' is fetchmail here
  ssl
  keep
  mda "/usr/bin/msmtp -C /data/etc/msmtprc -a default example@gmail.com"

```

`/fetchmail/etc/msmtprc`
```
# Set default values for all following accounts.
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        /data/log/msmtp.log

# Gmail
account        gmail
host           smtp.gmail.com
port           587
from           example@gmail.com
user           example@gmail.com
password       passw0rd

# Set a default account
account default : gmail
```

## Available for Hire

I'm available for freelance, contracts, and consulting both remotely and in the Hudson Valley, NY (USA) area. [Some more about me](https://www.zweisolutions.com/about.html) and [what I can do for you](https://www.zweisolutions.com/services.html).

Feel free to drop me a message at:

```
hi [a+] zweisolutions {●} com
```

## License

[MIT](./LICENSE)
