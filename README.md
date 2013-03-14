Ansible - Sample Gitlab Build
=============================

Sample Gitlab Install on Ubuntu - Ansible recipe

This was built for trying out gitlab in our lab environment.  It may not be the best way of doing things - we are neither an Ubuntu or a Ruby house - so are following prebuilt recipes.

I had some issues getting Gitlab to start after doing all this.  And I am not sure why it started working - but I subsequently demolished the environment and rebuilt from scratch, and this time it worked fine… Sometimes software is too much like magic and the way you look at the server changes how it behaves!

I have excised a batch of specific references to our environments - and this also means that one of the included task files (standard_server.yml) has been completely gutted - this should make no difference to using the overall file.

There are only minor changes from the version which I use, but of course its always possible that I broke it in taking out our site specific configs.  If it breaks, you get to keep both pieces.

This depends on a few things which we have defined in group variables.  For example the mail server config is in our group_vars/all file:-

    mail_server:
        host:       10.0.0.4
        port:       587
        domain:     development.example.com
        auth_user:  mailauthuser
        auth_pass:  mailauthpass
