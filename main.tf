provider "github" {
  token = var.github_token
  owner = var.github_organization
}

data "github_repositories" "repos" {
  query = "org:${var.github_organization}"
}

locals {
  filtered_repos = [for repo in data.github_repositories.repos.names : repo if startswith(repo, var.repo_prefix)]
}

resource "github_branch_protection" "protection" {
  for_each = toset(local.filtered_repos)

  repository_id = each.value

  # Get the default branch for each repository
  pattern = data.github_repository.default_branch[each.value].default_branch

  enforce_admins      = true
  allows_force_pushes = false

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 2
  }

  required_status_checks {
    strict   = true
    contexts = []
  }

}

data "github_repository" "default_branch" {
  for_each = toset(local.filtered_repos)
  name     = each.value
}