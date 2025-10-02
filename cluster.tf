
resource "google_container_cluster" "my-cluster2" {
  project  = var.project_id
  name     = "my-cluster2"
  location = var.region_id

  # use custom node pool but not default node pool
  remove_default_node_pool = true

   # initial_node_count - (Optional) The number of nodes to create in this cluster's default node pool. 
   # In regional or multi-zonal clusters, this is the number of nodes per zone. Must be set if node_pool is not set.
   #   If you're using google_container_node_pool objects with no default node pool, 
   # you'll need to set this to a value of at least 1, alongside setting remove_default_node_pool to true.
  initial_node_count       = 1

  deletion_protection = false
  # Gke master will has his own managed vpc
  #but gke will create nodes and svcs under below vpc and subnet
  # they will use vpc peering to connect each other
  network = var.vpc0
  subnetwork =  google_compute_subnetwork.tf-vpc0-subnet3.name

  # the desired configuration options for master authorized networks. 
  #Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)
  # we could just remove the whole block to allow all access 
  #master_authorized_networks_config {
 

  #}

  ip_allocation_policy {
    # tell where pods could get the ip
    cluster_secondary_range_name = "pods-range" # need pre-defined in tf-vpc0-SUbnet0

    #tell where svcs could get the ip
    services_secondary_range_name = "services-range" 
  }

    private_cluster_config {
        enable_private_nodes    = true #  nodes do not have public ip
        enable_private_endpoint = false # master have public ip， we need to set it to false ， or we need to configure master_authorized_networks_config to allow our ip
        
        master_global_access_config {
          enabled = true
        }

    }



    fleet {
        #Can't configure a value for "fleet.0.membership": its value will be decided automatically based on the result of applying this configuration.
        #membership = "projects/${var.project_id}/locations/global/memberships/${var.cluster_name}"
        project = var.project_id
    }
}
