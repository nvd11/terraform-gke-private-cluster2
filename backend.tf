terraform {
  backend "gcs" {
    bucket  = "jason-hsbc"
    prefix  = "terraform/my-cluster2/state"
  }
}
