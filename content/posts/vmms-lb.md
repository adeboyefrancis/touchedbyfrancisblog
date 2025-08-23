+++
title = "🚧Where Traffic Management Meets Scalability: Designing a Secure Azure Web App Architecture with VMSS and Load Balancer"
date = 2025-08-22
author = "Francis Adeboye"
draft = false
tags = ["VMSS", "Load Balancer", "NAT Gateway", "Bastion", "Azure", "NGINX", "NSG"]
categories = ["Docs"]
+++

![Cover](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/c4qn8xtltrx7buthya8q.png)

## Why Scalability and Traffic Management Matter for Modern Web Apps ?

Scaling web applications in the cloud doesn’t have to be complicated — but it becomes essential the moment your app starts gaining traction. Imagine launching a small MVP gaming app just for fun. You expect a few hundred players, so you host it on a single virtual machine — simple and cheap. But overnight, the game goes viral, and suddenly thousands of players are trying to connect at once. The single Virtual machine hosting the app crashes under the load, and you’re faced with the challenge every developer fears: **scaling fast, without downtime**.

This is exactly the kind of problem that cloud platforms like **Azure , AWS & and other CSPs** are designed to solve. In this demo lab, I’ll walk you through how to set up a **scalable, secure, and monitored web infrastructure** using:

- **Virtual Machine Scale Sets (VMSS)** for automatic scaling

- **Public Load Balancer** to distribute incoming traffic

- **NAT Gateway** for secure outbound connectivity for patches and updates of Virtual Machines

- **Azure Bastion** to lock down admin access to VM securely

- **Network Security Groups** to control inbound traffic

- **Machine Image** for consistent VM provisioning and fast deployment

- **Azure Monitor** to track performance and health

Together, these services handle surging traffic by distributing requests across multiple NGINX web servers, scaling resources based on demand, and maintaining security and observability throughout.

By the end of this demo, you’ll see how even a small MVP can be ready for **going viral** — without breaking under pressure.

####🔑 Prerequisites
Before starting, make sure you have:
- An active Azure subscription
- A valid SSH key pair
- Basic knowledge of Azure VNets, NSGs, and VMs

##  Architecture Overview

Before we dive into the portal, let’s map out what the solution looks like. Our goal is to keep the viral game running smoothly by spreading player traffic across multiple servers, while still keeping admin access secure and updates flowing. Here’s the big picture of how **Azure Bastion, NAT Gateway, NSGs, VM Scale Sets, and the Load Balancer all connect seamlessly**.

![End2End](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/c4qn8xtltrx7buthya8q.png)

## Step 1: 🌐Networking Environment Setup

Every scalable system begins with a solid foundation.  Think of this as laying the groundwork for a new city. Before any buildings can go up, you need to map out the neighbourhoods **(virtual networks)**, assign street addresses **(IP address space)**, divide those streets into smaller blocks **(subnets)**, and establish the rules for who can enter and exit each building **(security groups)**. This structured approach provides the essential backbone where all your servers and services will reside, ensuring a **secure and scalable environment**.

Create a **Resource Group**

- Name: DigitalLab-RG (or reuse existing).

###  Virtual Network, Subnets, NSGs, NAT Gateway for Inbound Traffic, Public Load Balancer & Bastion Host for Secure Access to Custom VM

Create Virtual Network 

- Name: vnet-webservers
- Address space: 10.50.0.0/16

Add Subnets (Private & Bastion)

- snet-custommvms-private: 10.50.10.0/24
- snet-vmss-private: 10.50.11.0/24
- AzureBastionSubnet: 10.50.9.192/26

![Vnet/Subnet](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/28hs4y07b7a3xz5rsz02.png)
![Network](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ebnasct55ityos4s3cxg.png)

Create Network Security Groups (NSG) 

- nsg-customvm: Allow Port 22 from Bastion subnet
- nsg-vmss: Allow Port 80 from Internet, Port 22 from your IP
- linuxworkers-nsg: Allow Port 80 from Internet, Port 22 from your IP ( VMSS NIC)

