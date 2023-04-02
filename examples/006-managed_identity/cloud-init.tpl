#cloud-config

---

bootcmd:
  - mkdir -p /etc/systemd/system/walinuxagent.service.d
  - echo "[Unit]\nAfter=cloud-final.service" > /etc/systemd/system/walinuxagent.service.d/override.conf
  - sed "s/After=multi-user.target//g" /lib/systemd/system/cloud-final.service > /etc/systemd/system/cloud-final.service
  - systemctl daemon-reload

package_update: true

apt:
  # preserve_sources_list: true
  sources:
    docker.list:
      source: "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

    apt.releases.hashicorp.com.list:
      source: "deb [arch=amd64] https://apt.releases.hashicorp.com focal main"
      keyid: 798AEC654E5C15428C8E42EEAA16FCBCA621E701

    packages.microsoft.com.azurecli.list:
      source: "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ focal main"
      keyid: BC528686B50D79E339D3721CEB3E94ADBE1229CF


packages:
  - apt-transport-https
  - azure-cli
  - ca-certificates
  - curl
  - docker-ce
  - docker-ce-cli
  - docker-compose
  - git
  - gpg
  - jq
  - python3
  - python3-pip
  - python3-venv
  - software-properties-common
  - terraform
  - wget

# timezone: Europe/London
# locale: "en_US.UTF-8"

groups:
  - docker

# Add default auto created user to docker group
system_info:
  default_user:
    groups: [docker]

# example method of using scripted installs
write_files:
  - content: |
      #!/bin/bash
      wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /tmp/yq
      mv /tmp/yq /usr/bin
      chmod +x /usr/bin/yq
    path: /tmp/get-yq.sh
    permissions: 0777

runcmd:
  - /tmp/get-yq.sh
