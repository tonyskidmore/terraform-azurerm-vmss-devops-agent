build_definitions = {
  "pipeline1" = {
    "name" : "001-admin_password",
    "repo_ref" : "repo1",
    "yml_path" : "demo-vmss/001-admin-password.yml"
  }
}

git_repos = {
  "repo1" = {
    name = "001-admin-password",
    # default_branch = "refs/heads/main",
    initialization = {
      init_type   = "Import",
      source_type = "Git",
      source_url  = "https://github.com/tonyskidmore/azure-pipelines-yaml.git"
    }
  }
}
