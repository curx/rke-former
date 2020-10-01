resource "openstack_networking_network_v2" "cluster_network" {
  name = "${var.prefix}-cluster-network"
  admin_state_up = true
  mtu = var.cluster_network_mtu
  availability_zone_hints = var.availability_zone_hints_network
}

resource "openstack_networking_subnet_v2" "cluster_network" {
  name = "${var.prefix}-cluster-network"
  network_id = openstack_networking_network_v2.cluster_network.id
  cidr = var.cluster_network_cidr
  ip_version = 4
  no_gateway = false
  enable_dhcp = true
}

resource "openstack_networking_router_v2" "external" {
  name = "${var.prefix}-external"
  admin_state_up = true
  external_network_id = var.external_network_id
  availability_zone_hints = var.availability_zone_hints_network
}

resource "openstack_networking_router_interface_v2" "external" {
  router_id = openstack_networking_router_v2.external.id
  subnet_id = openstack_networking_subnet_v2.cluster_network.id
}

### SSH
resource "openstack_networking_secgroup_v2" "ssh" {
  name = "${var.prefix}-ssh"
  description = "SSH for bastion host"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = openstack_networking_secgroup_v2.ssh.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
}

### K8s API
resource "openstack_networking_secgroup_v2" "k8s_api" {
  name = "${var.prefix}-k8s-api"
  description = "Kubernetes API"
}

resource "openstack_networking_secgroup_rule_v2" "k8s_api" {
  security_group_id = openstack_networking_secgroup_v2.k8s_api.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = var.kubernetes_api_port
  port_range_max = var.kubernetes_api_port
}

### Ingress
resource "openstack_networking_secgroup_v2" "k8s_ingress" {
  name = "${var.prefix}-k8s-ingress"
  description = "Kubernetes Ingress"
}

resource "openstack_networking_secgroup_rule_v2" "k8s_ingress_http" {
  security_group_id = openstack_networking_secgroup_v2.k8s_ingress.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
}

resource "openstack_networking_secgroup_rule_v2" "k8s_ingress_https" {
  security_group_id = openstack_networking_secgroup_v2.k8s_ingress.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
}

### K8s NodePort range
resource "openstack_networking_secgroup_v2" "k8s_nodeport_range" {
  name = "${var.prefix}-k8s_nodeport_range"
  description = "Kubernetes NodePort range"
}

resource "openstack_networking_secgroup_rule_v2" "k8s_nodeport_range" {
  security_group_id = openstack_networking_secgroup_v2.k8s_api.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = var.kubernetes_nodeport_range_min
  port_range_max = var.kubernetes_nodeport_range_max
}
