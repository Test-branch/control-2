variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "github_organization" {
  description = "GitHub organization name"
  type        = string
}

variable "repo_prefix" {
  description = "Prefix of the repositories to apply branch protection"
  type        = string
}