# create a subnet
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "tf-vpc0-subnet3" {
  project                  = var.project_id
  name                     = "tf-vpc0-subnet3"
  ip_cidr_range            = "192.168.5.0/24" # 192.168.4.1 ~ 192.168.04.255
  region                   = var.region_id
  # only PRIVATE could allow vm creation,  the PRIVATE item is displayed as "None" in GCP console subnet creation page
  # but we cannot set purpose to "None",  if we did , the subnet will still created as purpose = PRIVATE , and next terraform plan/apply will try to recreate the subnet!
  # as it detect changes for "PRIVATE" -> "NONE"
  # gcloud compute networks subnets describe tf-vpc0-subnet3 --region=europe-west2
  purpose                  = "PRIVATE" 
  role                     = "ACTIVE"
  private_ip_google_access = "true" # to eanble the vm to access gcp products via internal network but not internet, faster and less cost!
  network                  = "tf-vpc0"

  # Although the secondary\_ip\_range is not within the subnet's IP address range, 
  # they still belong to the same VPC network. GKE uses routing and firewall rules to ensure communication between Pods, Services, and VMs."

  secondary_ip_range {
    range_name    = "pods-range"      # 用于 Pods
    ip_cidr_range = "192.171.16.0/20"     # 选择一个不冲突的范围
  }

  secondary_ip_range {
    range_name    = "services-range"  # 用于 Services
    ip_cidr_range = "192.172.16.0/20"     # 选择一个不冲突的范围
  }
}