resource "google_container_node_pool" "my-cluster2-node-pool1" {
    count =1
    name ="my-clusqter2-node-pool1"
    #│ Because google_container_cluster.my-cluster1 has "count" set, its attributes must be accessed on
  # specific instances.
    cluster = google_container_cluster.my-cluster2.name
    location = google_container_cluster.my-cluster2.location

    #The number of nodes per instance group. This field can be used to update the number of nodes per instance group but should not be used alongsid
    node_count =1
 
    node_config {
      machine_type = "n2d-highmem-4"
      image_type = "COS_CONTAINERD"
      #grants the nodes in "my-node-pool1" full access to all Google Cloud Platform services.
      oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"] 
      service_account  = "vm-common@jason-hsbc.iam.gserviceaccount.com"
     
    }
}