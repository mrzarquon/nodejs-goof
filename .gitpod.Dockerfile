# syntax=docker/dockerfile:1.4
FROM docker.io/gitpod/workspace-node 

# below is an inline bash script to populate this container with a helper script to run at login
# this is really a terrible idea and why aws_init.sh is used instead
RUN <<'EOF' bash
set -ex

TMPDIR=$(mktemp -d)
cd "${TMPDIR}" || exit 1
curl -O -s -L "https://static.snyk.io/cli/latest/snyk-linux"
curl -O -s -L "https://static.snyk.io/cli/latest/snyk-linux.sha256"
if sha256sum -c snyk-linux.sha256; then
    sudo mv snyk-linux /usr/local/bin/snyk
    sudo chmod +x /usr/local/bin/snyk
else
    exit 1
fi

curl -o mongodb.tgz -s -L https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-5.0.13.tgz
tar xf mongodb.tgz
cd mongodb-*
sudo cp bin/* /usr/local/bin/
sudo mkdir -p /data/db
sudo chown gitpod:gitpod -R /data/db
cd /
rm -rf "${TMPDIR}"
EOF
