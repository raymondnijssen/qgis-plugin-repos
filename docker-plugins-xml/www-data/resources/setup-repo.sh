#!/bin/sh

set -e

### WWW ###

WWW_DIR=/var/www

mkdir -p $WWW_DIR

# Set up skeleton of plugin repo, to be overlaid with httpd-data volume

for subdir in 'qgis' 'qgis-dev'; do
  mkdir -p $WWW_DIR/$subdir/plugins/packages
  mkdir -p $WWW_DIR/$subdir/plugins/packages-auth
  touch $WWW_DIR/$subdir/index.html
  touch $WWW_DIR/$subdir/plugins/index.html
done

chmod -R 0755 $WWW_DIR
chown -R ${SSH_USER}:users $WWW_DIR


### Repo update script ###

REPO_UPDATER=/opt/repo-updater
PLUGINS_XML=$REPO_UPDATER/plugins-xml
UPDATE_SCRIPT=$PLUGINS_XML/plugins-xml.py
UPDATE_WRAPPER=$PLUGINS_XML/plugins-xml.sh
PY_VENV=/opt/venv

mkdir -p $REPO_UPDATER/uploads

mv /opt/setup/plugins-xml $PLUGINS_XML

sed -i "s@= WEB_BASE_TEST@= '${WWW_DIR}'@g" ${UPDATE_SCRIPT}

sed -i "s@= UPLOAD_BASE_TEST@= '${REPO_UPDATER}'@g" ${UPDATE_SCRIPT}

sed -i "s@= UPLOADED_BY_TEST@= '${UPLOADED_BY}'@g" ${UPDATE_SCRIPT}

sed -i "s@= DOMAIN_TLD_TEST@= '${DOMAIN_TLD}'@g" ${UPDATE_SCRIPT}

sed -i "s@= DOMAIN_TLD_DEV_TEST@= '${DOMAIN_TLD_DEV}'@g" ${UPDATE_SCRIPT}

sed -i "s@venv@${PY_VENV}@g" ${UPDATE_WRAPPER}

chown -R ${SSH_USER}:users $REPO_UPDATER