![customvmnsg](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/zlrwn9761g4k2tndn4lw.png)
![vmssnsg](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/n38pzn7aak10q2ndrsga.png)
![nicnsg](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/may75ym9ay2njdkqaoyd.png)

Associate NSGs to Subnets (Custom VM & VMSS)

- snet-custommvms-private → nsg-customvm
- snet-vmss-private → nsg-vmss
- AzureBastionSubnet → No NSG (Not need, Handled by Azure)

![sub-nsg-assoc](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/mxu8sjw37ejl1wayaptu.png)

Create Network Address Translation Gateway (NAT GW) for Outbound Traffic & Associate NAT to Private Subnet.

Our servers need a way to stay updated **without exposing themselves to the internet**. That’s where the NAT Gateway comes in — letting the VMs **download patches and packages securely**, without opening any direct inbound ports.

- Create NAT GW (Outbound Traffic)
- Attach to snet-vmss-private and snet-custommvms-private

![NATGW](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/oq8ze0dul1zdm47o2soj.png)

Deploy Bastion Host to AzureBastionSubnet

- Name: Jumpbox
- Tier: Standard
- Subnet: AzureBastionSubnet
- Public IP: vnet-webservers-ip

![bastion](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/wgl49yfg4nll869pgg93.png)

![jumpbox](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/khglc0hltokfwlbgt5da.png)

![BASTION](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7j7ihi3vd8rsbitpzle7.png)


## Step 2:🚧 Traffic Management (Load Balancer)

Of course, players won’t connect to servers directly. Instead, all **traffic flows through a Public Load Balancer**, which evenly **distributes requests across our VMSS instances**. If one VM fails or scales out, the load balancer **keeps traffic flowing seamlessly**.

Create Public Load Balancer

- Name: FrontEndLB
- Region: UK South
- SKU: Standard
- Type: Public

Frontend IP Configuration

- Name: FrontEndIP
- Public IP: Create new → LoadBalancerIP

Backend Pool

- Name: LinuxWorkerNode
- Attach to vnet-webservers

Inbound Rules

- Load balancing rule: HTTP (Port 80) → Backend pool
- NAT rule: Map SSH access (Port 221–320) to backend VMs


![Load Balancer](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/x60tx3cvjlnqeyjh3hf4.png)

![Frontend](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ieoq7ne0t98ub81bk1je.png)

![Backend](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/n7zo5to3xqoheukehedb.png)

![Inbound](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/w8tfq0rnwi4tsm59p1iy.png)

![create](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/6zuytm4qnz0o8nd2qmv3.png)

## Step 3: 🖥 Compute Setup

Instead of manually configuring every server, we’ll start by preparing a single **NGINX VM**. Once it’s patched and ready, we’ll capture it as a reusable image in the **Azure Compute Gallery**. Think of this as our source of truth for every future web server for faster deployment.

Create Azure Compute Gallery 
![gallery](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/hyx464p4k6ysyj25xift.png)
- Create Virtual Machine (Linux) 
![vm](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tpg7x8mo8l8z9tf58k8g.png)
![vm](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vzuk9aqke05mmu0l1kbm.png)
- Add Data Disk
![DataDisk](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/asz5pmzuubu16ja7dznj.png)
- Place Custom VM in the Private Subnet for the Network configuration
![network](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/g7pcbwbs8xc1sacr9ryl.png)
- Disable Boot Diagnostic
![boot](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/txcjx3g2g17b5qll4qcg.png)
- Post Configuration user data script to Mount Data Disk, Install Azure Monitor Agent on VM and Install NGINX

