resource "azuredevops_git_repository_file" "tf" {
  for_each = fileset(path.module, "tf/*")

  # other configuration using each.value
  repository_id       = azuredevops_git_repository.example.id
  file                = each.value
  content             = file("${path.module}/${each.value}")
  branch              = "refs/heads/examples" # TODO:
  commit_message      = "bootstrap update"
  overwrite_on_create = true
}
