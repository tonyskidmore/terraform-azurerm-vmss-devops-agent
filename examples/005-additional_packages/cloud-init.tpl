#cloud-config

---

bootcmd:
  - mkdir -p /etc/systemd/system/walinuxagent.service.d
  - echo "[Unit]\nAfter=cloud-final.service" > /etc/systemd/system/walinuxagent.service.d/override.conf
  - sed "s/After=multi-user.target//g" /lib/systemd/system/cloud-final.service > /etc/systemd/system/cloud-final.service
  - systemctl daemon-reload

package_update: true
package_reboot_if_required: true

apt:
  preserve_sources_list: true
  sources:
    docker.list:
      source: "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    docker.list:
      source: "deb https://download.docker.com/linux/ubuntu focal stable"
      key:  |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        mQINBFit2ioBEADhWpZ8/wvZ6hUTiXOwQHXMAlaFHcPH9hAtr4F1y2+OYdbtMuth
        lqqwp028AqyY+PRfVMtSYMbjuQuu5byyKR01BbqYhuS3jtqQmljZ/bJvXqnmiVXh
        38UuLa+z077PxyxQhu5BbqntTPQMfiyqEiU+BKbq2WmANUKQf+1AmZY/IruOXbnq
        L4C1+gJ8vfmXQt99npCaxEjaNRVYfOS8QcixNzHUYnb6emjlANyEVlZzeqo7XKl7
        UrwV5inawTSzWNvtjEjj4nJL8NsLwscpLPQUhTQ+7BbQXAwAmeHCUTQIvvWXqw0N
        cmhh4HgeQscQHYgOJjjDVfoY5MucvglbIgCqfzAHW9jxmRL4qbMZj+b1XoePEtht
        ku4bIQN1X5P07fNWzlgaRL5Z4POXDDZTlIQ/El58j9kp4bnWRCJW0lya+f8ocodo
        vZZ+Doi+fy4D5ZGrL4XEcIQP/Lv5uFyf+kQtl/94VFYVJOleAv8W92KdgDkhTcTD
        G7c0tIkVEKNUq48b3aQ64NOZQW7fVjfoKwEZdOqPE72Pa45jrZzvUFxSpdiNk2tZ
        XYukHjlxxEgBdC/J3cMMNRE1F4NCA3ApfV1Y7/hTeOnmDuDYwr9/obA8t016Yljj
        q5rdkywPf4JF8mXUW5eCN1vAFHxeg9ZWemhBtQmGxXnw9M+z6hWwc6ahmwARAQAB
        tCtEb2NrZXIgUmVsZWFzZSAoQ0UgZGViKSA8ZG9ja2VyQGRvY2tlci5jb20+iQI3
        BBMBCgAhBQJYrefAAhsvBQsJCAcDBRUKCQgLBRYCAwEAAh4BAheAAAoJEI2BgDwO
        v82IsskP/iQZo68flDQmNvn8X5XTd6RRaUH33kXYXquT6NkHJciS7E2gTJmqvMqd
        tI4mNYHCSEYxI5qrcYV5YqX9P6+Ko+vozo4nseUQLPH/ATQ4qL0Zok+1jkag3Lgk
        jonyUf9bwtWxFp05HC3GMHPhhcUSexCxQLQvnFWXD2sWLKivHp2fT8QbRGeZ+d3m
        6fqcd5Fu7pxsqm0EUDK5NL+nPIgYhN+auTrhgzhK1CShfGccM/wfRlei9Utz6p9P
        XRKIlWnXtT4qNGZNTN0tR+NLG/6Bqd8OYBaFAUcue/w1VW6JQ2VGYZHnZu9S8LMc
        FYBa5Ig9PxwGQOgq6RDKDbV+PqTQT5EFMeR1mrjckk4DQJjbxeMZbiNMG5kGECA8
        g383P3elhn03WGbEEa4MNc3Z4+7c236QI3xWJfNPdUbXRaAwhy/6rTSFbzwKB0Jm
        ebwzQfwjQY6f55MiI/RqDCyuPj3r3jyVRkK86pQKBAJwFHyqj9KaKXMZjfVnowLh
        9svIGfNbGHpucATqREvUHuQbNnqkCx8VVhtYkhDb9fEP2xBu5VvHbR+3nfVhMut5
        G34Ct5RS7Jt6LIfFdtcn8CaSas/l1HbiGeRgc70X/9aYx/V/CEJv0lIe8gP6uDoW
        FPIZ7d6vH+Vro6xuWEGiuMaiznap2KhZmpkgfupyFmplh0s6knymuQINBFit2ioB
        EADneL9S9m4vhU3blaRjVUUyJ7b/qTjcSylvCH5XUE6R2k+ckEZjfAMZPLpO+/tF
        M2JIJMD4SifKuS3xck9KtZGCufGmcwiLQRzeHF7vJUKrLD5RTkNi23ydvWZgPjtx
        Q+DTT1Zcn7BrQFY6FgnRoUVIxwtdw1bMY/89rsFgS5wwuMESd3Q2RYgb7EOFOpnu
        w6da7WakWf4IhnF5nsNYGDVaIHzpiqCl+uTbf1epCjrOlIzkZ3Z3Yk5CM/TiFzPk
        z2lLz89cpD8U+NtCsfagWWfjd2U3jDapgH+7nQnCEWpROtzaKHG6lA3pXdix5zG8
        eRc6/0IbUSWvfjKxLLPfNeCS2pCL3IeEI5nothEEYdQH6szpLog79xB9dVnJyKJb
        VfxXnseoYqVrRz2VVbUI5Blwm6B40E3eGVfUQWiux54DspyVMMk41Mx7QJ3iynIa
        1N4ZAqVMAEruyXTRTxc9XW0tYhDMA/1GYvz0EmFpm8LzTHA6sFVtPm/ZlNCX6P1X
        zJwrv7DSQKD6GGlBQUX+OeEJ8tTkkf8QTJSPUdh8P8YxDFS5EOGAvhhpMBYD42kQ
        pqXjEC+XcycTvGI7impgv9PDY1RCC1zkBjKPa120rNhv/hkVk/YhuGoajoHyy4h7
        ZQopdcMtpN2dgmhEegny9JCSwxfQmQ0zK0g7m6SHiKMwjwARAQABiQQ+BBgBCAAJ
        BQJYrdoqAhsCAikJEI2BgDwOv82IwV0gBBkBCAAGBQJYrdoqAAoJEH6gqcPyc/zY
        1WAP/2wJ+R0gE6qsce3rjaIz58PJmc8goKrir5hnElWhPgbq7cYIsW5qiFyLhkdp
        YcMmhD9mRiPpQn6Ya2w3e3B8zfIVKipbMBnke/ytZ9M7qHmDCcjoiSmwEXN3wKYI
        mD9VHONsl/CG1rU9Isw1jtB5g1YxuBA7M/m36XN6x2u+NtNMDB9P56yc4gfsZVES
        KA9v+yY2/l45L8d/WUkUi0YXomn6hyBGI7JrBLq0CX37GEYP6O9rrKipfz73XfO7
        JIGzOKZlljb/D9RX/g7nRbCn+3EtH7xnk+TK/50euEKw8SMUg147sJTcpQmv6UzZ
        cM4JgL0HbHVCojV4C/plELwMddALOFeYQzTif6sMRPf+3DSj8frbInjChC3yOLy0
        6br92KFom17EIj2CAcoeq7UPhi2oouYBwPxh5ytdehJkoo+sN7RIWua6P2WSmon5
        U888cSylXC0+ADFdgLX9K2zrDVYUG1vo8CX0vzxFBaHwN6Px26fhIT1/hYUHQR1z
        VfNDcyQmXqkOnZvvoMfz/Q0s9BhFJ/zU6AgQbIZE/hm1spsfgvtsD1frZfygXJ9f
        irP+MSAI80xHSf91qSRZOj4Pl3ZJNbq4yYxv0b1pkMqeGdjdCYhLU+LZ4wbQmpCk
        SVe2prlLureigXtmZfkqevRz7FrIZiu9ky8wnCAPwC7/zmS18rgP/17bOtL4/iIz
        QhxAAoAMWVrGyJivSkjhSGx1uCojsWfsTAm11P7jsruIL61ZzMUVE2aM3Pmj5G+W
        9AcZ58Em+1WsVnAXdUR//bMmhyr8wL/G1YO1V3JEJTRdxsSxdYa4deGBBY/Adpsw
        24jxhOJR+lsJpqIUeb999+R8euDhRHG9eFO7DRu6weatUJ6suupoDTRWtr/4yGqe
        dKxV3qQhNLSnaAzqW/1nA3iUB4k7kCaKZxhdhDbClf9P37qaRW467BLCVO/coL3y
        Vm50dwdrNtKpMBh3ZpbB1uJvgi9mXtyBOMJ3v8RZeDzFiG8HdCtg9RvIt/AIFoHR
        H3S+U79NT6i0KPzLImDfs8T7RlpyuMc4Ufs8ggyg9v3Ae6cN3eQyxcK3w0cbBwsh
        /nQNfsA6uu+9H7NhbehBMhYnpNZyrHzCmzyXkauwRAqoCbGCNykTRwsur9gS41TQ
        M8ssD1jFheOJf3hODnkKU+HKjvMROl1DK7zdmLdNzA1cvtZH/nCC9KPj1z8QC47S
        xx+dTZSx4ONAhwbS/LN3PoKtn8LPjY9NP9uDWI+TWYquS2U+KHDrBDlsgozDbs/O
        jCxcpDzNmXpWQHEtHU7649OXHP7UeNST1mCUCH5qdank0V1iejF6/CfTFU4MfcrG
        YT90qFF93M3v01BbxP+EIY2/9tiIPbrd
        =0YYh
        -----END PGP PUBLIC KEY BLOCK-----

    apt.releases.hashicorp.com.list:
      source: "deb [arch=amd64] https://apt.releases.hashicorp.com focal main"
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        mQINBF60TuYBEADLS1MP7XrMlRkn1Y54cb2UclUMH8HkIRfBrhk5Leo9kNZc/2QD
        LmdQbi3UbZkz0uVkHqbFDgV5lAnukCnxgr9BqnL0GJpO78le7gCCbM5bR4rTJ6Ar
        OOtIKf25smGTIpbSwNdj8BOLqiExGFj/9L5X9S5kfq3vtuYt+lmxKkIrEPjSYnFR
        TQ2mTL8RM932GJod/5VJ2+6YvrCjtPu5/rW02H1U2ZHiTtX6ZGnIvv/sprKyFRqT
        x4Ib+o9XwXof/LuxTMpVwIHSzCYanH5hPc7yRGKzIntBS+dDom+h9smx7FTgpHwt
        QRFGLtVoHXqON6nXTLFDkEzxr+fXq/bgB1Kc1TuzvoK601ztQGhhDaEPloKqNWM8
        Ho7JU1RpnoWr5jOFTYiPM9uyCtFNsJmD9mt4K8sQQN7T2inR5Us0o510FqePRFeX
        wOJUMi1CbeYqVHfKQ5cWYujcK8pv3l1a6dSBmFfcdxtwIoA16JzCrgsCeumTDvKu
        hOiTctb28srL/9WwlijUzZy6R2BGBbhP937f2NbMS/rpby7M1WizKeo2tkKVyK+w
        SUWSw6EtFJi7kRSkH7rvy/ysU9I2ma88TyvyOgIz1NRRXYsW7+brgwXnuJraOLaB
        5aiuhlngKpTPvP9CFib7AW2QOXustMZ7pOUREmxgS4kqxo74CuFws163TwARAQAB
        tFFIYXNoaUNvcnAgU2VjdXJpdHkgKEhhc2hpQ29ycCBQYWNrYWdlIFNpZ25pbmcp
        IDxzZWN1cml0eStwYWNrYWdpbmdAaGFzaGljb3JwLmNvbT6JAk4EEwEIADgWIQTo
        oDLglNjrTqGJ0nDaQYyIoyGfewUCXrRO5gIbAwULCQgHAgYVCgkICwIEFgIDAQIe
        AQIXgAAKCRDaQYyIoyGfe6/WD/9dTM/1OSgbvSPpPJOOcn5L1nOKRBJpztr4V0ky
        GoCDakIQ/sykbcuHXP79FGLzrM8zQOsbvVp/Z2lsWBnxkT8KWM+8LZxYToRGdZhr
        huFPHV9df0vAsZGisu4ejHDneHOTO3KqVotkky34jUSjBL7Q8uwXHY9r+5hb452N
        vafN1w0Y1QVhb6JjjwWHR8Rf9qkSIEi6m9o8a1M54yQC2y/Zrs6+4F3zZ4uYfTvz
        MyFfj0P5VmAoaowLSRdb2/JTObu0+zpKN+PjZA8BcnOf/pvqmEz83FIfo6zJLScx
        TVaAwj5Iz/jS04x7EvBuIP3vpgv1R6r+t0qU/7hpu7Oc0dsxhL+C8BpVY26/2hvX
        ozN5eG0ysSwexqwls+bnRgd6KdoHlWFNfbW8RCPKyb/s+tmFqGAY/QmxMkukgnXQ
        WvBoa0Gdv2AFVLYup9tEO1zF4zBPh5oQwAXDNudLTHJ4KmyEwWsOQJUjNB4y4a7j
        iGgK77T4KKXpo7pVDP8Ur+tmNH/d+/YFjxrfJvWt4ypE5dZmFO/FrUMvIGglOLDt
        A+SiQe73IpEebB8PiqNlqJ2NU7artuRxYQVColt+/1puIHwV+h0SnMoUEvYqAtxP
        J/N3JaiytWlesPPFWvhU/JGUAld5coEU2gbYtlenV/YmdjilIBu50sMSPGF5/6gv
        BAA/DbkCDQRetE7mARAA0OH1pn0vdEfSm1kdqIDP3BXBD0BRHNNgGpyXXRRJFaip
        bmpu7jSv3FsvN/NmG3BcLXXLFvwY/eIOr6fxRye+a5FSQEtvBnI1GHNmD5GAVT/H
        KiwrT5e3ReR/FQS7hCXWU4OA2bKmSEdkJ952NhyYeyAKbkOBgbnlEhtWOAdMI7ws
        peHAlHDqfGVOKXDh+FddCUQj/yZ2rblSzFdcC9gtcJSyHWgOQdVAEesEZ16hcZoj
        +6O+6BXOQWOo7EPD7lA9a1qesBkSRcxQn48IVVZ2Qx2P2FtCfF+SFX+HQdqJGl15
        qxE5CXTuJCMmCVnWhvcLW405uF/HmMFXdqGobEDiQsFFQrfpPVOi4T90VkW8P81s
        uPoAlWht1CppNnmhWlvPQsPK/oSMBBOvOEH1EnWJate8yIkveNbqzrE7Xt3sjF6k
        yqXaF+qW8OcDvSH/fgvVd21G10Cm77Z2WaKWvfi221oWj+WrgT8cCYv0AVmaLRMe
        dajuYlPRQ8KaZaESza2eXggOMP5LQs/mQgfHfwSRekSbKg/L6ctp+xrZ0DPj4iIl
        8+H4DxTILopAFWXA1a+uMVp8mV77gA9PyV3nIkrwgaZQ8MdhoKwvN/+SbvhpdzyF
        UekzMP/HOaC6JgAomluwnFCdMDFa3FMCF3QUcIyY556QdoFD7g6033xqV6vL+d8A
        EQEAAYkCNgQYAQgAIBYhBOigMuCU2OtOoYnScNpBjIijIZ97BQJetE7mAhsMAAoJ
        ENpBjIijIZ97lecP+wTgSqhCz3TlUshR8lVrzECueIg3jh3+lY56am9X4MoZ2DAW
        IXKjWKVWO55WPYD15A7+TbDyb4zh55m81LxSpV0CSRN4aPuixosWP4d0l+363D2F
        oudz+QyvoK5J2sKFPMfhdTgGsEYVO/Zbhus5oNi0kjUTD9U7jHWPS3ilvk/g2F+k
        T68lL9+oooleeT+kcBvbKt487JUOwMrkmHqNZdh8qmvMASAuqBcEcqjz96kVEMJY
        bhn2skexKfIncoo/btixzJUbnplpDfibFxUHhvWWdwIv4kl3YnrCKKGSDoJcG1mV
        sQegK4jWVGrqY8MnCI48iotP18ZxyqOycsZvs2jNmFlKwD9s1mrlr97HZ1MYbLWr
        Hq06owH0AzVRM7tzMK7EuHkFLcoa8qh3oijn8O0B7xNOKpTZ2DjajQ/1w8nqmMi5
        Z3Wie6ivKng/7p6c6HDrKjoQYc0/fuh1YnL60JG2Arn1OwdBsLDlzPL+Ro5iNwoJ
        hZ+stxoZT48iAIWonBsLU11Y+MSwWdN1Eh411HTTunrEs6SafMEhnPi7vvUIZhny
        Es0qOM/IUR1I0VtsurSn8aA6Y2Bp73+HuqFLx13/tPKBIUo6D7n/ywUlDCo7wtCw
        aSgXPw6uF+0CyLOQ0haf2j6w1OB8ayEGSkTPER5rImCJf3MGw8IECGrErAd+
        =emKC
        -----END PGP PUBLIC KEY BLOCK-----

    packages.microsoft.com.azurecli.list:
      source: "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ focal main"
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        Version: GnuPG v1.4.7 (GNU/Linux)
        mQENBFYxWIwBCADAKoZhZlJxGNGWzqV+1OG1xiQeoowKhssGAKvd+buXCGISZJwT
        LXZqIcIiLP7pqdcZWtE9bSc7yBY2MalDp9Liu0KekywQ6VVX1T72NPf5Ev6x6DLV
        7aVWsCzUAF+eb7DC9fPuFLEdxmOEYoPjzrQ7cCnSV4JQxAqhU4T6OjbvRazGl3ag
        OeizPXmRljMtUUttHQZnRhtlzkmwIrUivbfFPD+fEoHJ1+uIdfOzZX8/oKHKLe2j
        H632kvsNzJFlROVvGLYAk2WRcLu+RjjggixhwiB+Mu/A8Tf4V6b+YppS44q8EvVr
        M+QvY7LNSOffSO6Slsy9oisGTdfE39nC7pVRABEBAAG0N01pY3Jvc29mdCAoUmVs
        ZWFzZSBzaWduaW5nKSA8Z3Bnc2VjdXJpdHlAbWljcm9zb2Z0LmNvbT6JATUEEwEC
        AB8FAlYxWIwCGwMGCwkIBwMCBBUCCAMDFgIBAh4BAheAAAoJEOs+lK2+EinPGpsH
        /32vKy29Hg51H9dfFJMx0/a/F+5vKeCeVqimvyTM04C+XENNuSbYZ3eRPHGHFLqe
        MNGxsfb7C7ZxEeW7J/vSzRgHxm7ZvESisUYRFq2sgkJ+HFERNrqfci45bdhmrUsy
        7SWw9ybxdFOkuQoyKD3tBmiGfONQMlBaOMWdAsic965rvJsd5zYaZZFI1UwTkFXV
        KJt3bp3Ngn1vEYXwijGTa+FXz6GLHueJwF0I7ug34DgUkAFvAs8Hacr2DRYxL5RJ
        XdNgj4Jd2/g6T9InmWT0hASljur+dJnzNiNCkbn9KbX7J/qK1IbR8y560yRmFsU+
        NdCFTW7wY0Fb1fWJ+/KTsC4=
        =J6gs
        -----END PGP PUBLIC KEY BLOCK-----

    packages.microsoft.com.main.list:
      source: "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main"
      key: |
        -----BEGIN PGP PUBLIC KEY BLOCK-----
        Version: GnuPG v1.4.7 (GNU/Linux)
        mQENBFYxWIwBCADAKoZhZlJxGNGWzqV+1OG1xiQeoowKhssGAKvd+buXCGISZJwT
        LXZqIcIiLP7pqdcZWtE9bSc7yBY2MalDp9Liu0KekywQ6VVX1T72NPf5Ev6x6DLV
        7aVWsCzUAF+eb7DC9fPuFLEdxmOEYoPjzrQ7cCnSV4JQxAqhU4T6OjbvRazGl3ag
        OeizPXmRljMtUUttHQZnRhtlzkmwIrUivbfFPD+fEoHJ1+uIdfOzZX8/oKHKLe2j
        H632kvsNzJFlROVvGLYAk2WRcLu+RjjggixhwiB+Mu/A8Tf4V6b+YppS44q8EvVr
        M+QvY7LNSOffSO6Slsy9oisGTdfE39nC7pVRABEBAAG0N01pY3Jvc29mdCAoUmVs
        ZWFzZSBzaWduaW5nKSA8Z3Bnc2VjdXJpdHlAbWljcm9zb2Z0LmNvbT6JATUEEwEC
        AB8FAlYxWIwCGwMGCwkIBwMCBBUCCAMDFgIBAh4BAheAAAoJEOs+lK2+EinPGpsH
        /32vKy29Hg51H9dfFJMx0/a/F+5vKeCeVqimvyTM04C+XENNuSbYZ3eRPHGHFLqe
        MNGxsfb7C7ZxEeW7J/vSzRgHxm7ZvESisUYRFq2sgkJ+HFERNrqfci45bdhmrUsy
        7SWw9ybxdFOkuQoyKD3tBmiGfONQMlBaOMWdAsic965rvJsd5zYaZZFI1UwTkFXV
        KJt3bp3Ngn1vEYXwijGTa+FXz6GLHueJwF0I7ug34DgUkAFvAs8Hacr2DRYxL5RJ
        XdNgj4Jd2/g6T9InmWT0hASljur+dJnzNiNCkbn9KbX7J/qK1IbR8y560yRmFsU+
        NdCFTW7wY0Fb1fWJ+/KTsC4=
        =J6gs
        -----END PGP PUBLIC KEY BLOCK-----

packages:
  - apt-transport-https
  - azure-cli
  - ca-certificates
  - curl
  - docker-ce
  - docker-ce-cli
  - jq
  - packer
  # specific version can be installed if needed
  # - [packer,1.8.5]
  - powershell
  - python3
  - python3-pip
  - python3-venv
  - software-properties-common
  - terraform
  # - [terraform,1.3.9]
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
