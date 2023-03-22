#cloud-config

bootcmd:
  - mkdir -p /etc/systemd/system/walinuxagent.service.d
  - echo "[Unit]\nAfter=cloud-final.service" > /etc/systemd/system/walinuxagent.service.d/override.conf
  - sed "s/After=multi-user.target//g" /lib/systemd/system/cloud-final.service > /etc/systemd/system/cloud-final.service
  - systemctl daemon-reload

apt:
  sources:
    # docker.list:
    #   source: deb [arch=amd64] https://download.docker.com/linux/ubuntu $RELEASE stable
    #   keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

    packages.microsoft.com.azurecli.list:
      source: "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ focal main"
      keyid: BC528686B50D79E339D3721CEB3E94ADBE1229CF

package_update: true

packages:
  - apt-transport-https
  - azure-cli
  - curl
  - wget
  - unzip
  - sudo
  - gpg
  - ca-certificates
  - jq
  - git
  # - docker-ce
  # - docker-ce-cli

groups:
  - docker

# Add default auto created user to docker group
system_info:
  default_user:
    groups: [docker]

# runcmd:
#   - curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