```
#!/bin/bash

# Variables
DISK="/dev/sdb"  # Adjust if needed
PARTITION="${DISK}1"
MOUNT_POINT="/mnt/data"
HTML_FILE="/var/www/html/index.nginx-debian.html"

# Create a new partition
echo -e "n\np\n1\n\n\nw" | sudo fdisk $DISK

# Refresh partition table
sudo partprobe $DISK

# Format the partition with EXT4
sudo mkfs.ext4 $PARTITION

# Create mount point and mount the partition
sudo mkdir -p $MOUNT_POINT
sudo mount $PARTITION $MOUNT_POINT

# Make the mount persistent
echo "$PARTITION $MOUNT_POINT ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab

# Install Nginx
sudo apt update
sudo apt install -y nginx

# Replace default Nginx welcome page
sudo bash -c "cat > $HTML_FILE <<EOF
<html>
<head><title>Welcome</title></head>
<body><h1>Welcome to my Ubuntu 22.04 VM</h1></body>
</html>
EOF"

#  Install Azure Monitor Agent with auto-upgrade enabled
echo "Installing Azure Monitor Agent with auto-upgrade..."
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    sudo apt install -y curl
fi
curl -s https://aka.ms/InstallAzureMonitorLinuxAgent | bash -s -- --enable-auto-upgrade

```
![POSTCONFIG](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/0ln5ec2z6tzyulg510wl.png)
![deployment](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ro0szo0shvxcl16uxgym.png)

- Check Azure Monitor Agent Installation for Telemetry
![Agent](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/nssc8vilhwi4m9x7nym5.png)

- Connect to Custom VM via Bastion to check Post Configuration script Installed NGINX 

![connectvm](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/yzb1hcay68m4tgj0f5oj.png)
![ubuntu](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/i3px0y9fzm9win5tymsp.png)
![VM](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/2mg1eylu6jityhcwe1lf.png)

- Stop the Virtual Machine, Capture the Image of the Custom VM , Publish the Image to Azure Compute Gallery
![snapshot](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/68sjz3tifu81zjfu6vod.png)
![image](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/w2pb2r0vee7zld4qc5lj.png)


> Now that NGINX is up and running smoothly on the Custom VM, let’s play it safe and delete the Bastion host, Bastion Public IP and Custom VM to avoid any extra costs before moving on to the next step

![delete](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/sg6p343h973x7v68dmeb.png)
![delete](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/8towwx9usxq8xrynphi6.png)

### Step 4: 📈 Deploying the VM Scale Set (VMSS)

Now comes the fun part: scaling out. Using our template image, we’ll spin up a VM Scale Set (VMSS) so Azure can automatically add or remove servers depending on traffic. This ensures the game won’t lag or crash, even if thousands of new players join.

- Create a Virtual Machine Scale Set (VMSS) using the Linux NGINX template image

![VMSS](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vco33fcb8cyt320q7jo1.png)

- Select the image created by selecting **see all images** to select shared image

![sharedimage](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jds5ygaldawbk3pn94lo.png)

- Configure the Network interface of the VMSS by placing it in the private subnet **snet-vmss-private**, attach the NIC NSG created earlier **linuxworkers-nsg** and disable public IP address.

![NIC](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1cgxieycm8gas5j1jjqh.png)

- Attach VMSS to Load Balancer by selecting  load balancer and the backendpool created earlier

![lB](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gv155a29xkx6bj8qc6q0.png)

- Disable Boot Diagnostic

![Boot](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/mxg1voxnugh36p7vnefi.png)

- Enable & Configure Application Health monitoring for Health Probes

![Health](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/2i89rr6mc86bs4yiphva.png)


### Step 5: 🧪 Testing the Setup

Time to put it to the test. We’ll hit the Public Load Balancer’s IP in a browser, then simulate heavy load by stressing one of the VMs gather performance logs metrics gathered by the azure monitoring agents.

Get Load Balancer IP

- Open in browser → Confirm NGINX landing page.

![FIP](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5qisspemivrrxak2b9xp.png)

![nginx](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/e9uz0xv9ktthbgzuvbtb.png)

