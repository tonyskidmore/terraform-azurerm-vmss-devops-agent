#cloud-config

bootcmd:
  - mkdir -p /etc/systemd/system/walinuxagent.service.d
  - echo "[Unit]\nAfter=cloud-final.service" > /etc/systemd/system/walinuxagent.service.d/override.conf
  - sed "s/After=multi-user.target//g" /lib/systemd/system/cloud-final.service > /etc/systemd/system/cloud-final.service
  - systemctl daemon-reload

package_update: true

packages:
  - update-ca-certificates

write_files:
- owner: root:root
  path: /usr/local/share/ca-certificates/skidmore.crt
  permissions: '0644'
  content: |
    -----BEGIN CERTIFICATE-----
    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
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    MIIFhjCCA26gAwIBAgIBADANBgkqhkiG9w0BAQ0FADBUMQswCQYDVQQGEwJVSzEX
    MBUGA1UECAwOV29yY2VzdGVyc2hpcmUxETAPBgNVBAoMCFNraWRtb3JlMRkwFwYD
    VQQDDBBTa2lkbW9yZSBSb290IENBMB4XDTIyMDkyMjIxMzc1NFoXDTMyMDkxOTIx
    Mzc1NFowVDELMAkGA1UEBhMCVUsxFzAVBgNVBAgMDldvcmNlc3RlcnNoaXJlMREw
    DwYDVQQKDAhTa2lkbW9yZTEZMBcGA1UEAwwQU2tpZG1vcmUgUm9vdCBDQTCCAiIw
    DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAPBG6srIkEtL9HPv0XmAJWFGxlwy
    qDBS/DMfNNhBOiM29ZjIgnnCQa5DOklvpq6ZYalMNEMkOZ0SdU07gEL3U+EVv23K
    vvew8efjD+h2AaXuu1Z0WfuwjwdPIwdE/bvs6IhTp+gXfSOU3oK2IoBhPekcjpZU
    eqssWNaR9qp7ARBcjAMJ361FN0ik5yPi30gAvnoAhzcqzXQsdwUN9LsMeDV918VU
    5n/O30VM5qAytTspKm7hK8z+krrRlyzGlsu3YlEVpNDAiteSZqtGNy4Uba58hkAp
    gwE9bPTZsEtk+1gAOznJRfI8uzmMyUf49DSL+F+2eL28qL/0ezH3zpriS67POEPB
    su7Bn8W8JLWsXLv4txK1q/fRHvM2ffnfNZ/OcKE9Kv+HiWV43A4FB8ycMooF6vZE
    20pt7U1Vzx5fWCCm9tqDIhKFt7TT20iTLwEoq0vrZ2xCwMC/RLbq3BBGfgSgo2wj
    d2VjEVfLdxrAjom+Y5qZaytmc3EwxNb3hQvPxQwJvnlmVP461RKNXUEd19NSfY+Y
    6fUdoYOHPD7jhM5Jqkuvm6fjOpeMDN/0+nRtSwMrhYZ4Bb36eQ+wXFJ/d9uOHaWk
    h5JAFmJcbJRF7PHaVrWMf10xxL1IPDsJS4bABppsP3IEKtByV/RaqFCTQ3ZUAAq4
    xiWA4Z8UVZdgUDIHAgMBAAGjYzBhMB0GA1UdDgQWBBQoIbmSgF32YSa+lKXq+1JB
    jOjZ8zAfBgNVHSMEGDAWgBQoIbmSgF32YSa+lKXq+1JBjOjZ8zAPBgNVHRMBAf8E
    BTADAQH/MA4GA1UdDwEB/wQEAwIBhjANBgkqhkiG9w0BAQ0FAAOCAgEA6qdOtMBH
    WOI9vQrxlN+ZH9btQ5MobzdeETOUuDGqp5cls7fctFeK4SO7JAk6oNMIbb/LuwrG
    wAAC3Ibl7aeo0U03yXjYlthBCx/IH+G0SHNs+NqJQ+pU9ZGbGOeuvem5Q0KYgc7b
    PdzHNCqzUG6L7zvH4VR/1gIU3fskIGl/gRwJMNnk3cZlrBg2gnpbUrRAvoDpG1zz
    ypDuvD3n+LN/h5m+GZ40XlXahqoEDOeg1DNHVi25nr4b2+tzD5mGgmP176GBuYSZ
    MnJ2mOhYQC8y4flPEQQNbinKNcqOPQmpEaYOifk+g3kpQ6uQIN+pfRE6OQ2wPRBy
    pbBhVc9bExW7Ca5so0mzGbsgQ7vy4nvWfwWf8mhPv0DpaxxmwEiU+0Tu6PDA0OD1
    h7ba0wqmwg7CscRt+hUtwu8JR8HxEXwcumk3aMEHf0ZNxh1vdYAyUtCYedf8wc66
    k5RU/N3VzIXTW1jrOieEViOlZeUZTHufjHue9WALO0qokfoR8RSijroo5bnH1yCC
    EvjQMbsCRa87BS9tnSlDGcQtXH8gpyPHnVoJaGuhwBlg8W++jTyT+7GNBllULROu
    ML5p+vLvzfh6LhUnjXqU1o9YlTdIT2YQ/s72uR0UiGpONiRQSRNOPfiHh5jtWHOb
    VKEQZ/SiZ5ASem1x1FtNUtjsct8iTLnXRSs=
    -----END CERTIFICATE-----

runcmd:
  - [ /usr/sbin/update-ca-certificates ]
