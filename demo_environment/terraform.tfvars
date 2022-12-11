ado_pool_name = "vmss-bootstrap-pool"

build_definitions = {
  "pipeline1" = {
    "name" : "000-bootstrap-test",
    "path" : "\\000-bootstrap",
    "repo_ref" : "repo2",
    "yml_path" : "demo-vmss/000-bootstrap-test.yml"
  }
  "pipeline2" = {
    "name" : "000-bootstrap-update",
    "path" : "\\000-bootstrap",
    "repo_ref" : "repo2",
    "yml_path" : "demo-vmss/000-bootstrap-update.yml"
  }
  "pipeline3" = {
    "name" : "000-bootstrap-terraform",
    "path" : "\\000-bootstrap",
    "repo_ref" : "repo2",
    "yml_path" : "demo-vmss/000-bootstrap-terraform.yml"
  }
  "pipeline4" = {
    "name" : "001-admin-password",
    "path" : "\\001-admin-password",
    "repo_ref" : "repo2",
    "yml_path" : "demo-vmss/001-admin-password-terraform.yml"
  }
  "pipeline5" = {
    "name" : "001-admin-password-test",
    "path" : "\\001-admin-password",
    "repo_ref" : "repo2",
    "yml_path" : "demo-vmss/001-admin-password-test.yml"
  }
  "pipeline6" = {
    "name" : "002-certificate-chain",
    "path" : "\\002-certificate-chain",
    "repo_ref" : "repo2",
    "yml_path" : "demo-vmss/002-certificate-chain-terraform.yml"
  }
  "pipeline7" = {
    "name" : "002-certificate-chain-test",
    "path" : "\\002-certificate-chain",
    "repo_ref" : "repo2",
    "yml_path" : "002-certificate-chain-test.yml"
  }
}

git_repos = {
  "repo1" = {
    name = "module",
    initialization = {
      init_type   = "Import",
      source_type = "Git",
      source_url  = "https://github.com/tonyskidmore/terraform-azurerm-vmss-devops-agent.git"
    }
  }
  "repo2" = {
    name = "pipelines",
    # default_branch = "refs/heads/main",
    initialization = {
      init_type   = "Import",
      source_type = "Git",
      source_url  = "https://github.com/tonyskidmore/azure-pipelines-yaml.git"
    }
  }
}

location            = "uksouth"
nsg_name            = "nsg-demo-azure-devops-vmss"
resource_group_name = "rg-demo-azure-devops-vmss"
vmss_name           = "vmss-demo-bootstrap"
# TODO: change this to key vault + ssh key?
vmss_admin_password          = "Sup3rS3cr3tP@55w0rd!"
vmss_vnet_name               = "vnet-demo-azure-devops-vmss"
vmss_vnet_address_space      = ["192.168.0.0/16"]
vmss_subnet_name             = "snet-demo-azure-devops-vmss"
vmss_subnet_address_prefixes = ["192.168.0.0/24"]
