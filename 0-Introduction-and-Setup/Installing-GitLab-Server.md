# INSTALLING GITLAB SERVER

![Installing GitLab Server Title slide](img/03-SLIDES-Container-Security-with-Kubernetes-and-Gitlab_INSTALLING-GITLAB-SERVER-05102024.001.png)
> Go back to course video: https://community.kubeskills.com/c/container-security-course-videos/sections/497062/lessons/1855265

---

In this lesson, we'll install a self-hosted GitLab server, according to [these docs](https://docs.gitlab.com/ee/install/docker.html#install-gitlab-using-docker-compose)

We will install the latest [GitLab server image](https://hub.docker.com/r/gitlab/gitlab-ce/tags)

You can choose to either follow the below (along with the video), or you can use the install guide above.

## PREREQUISITES

You will need a compute instance with at least 2 CPU and 4GB of RAM. [Create Linode Script](Linode-create.md)

This compute instance will need `docker` and `docker compose` installed as well. Once you've connected to your cloud instance via SSH, please proceed.

Here's a quick script to get Docker and Docker Compose installed on an Ubuntu 20.04 compute instance:
```bash
#!/bin/bash

sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://get.docker.com -o get-docker.sh

chmod +x get-docker.sh

./get-docker.sh

sudo usermod -aG docker $USER
```

## INSTALLING GITLAB SERVER USING DOCKER COMPOSE

> NOTE: DO NOT continue until you've connected to your cloud instance via SSH

Create a file in your home directory named `docker-compose.yml` and paste the following configuration:
> IMPORTANT: Make sure to replace the "PUBLIC_IP_ADDRESS_OF_YOUR_INSTANCE_GOES_HERE" with the public IP of your cloud instance
```yaml
version: '3'
services:
  gitlab:
    image: 'gitlab/gitlab-ce:16.11.2-ce.0'
    restart: always
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://<PUBLIC_IP_ADDRESS_OF_YOUR_INSTANCE_GOES_HERE>/'
        gitlab_rails['store_initial_root_password'] = true
    ports:
      - '443:443'
      - '80:80'
    volumes:
      - '/srv/gitlab/config:/etc/gitlab'
      - '/srv/gitlab/logs:/var/log/gitlab'
      - '/srv/gitlab/data:/var/opt/gitlab'
```

Start the GitLab container with these configurations by running the command `docker compose up -d` from your cloud instance terminal.
```bash
# run the container using docker compose
docker compose up -d
```

`-d` will start the GitLab container in the background.

Access the root password to login with the following command:
```bash
# access gitlab root password
docker exec root-gitlab-1 cat /etc/gitlab/initial_root_password
```

> NOTE: If your are not logged into the cloud instance as root, the name of the container will not be `root-gitlab-1`. If so, run `docker ps` to retreive the correct name (e.g. ubuntu-gitlab-1)

## LOGIN TO GITLAB WEB UI

Once the container is up and running (This may take up to 2 minutes), open a web browser and go to http://your-docker-hostname/ (replace with your cloud instance public IP address).

The page should display a prompt to login. Enter the username as 'root' and the password as the password you retreived from the `docker exec` command run in the previous step.

> NOTE: Please consider changing your password by going to PREFERENCES > PASSWORD in the GitLab UI
