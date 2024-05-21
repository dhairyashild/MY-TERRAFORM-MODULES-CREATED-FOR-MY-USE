provider "aws" {
  region = "us-west-2" # Specify your AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI ID, replace with your own
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}







resource "aws_ebs_volume" "example" {
  availability_zone = aws_instance.example.availability_zone
  size              = 10 # Size in GB

  tags = {
    Name = "example-volume"
  }
}

resource "aws_volume_attachment" "example" {
  device_name = "/dev/sdf"       # In this configuration, /dev/sdf is the device name you provide in Terraform, but within the instance, it might be recognized as /dev/xvdf. The actual device name might be slightly different depending on the AMI and the instance type, but /dev/sdf is a common choice for specifying an EBS volume attachment in AWS. By following these steps, you've created an EBS volume, attached it to an EC2 instance, and prepared it for use.                   
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.example.id
}





List Available Disks:
lsblk

Make a Filesystem on the New Volume:
sudo mkfs -t ext4 /dev/xvdf

Create a Mount Point:
sudo mkdir /mnt/myebs

Mount the Volume:
sudo mount /dev/xvdf /mnt/myebs

Update /etc/fstab for Persistent Mount:
echo '/dev/xvdf /mnt/myebs ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab

# echo '/dev/xvdf /mnt/myebs ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
# explain and why needed
# ChatGPT
# The /etc/fstab file in a Linux system contains information about filesystems and is used to automatically mount these filesystems at boot. Updating /etc/fstab is crucial for ensuring that your EBS volume is mounted automatically each time the EC2 instance is restarted.








