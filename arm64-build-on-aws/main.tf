//variables
variable "machine_type" {
  type        = string
  description = "The machine type to be launched like t2.micro, t2.medium"
  default     = "a1.medium"
}

variable "os_image" {
  type        = string
  description = "The OS image to be used, ami id, like ami-035966e8adab4aaad, by default Amazon Linux is used"
  default     = "ami-006c19cfa0e8f4672"
}

variable "os_user" {
  type        = string
  description = "The default user for the given os_image, for example amazon images use user 'ec2-user', while ubuntu based images use user 'ubuntu'"
  default     = "ec2-user"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "zone" {
  type        = string
  description = "AWS region zone"
  default     = "eu-west-1c"
}

variable "aws_access_key" {
  type        = string
  description = "The AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "The AWS secret key"
}

variable "graphdb_version_to_build" {
  type        = string
  description = "The GraphDB version for which the arm64 image will be built"
}

variable "dockerhub_username" {
  type        = string
  description = "The dockerhub username"
}

variable "dockerhub_password" {
  type        = string
  description = "The dockerhub password"
}

resource "tls_private_key" "generate_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

//save the generated temporary keys
resource "null_resource" "save_generated_key" {
  triggers = {
    key_generated = tls_private_key.generate_key.id
  }
  provisioner "local-exec" {
    command = "mkdir -p .temp && echo \"${tls_private_key.generate_key.private_key_pem}\" > ./.temp/temp_key && echo \"${tls_private_key.generate_key.public_key_pem}\" > ./.temp/temp_key.pem && echo \"${tls_private_key.generate_key.public_key_openssh}\" > ./.temp/temp_key.pub && chmod 400 .temp/*"
  }
}

//remove the generated keys on destroy
resource "null_resource" "remove_generated_key" {
  provisioner "local-exec" {
    when    = "destroy"
    command = "rm -r .temp"
  }
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 4
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

resource "aws_key_pair" "generated_key" {
  key_name   = "gdb_generated_key_pair_${random_id.instance_id.hex}"
  public_key = tls_private_key.generate_key.public_key_openssh
}

resource "aws_instance" "graphdb" {
  count                       = 1
  ebs_optimized               = true
  associate_public_ip_address = true
  //amazon linux by default
  ami           = var.os_image
  instance_type = var.machine_type

  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
  }

  vpc_security_group_ids = [
    aws_security_group.graphdb-security.id
  ]
  availability_zone = var.zone
  key_name          = aws_key_pair.generated_key.key_name
  tags = {
    Name    = "graphdb-auto-tests-${random_id.instance_id.hex}"
    Project = "GDB"
  }
  volume_tags = {
    Project = "GDB"
  }
}

resource "null_resource" "instance-provisioning" {
  count = 1

  connection {
    host = aws_instance.graphdb.*.public_ip[count.index]
  }

  provisioner "remote-exec" {
    inline = [
      templatefile("${path.module}/init-script.sh", {
        GRAPHDB_VERSION    = var.graphdb_version_to_build,
        DOCKERHUB_USERNAME = var.dockerhub_username,
        DOCKERHUB_PASSWORD = var.dockerhub_password
    })]
    connection {
      type        = "ssh"
      private_key = tls_private_key.generate_key.private_key_pem
      user        = var.os_user
      timeout     = "10m"
    }
  }
}

resource "aws_security_group" "graphdb-security" {
  name = "graphdb-auto-tests-${random_id.instance_id.hex}"
  tags = {
    Project = "GDB"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