- Go to Inbound NAT rule in Load Balancer section to see what port each VM running is mapped to for SSH access from Local source IP.

![NATRULE](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/xqtfxxop2ina6ltdewoy.png)

- Remote into both VM with using public load balancer public ip private key

```
ssh -i "your-key.pem" username@loadbalancerip -p <port>
```
![ssh](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ovjqftd63gjy3l1y02hi.png)

- Test Communication between both VMs
![ping](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ppmgui9nmkm3i7s8zw6m.png)

- Check if NGINX webserver is running , Test Webserver & Azure Monitor Agents on both VMs
![test](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/8jgi7e2abavdifyykmx6.png)

- Make some changes to the content of the html file by navigating to **/var/www/html/index.nginx-debian.html** directory for each server to test how traffic is being distributed by the load balancer

![html](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/u05pz9ub7h0ot1y9j9ke.png)

- Refresh the Load Balancer IP on the browser, you might need to refresh a couple of times to see the changes and traffic distributed on both servers

![node 1](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gzu1r9kysm5cgxwqv19r.png)

![node 2](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/hvxyicoakflzl7uu2aa9.png)

Now that the VMs are running smoothly, Lets try to overload one of the VMs CPU usage by installing stress

![stress](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9r9vdltkawsmruu351cv.png)

![stress](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/73dn98z1yhp7r0f0larx.png)

## Step 6 📊 Monitoring and Insights

Scaling isn’t just about adding servers — it’s about visibility. With **Azure Monitor, Log Analytics, and VM Insights**, we’ll track performance, scaling events, and system health in real time. This way, we can catch issues before players do.

- Create a **Log Analytics Workspace**: central repository where the logs will be stored and analyzed

![Logspace](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/33go3l16jg5o2lnfwqfb.png)

- Next Navigate to Monitor to create **Data Collection Endpoint (DCE)**: This endpoint is a resource that defines a unique URL where monitoring agents send their collected data

![dce](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9jklwryjvrqoh07x6i7n.png)

- Create a **Data Collection Rule (DCR)**: This rule specifies what data to collect and where to send it.

![dcr](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/aemurfy8gv7o4q22ay6m.png)

![resource](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/hw6izbc1eixcdhq5plvh.png)

![resource](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/nolo7iurxf4c59z52l3h.png)

![destination](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/uvnsfw33tpwvmp3g0ihw.png)

Enabling **VM Insights** on the nodes allows the Azure Monitor Agents to execute the rules defined in the **Data Collection Rule (DCR)**. The agents then collect data from the virtual machines and send it to the designated **Data Collection Endpoint (DCE)**. This process links the monitored virtual machines to the **Log Analytics Workspace**, where the collected data is stored and can be analyzed.

![insight](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/cf30ys35qtohw8j1t78r.png)

- Query logs in the Log Analytics workspace

![logs](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/z73u7cqqiek9almmqab9.png)

![logs](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/xk52ihbf9hp7am9j079u.png)

- Monitor Performance in the VM Insight Pane of Azure Monitor

![usage](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/j04m8xi4ajyb048ta4vo.png)

### Step 7: Cleanup (Export Before Deleting)

Before deleting resources, export your deployment template so you can reuse it later.

Export Deployment Template

- Go to your Resource Group in the Azure Portal
- Select Automation → Export Template
- Download the template as JSON or ARM/Bicep
- Save it to your repo or PC for future redeployments

> This template captures your networking, VMSS, load balancer, and monitoring setup so you can redeploy quickly.

Delete Unused Resources (to avoid charges)

- Resource Group (if you don’t need the environment anymore)
- Public IP addresses
- Disks & Snapshots
- NAT Gateway 


## 🎯 Key Takeaways

- VMSS + Load Balancer = scalability and resilience
- Virtual Network + NAT + Bastion + NSGs = secure connectivity
- Compute Gallery + Template Image = fast, consistent deployments
- Azure Monitor = visibility into performance & scaling events






























