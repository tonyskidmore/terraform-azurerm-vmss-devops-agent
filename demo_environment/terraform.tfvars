ado_pool_name = "vmss-bootstrap-pool"

build_definitions = {
  # TODO:
  # pending: https://github.com/microsoft/terraform-provider-azuredevops/issues/668
  # "pipeline1" = {
  #   "name" : "000-bootstrap-test",
  #   "path" : "\\000-bootstrap",
  #   "repo_ref" : "repo1",
  #   "yml_path" : "demo_environment/pipelines/000-bootstrap-test.yml"
  # }
  # "pipeline2" = {
  #   "name" : "000-bootstrap-update",
  #   "path" : "\\000-bootstrap",
  #   "repo_ref" : "repo1",
  #   "yml_path" : "demo_environment/pipelines/000-bootstrap-update.yml"
  # }
  # "pipeline3" = {
  #   "name" : "000-bootstrap-terraform",
  #   "path" : "\\000-bootstrap",
  #   "repo_ref" : "repo1",
  #   "yml_path" : "demo_environment/pipelines/000-bootstrap-terraform.yml"
  # }
  "pipeline4" = {
    name     = "001-admin-password-terraform",
    path     = "\\001-admin-password",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/001-admin-password-terraform.yml"
  }
  "pipeline5" = {
    name     = "001-admin-password-test",
    path     = "\\001-admin-password",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/001-admin-password-test.yml"
  }
  "pipeline6" = {
    name     = "002-certificate-chain-terraform",
    path     = "\\002-certificate-chain",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/002-certificate-chain-terraform.yml"
  }
  "pipeline7" = {
    name     = "002-certificate-chain-test",
    path     = "\\002-certificate-chain",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/002-certificate-chain-test.yml"
  }
  "pipeline8" = {
    name     = "003-multi-zone-scale-up-terraform",
    path     = "\\003-multi-zone",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/003-multi-zone-scale-up-terraform.yml"
  }
  "pipeline9" = {
    name     = "003-multi-zone-scale-down-terraform",
    path     = "\\003-multi-zone",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/003-multi-zone-scale-down-terraform.yml"
  }
  "pipeline10" = {
    name     = "003-multi-zone-test",
    path     = "\\003-multi-zone",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/003-multi-zone-test.yml"
  },
  "pipeline11" = {
    name     = "004-docker-data-disk-terraform",
    path     = "\\004-docker-data-disk",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/004-docker-data-disk-terraform.yml"
  }
  "pipeline12" = {
    name     = "004-docker-data-disk-host-test",
    path     = "\\004-docker-data-disk",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/004-docker-data-disk-host-test.yml"
  }
  "pipeline13" = {
    name     = "004-docker-data-disk-test",
    path     = "\\004-docker-data-disk",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/004-docker-data-disk-test.yml"
  }
  "pipeline14" = {
    name     = "005-additional-packages-terraform",
    path     = "\\005-additional-packages",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/005-additional-packages-terraform.yml"
  }
  "pipeline15" = {
    name     = "005-additional-packages-test",
    path     = "\\005-additional-packages",
    repo_ref = "repo1",
    yml_path = "demo_environment/pipelines/005-additional-packages-test.yml"
  }
}

git_repos = {
  "repo1" = {
    name = "module",
    # TODO: set back
    # default_branch = "refs/heads/main",
    default_branch = "refs/heads/example_005",
    initialization = {
      init_type   = "Import",
      source_type = "Git",
      source_url  = "https://github.com/tonyskidmore/terraform-azurerm-vmss-devops-agent.git"
    }
  }
  "repo2" = {
    name           = "pipelines",
    default_branch = "refs/heads/main",
    initialization = {
      init_type   = "Import",
      source_type = "Git",
      source_url  = "https://github.com/tonyskidmore/azure-pipelines-yaml.git"
    }
  }
}

location                     = "uksouth"
nsg_name                     = "nsg-demo-azure-devops-vmss"
resource_group_name          = "rg-demo-azure-devops-vmss"
vmss_name                    = "vmss-demo-bootstrap"
vmss_admin_password          = "Sup3rS3cr3tP@55w0rd!"
vmss_vnet_name               = "vnet-demo-azure-devops-vmss"
vmss_vnet_address_space      = ["192.168.0.0/16"]
vmss_subnet_name             = "snet-demo-azure-devops-vmss"
vmss_subnet_address_prefixes = ["192.168.0.0/24"]
