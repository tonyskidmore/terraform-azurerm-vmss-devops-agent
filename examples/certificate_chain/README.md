# Example - Create Azure DevOps Scale Set with custom custom_data adding custom certificate chain

In this example we are creating a pool named `vmss-mkt-image-005` based on an Azure MarketPlace Ubuntu 20.04 image. # TODO: 22.04?

sudo cp ca/chain.SKIDMORE.pem /usr/local/share/ca-certificates/skidmore.crt
sudo /usr/sbin/update-ca-certificates

awk -v cmd='openssl x509 -noout -subject' '/BEGIN/{close(cmd)};{print | cmd}' < /etc/ssl/certs/ca-certificates.crt

The example doesn't use many variables, just to keep the inputs explicit and easy to show in the `main.tf`, normally these would be passed using variables and a method to [assign values](https://www.terraform.io/language/values/variables#assigning-values-to-root-module-variables) to those variables.
