resource "google_compute_network" "hyperion-network" {
  name = "hyperion-network"
  ipv4_range ="${var.network}"
}

# Firewall
resource "google_compute_firewall" "hyperion-firewall-external" {
  name = "hyperion-firewall-external"
  network = "${google_compute_network.hyperion-network.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "22",     # SSH
      "80",     # HTTP
      "443",    # HTTPS
      "5050",   # Mesos
      "8080",   # Marathon
    ]
  }

}

resource "google_compute_firewall" "hyperion-firewall-internal" {
  name = "hyperion-firewall-internal"
  network = "${google_compute_network.hyperion-network.name}"
  source_ranges = ["${google_compute_network.hyperion-network.ipv4_range}"]

  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }
}

resource "google_compute_address" "mesos-master" {
  name = "mesos-master"
}


resource "google_compute_instance" "mesos-slaves" {
  count = "${var.nb_slaves}"
  zone = "${var.gce_zone}"
  name = "${var.cluster_name}-slave-${count.index}" // => `xxx-slave-{0,1,2}`
  description = "Mesos slave ${count.index}"
  machine_type = "${var.gce_slave_machine_type}"

  disk {
    image = "${var.gce_image}"
    auto_delete = true
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file("${var.gce_ssh_public_key}")}"
  }
  network_interface {
    network = "${google_compute_network.hyperion-network.name}"
    access_config {
      // ephemeral ip
    }
  }
  connection {
    user = "${var.gce_ssh_user}"
    key_file = "${var.gce_ssh_private_key_file}"
    agent = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo systemctl stop zookeeper",
      "sudo systemctl disable zookeeper",
      "sudo systemctl stop mesos-master",
      "sudo systemctl disable mesos-master",
      "sudo systemctl enable mesos-slave",
      "sudo systemctl start mesos-slave"
    ]
  }

}

resource "google_compute_instance" "mesos-master" {
  zone = "${var.gce_zone}"
  name = "${var.cluster_name}-master"
  description = "Mesos master"
  machine_type = "${var.gce_master_machine_type}"

  disk {
    image = "${var.gce_image}"
    auto_delete = true
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file("${var.gce_ssh_public_key}")}"
  }
  network_interface {
    network = "${google_compute_network.hyperion-network.name}"
    access_config {
      nat_ip = "${google_compute_address.mesos-master.address}"
    }
  }
  connection {
    user = "${var.gce_ssh_user}"
    key_file = "${var.gce_ssh_private_key_file}"
    agent = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo systemctl stop mesos-slave",
      "sudo systemctl disable mesos-slave",
      "sudo systemctl restart zookeeper",
      "sudo systemctl enable mesos-master",
      "sudo systemctl start mesos-master",
      "sudo systemctl enable marathon",
      "sudo systemctl start marathon"
    ]
  }

}

