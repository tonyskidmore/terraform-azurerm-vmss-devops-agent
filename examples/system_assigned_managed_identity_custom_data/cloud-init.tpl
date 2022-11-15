#cloud-config

bootcmd:
  - mkdir -p /etc/systemd/system/walinuxagent.service.d
  - echo "[Unit]\nAfter=cloud-final.service" > /etc/systemd/system/walinuxagent.service.d/override.conf
  - sed "s/After=multi-user.target//g" /lib/systemd/system/cloud-final.service > /etc/systemd/system/cloud-final.service
  - systemctl daemon-reload

package_update: true

packages:
  - jq

write_files:
- owner: root:root
  path: /opt/upload_file.sh
  permissions: '0755'
  content: |
    #!/bin/bash

    response=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2019-08-01&resource=https%3A%2F%2Fstorage.azure.com%2F' -H Metadata:true -s)
    access_token=$(echo $response | jq -r .access_token)
    echo ${STORAGE_ACCOUNT} > ./vmss.txt
    curl -i -X PUT -T ./vmss.txt -H "Authorization: Bearer $access_token" -H "x-ms-blob-type: BlockBlob" -H "x-ms-version: 2020-10-02" https://${STORAGE_ACCOUNT}.blob.core.windows.net${FILE_PATH}

runcmd:
  - [ /opt/upload_file.sh ]
