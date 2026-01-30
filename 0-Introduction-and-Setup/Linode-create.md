
## 🚀 **Steps to Launch 1 Linode GitLab Server**

### 🔹 Step 1: Pick Your Options

Decide on:

| Option    | Example                        |
| --------- | ------------------------------ |
| Region    | `es-mad`                       |
| Image     | `ubuntu22.04`                  |
| Type      | `g6-standard-1` (1 CPU / 2 GB) |
| Label     | `controlplane`, `worker`       |
| Root Pass | (pick secure password or auto) |

To list available options:

```bash
linode-cli regions list
linode-cli images list
linode-cli linodes types
```

---

### 🔹 Launch the First Linode

```bash
# with keys
linode-cli linodes create \
  --label gitlab-server \
  --region es-mad \
  --type g6-standard-4 \
  --image linode/ubuntu22.04 \
  --no-defaults \
  --root_pass 'superSecurePa$$!!' \
  --authorized_keys "$(cat ~/.ssh/id_rsa.pub)" \
  --booted true
```

## 🔍 **List all Linodes with status**
```bash
# get the ID of the linode
linode-cli linodes list --format id,label,status,region,image --text

# get the status of linode with ID `79619316`
linode-cli linodes view 79619316


```

---

## ✅ Post-Launch

To confirm both instances are running:

```bash
linode-cli linodes list --label gitlab-server


#################
# DELETE LINODE
##################
GITLAB_SERVER_ID=$(linode-cli linodes list --label gitlab-server --format id --text | tail -n1)

linode-cli linodes delete "$GITLAB_SERVER_ID"

linode-cli linodes list --label gitlab-server --format id --text | tail -n1

# list all linodes
linode-cli linodes list --format id,label,status --text



```

To fetch the IP addresses:

```bash
linode-cli linodes list --label gitlab-server --format ipv4 --text

export GITLAB_SERVER_IP=$(linode-cli linodes list --label gitlab-server --format ipv4 --text | tail -n +2)
```

---

## Connect to Linode's

> NOTE: when you use `linode-cli configure` you are asked if you want to use a default SSH key for creating linode's.

```bash
ssh root@$GITLAB_SERVER_IP

ssh-copy-id root@$GITLAB_SERVER_IP

# with keys
ssh -i ~/.ssh/id_ed25519 root@$GITLAB_SERVER_IP

# if added keys at creation
ssh root@$GITLAB_SERVER_IP

sudo hostnamectl set-hostname controlplane

ssh root@$WORKER_IP
sudo hostnamectl set-hostname worker


```

---

## Add a host alias
edit your `~/.ssh/config`
```bash
Host controlplane
    HostName 172.233.109.43
    User root
    IdentityFile ~/.ssh/id_ed25519

```

now you can just do:
```bash
ssh gitlab

sudo hostnamectl set-hostname gitlab-server
```

---

## manually add IP

```bash
# Copy the public key manually
scp ~/.ssh/id_ed25519.pub root@172.233.109.43:/root/tempkey.pub

# SSH in and move the key
ssh root@172.233.109.43

mkdir -p ~/.ssh
cat ~/tempkey.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
rm ~/tempkey.pub

# log out and back in
ssh root@172.233.109.43


# set prompt
echo "PS1='\[\e[0;32m\]GITLAB-SERVER \[\e[0m\]\w \$ '" >> ~/.bashrc
source ~/.bashrc


```