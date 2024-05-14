terraform {
  cloud {
    organization = "yemenis-in-tech"
    workspaces {
      name = "staticwebsite"
    }
  }
}
