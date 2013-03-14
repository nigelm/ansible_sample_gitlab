#!/bin/sh
#
# Do a batch of gitlab setup
# Some of this is run as the gitlab user within a big su chunk
# This worked more successfully than trying to mangle sudo to
# handle it.
#
# NOTE
# There are elements here that are site specific - for example
# the ssh hostnames and the git user id.  This could be fixed,
# but it was written as a hack to try this out...

# set ownership of the main gitlab repo
chown -R gitlab.gitlab /home/gitlab/gitlab

# do a batch of the gitlab setup
#
su - gitlab <<EOT
# This connects to the local git/gitolite server - its
# there just to ensure that the ssh host keys are cached
echo 'yes' | ssh -o StrictHostKeyChecking=no git@localhost
echo 'yes' | ssh -o StrictHostKeyChecking=no git@gitlab
echo 'yes' | ssh -o StrictHostKeyChecking=no git@gitlab.local

# Clone the admin repo so SSH adds localhost to known_hosts ...
# ... and to be sure your users have access to Gitolite
git clone git@localhost:gitolite-admin.git /tmp/gitolite-admin

if [ -d /tmp/gitolite-admin ]
then
    rm -rf /tmp/gitolite-admin
else
    exit 3
fi

git config --global user.name "GitLab"
git config --global user.email "gitlab@example.com"

# install a bundle of extra bits...
cd /home/gitlab/gitlab
bundle install --deployment --without development test postgres

# Make directory for satellites
mkdir -p /home/gitlab/gitlab-satellites

EOT

# set up hooks
cd /home/gitlab/gitlab
cp ./lib/hooks/post-receive /home/git/.gitolite/hooks/common/post-receive
chown git:git /home/git/.gitolite/hooks/common/post-receive


# Make sure GitLab can write to the log/ and tmp/ directories
sudo chown -R gitlab log/
sudo chown -R gitlab tmp/
sudo chmod -R u+rwX  log/
sudo chmod -R u+rwX  tmp/


# install init script - might better done direct within ansible
cd /home/gitlab/gitlab-recipes
##install init.d/gitlab-centos /etc/init.d/gitlab
install init.d/gitlab /etc/init.d/gitlab
