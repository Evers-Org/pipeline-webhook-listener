terraform {
  cloud {
    organization = "Evers-Org"

    workspaces {
      tags = ["pipeline-dashboard-backend"]
    }
  }
}