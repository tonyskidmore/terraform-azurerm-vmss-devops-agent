ado_pool_name = "vmss-bootstrap-pool"

build_definitions = {
  "pipeline1" = {
    "name" : "000-bootstrap-test",
    "path" : "\\bootstrap",
    "repo_ref" : "repo2",
    "yml_path" : "demo-vmss/000-bootstrap-test.yml"
  }
  "pipeline2" = {
    "name" : "000-bootstrap-update",
    "path" : "\\bootstrap",
    "repo_ref" : "repo2",
    "yml_path" : "demo-vmss/000-bootstrap-update.yml"
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
