variable "hcloud_token" {
  description = "Value of hcloud_token to connect to Hetzner Cloud"
  sensitive   = true
}

variable "aws_region" {
  description = "Value of aws region for storing tf state in S3"
  default     = "us-west-1"
}

variable "tf_state_bucket" {
  description = "Bucket name for terraform state file"
  default     = "tf-axion-infra-state"
}
variable "tailscale_key" {
  description = "Value of tailscale_key to connect to Tailscale"
  sensitive   = true
}

variable "server_name" {
  description = "Name of the VM to connect"
  default     = "axion-1"
}

variable "server_location" {
  description = "Location of the VM in Hetzner Cloud"
  default     = "nbg1"
}

variable "server_image" {
  description = "Image ID for the VM"
  default     = "ubuntu-22.04"
}

variable "server_type" {
  description = "Type of instance based on CPU and RAM"
  default     = "cx21"
}

variable "volume_name" {
  description = "Name of the volume in  Hetzner Cloud"
  default     = "axion-root"
}

variable "volume_size" {
  description = "Size of the volume in  GiB"
  default     = 50
}

variable "volume_location" {
  description = "Location of the volume in  Hetzner Cloud"
  default     = "nbg1"
}

variable "volume_format" {
  description = "File system format of the volume"
  default     = "ext4"
}
