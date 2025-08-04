+++
title = "🖥️⚙️ Azure VM Provisioning & Web Server Setup: Linux Nginx and Windows IIS Deployment"
date = 2025-01-14
author = "Francis Adeboye"
draft = false
tags = ["Azure", "Virtual Machine", "Linux", "Windows", "IIS", "Nginx"]
categories = ["Docs"]
+++

This guide outlines a practical, hands-on task involving the provisioning and configuration of Azure Virtual Machines to host two of the most popular web servers in use today. This is a foundational skill for anyone looking to work with cloud infrastructure.

---

### **What We'll Be Doing**

We'll be setting up two distinct environments to get a feel for managing different server types in the cloud:

1.  **Linux VM with Nginx:** We'll provision a Linux-based virtual machine and configure it to run **Nginx**. Nginx is a lightweight, high-performance web server that is widely used for static sites, reverse proxies, and scalable microservices. You'll learn how to set up and manage a Linux server from scratch.

2.  **Windows VM with IIS:** We'll provision a Windows-based virtual machine and configure it to run **IIS (Internet Information Services)**. As Microsoft's integrated web server, IIS is the go-to choice for hosting .NET applications, enterprise-level solutions, and internal portals. This will give you experience with the Windows Server ecosystem.


![Architectural Diagram](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/s7l545g57hycnar6cwjn.png)



---

### **Why This Matters for Your Career**

Engaging in this task provides a wealth of benefits that directly translate to your career and skill set:

* **Hands-on Mastery:** You'll gain practical experience with **VM provisioning**, a core skill for any cloud professional. We'll walk through the process using both the Azure Portal (for a visual approach) and the Azure CLI (for automation and scripting practice).

* **Cross-Platform Expertise:** Get comfortable working with both **Linux and Windows server environments**. In today's diverse tech landscape, being proficient in both is a huge advantage, making you a more versatile and valuable asset to any team.

* **Understanding Cloud Concepts:** You'll solidify your understanding of fundamental cloud concepts like networking, security groups, public IPs, and remote access—all in a real-world context.

---

### 🚀 Ready to dive in? Let's get started!

### **🧱 Task 1: Installing IIS on an Azure Windows VM**

First, log on to the Azure Portal.
![Azure Portal](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1voe98eztnchc778l4kj.png)

Before we create our VM, we'll start by creating a dedicated **Resource Group**. This is a logical container that holds related resources for an Azure solution. Using a Resource Group helps with organization, cost management, and lifecycle management of your services.

**Create a Resource Group**

In the Azure Portal search bar, type `Resource Group` and select it from the results.
- Click + Create to get started.

![step1](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tz5lzxp034qkns36arkr.png)

![step2](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ge49aeldniduht273dgx.png)

- **Subscription**: Select your Azure subscription.
- **Resource group name**: Enter a descriptive name like **WebServer-RG**.
- **Region**: Choose a region where you want your resources to be deployed. For this demonstration, we'll use **UK South**
- Click **Review + Create**, then **Create**. Your new resource group will be ready in a few moments.

![step3](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/aryzx0sla4jerxaprabf.png)

![step4](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rzis566scto18m9d88pr.png)

**Create the Windows Virtual Machine**

Now that our resource group is ready, let's create the Windows VM within it.

- Select **Create** within the **WebServer-RG** , then type **Virtual Machine** and select **+ Create > Azure Virtual Machine**.
- Fill out the required parameters:
- **Resource group:** Select the **WebServer-RG** we just created.
- **Virtual machine name:** Name your VM, for example, **WindowsVM**.
- **Region:** This should be the same as your resource group's region (**UK South**).
- **Image:** Choose a suitable Windows Server image.
- **Size:** Select a VM size.
- **Administrator account:** Create a username and password for your VM.
- ** Set Inbound Traffic to **None**, as We will configure Network Security Group **NSG** separately.

 > **💰 Cost-Saving Tip:** For this demonstration, you can select the **Azure Spot Discount** option to get a lower rate. Keep in mind that Spot VMs can be evicted if Azure needs the capacity, so they are not recommended for production workloads.

![step5](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/o9pqwl7h2lfvl25alhjq.png)

![step6](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/qy2b03eoenmnogm9jxny.png)
![step7](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/4rwmkdsjxzonj0tiyfic.png)
![step8](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/j17hjr6g3woypeujdzgh.png)

**Configure Disks, Management & Tags**

- **Disks:** For this guide, we'll use the default OS disk. We'll add a separate data disk later for best practice.
- **Management:** Disable **Boot diagnostics** under the `Monitoring` tab for more control and privacy over your data.
- **Tags:** Use tags for better resource management. Tags are key-value pairs that help with **cost management** and **categorization**. For example:
        - Key: **Department**
        - Value: **IT**
        - Key: **Project**
        - Value: **WebServerDemo**

![step8](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/iifw07bvayi04q4x3uw4.png)
![step9](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/dkr3xy1c8v7ruzjtxw0i.png)
![step10](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/fewp8jqkg161ep0eqepe.png)
![step11](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/f3vjbxbeda6z5xefvbso.png)

**Finalize and Create the VM**

After reviewing all the settings, click **Review + create**. Once the validation passes, click **Create**. The deployment will take a few minutes.

![step12](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ismee2osckcy8gcxd63t.png)

**Attach and Initialize a Data Disk**

Although the **OS disk** is ready, it's a best practice to keep your web content on a separate **Data disk**. This makes it easier to manage backups and resize storage independently.

- Navigate to your new VM's resource page.
- Under **Settings**, go to **Disks**.
- Click **+ Create and attach a new disk**.
- Choose a size and type for your new disk, then click **OK**.

![step13](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/bk48i21ambuip8kzatd3.png)

![step14](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/z5pztdb8qx2cpxykxlbs.png)

**Create Network Security Group NSG to allow Inbound Traffic**

- **Networking:** We will configure inbound ports to allow **RDP (port 3389)** for remote access and **HTTP (port 80)** for web traffic.

![step15](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/toca1tuj83011gt2504y.png)

**Connect to the VM and Prepare the Disk**

Now it's time to connect to the VM using RDP to finalize the setup.

- On the VM's overview page, click **Connect > RDP**.
- Search for Remote Desktop on Local Machine and connect to **WindowsVM** using the administrator credentials you created earlier.
- Inside the VM, search for **Disk Management** in the Start menu.
- You'll see the new disk you just attached. It will be marked as "Not Initialized."
-  **Right-click** the disk and select **Initialize Disk**.
-  **Right-click** on the unallocated space and select **New Simple Volume**. Follow the wizard to format the disk and assign it a drive letter.
![step16](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/06tt3txdvhnd54kcsi5y.png)
![step17](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jqts782myrkubfy6tua7.png)
![step18](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/mc88574pmx86959rpefu.png)
![step19](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/nn826tvi4sc382rnmdca.png)
![step20](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/99kyxajre6klqgq1nydt.png)
![step21](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/xq50lu54adb3wvjasccf.png)
![step22](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/veo9snvi0aj3rn35ndjq.png)
![step23](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ie262mn77dyndfatjl9o.png)
![step24](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/35dbtya4imy56rod70c2.png)
![step25](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/wj671iy7y8wotzuzgb9h.png)

**Install and Verify IIS**

With the VM ready, let's install IIS. The easiest way is with PowerShell.
- Launch **PowerShell as an Administrator**.
- Run the following command to install the web server role and its management tools:
 
```
Install-WindowsFeature Web-Server -IncludeManagementTools
```
- Verify Webserver is running via Power Shell

```
Invoke-WebRequest http://vm-public-ip-address 
```
Once the installation is complete, you can verify it's running from your browser.
- Find the VM's public IP address in the Azure Portal.
- Open a new browser tab and navigate to `http://<your-vm-public-ip-address>`.

You should see the default IIS welcome page! This confirms your web server is up and running.
![step26](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ba5pibi00iel8vukd1cb.png)
![step27](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/y1nycdcp6anyo5ngth63.png)

### **🪟 Task 2: Deploying a Web Server (NGINX) on Azure Linux VM via CLI**

In this section, we’ll provision an Ubuntu Linux VM using **Azure CLI** and configure it as a web server by **installing Nginx**.

**Purpose:**
To demonstrate automated resource provisioning using Azure CLI and highlight its contrast with GUI-based deployment via the portal. This method offers **transparency**, **repeatability**, and **control—skills** essential for FinOps, DevOps, and security workflows.

While this guide uses Azure CLI, alternative **Infrastructure as Code (IaC)** approaches like **PowerShell, ARM templates, Bicep, and Terraform** can be used based on team preferences, project scale, and governance requirements.

**Prerequisites:**
- Azure CLI installed on your local machine: You can follow the official [Azure CLI installation guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) to get it installed.

**Log on to Azure portal via CLI**
- Launch Terminal or VSCode run `az login` to connect Azure Portal
- Select the **Subscription number** to be used for the deployment
- This will prompt microsoft authentication in the browser 
- Fill in your azure portal credentials to complete log in process

![az login](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7qzgig2l2grw73yz1oj2.png)

**Create or Use Existing Resource Group**

In the previous task, We created a Resource Group named **WebServer-RG** which I will be using for the rest of this demonstration.
- List out existing Resource Group in Azure Account
`az group list --output table`

![ListRG](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/i4hbk7424okav898zgn2.png)

**Deploy Azure Linux Virtual Machine (Ubuntu)**
> **✅ Tip:** --nsg-rule NONE avoids exposing inbound ports.

```
# Create azure vm
az vm create \
  --name LinuxVM \
  --resource-group WebServer-RG \
  --image Ubuntu2204 \
  --size Standard_D2s_v3 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --priority Spot \
  --eviction-policy Deallocate \
  --nsg-rule NONE \
  --tags environment="Development Lab" os="Linux" department="IT Operations" role="Cloud Administrator"
```
```
# Disable Boot Diagnostics
az vm update --name LinuxVM --resource-group WebServer-RG --set diagnosticsProfile.bootDiagnosticsEnabled=false
```
![VMCreate](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jqtykk5ads071pn9qieu.png)

![vm](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/s32ho2qybajdqt9filpl.png)

**Create NSG to allow Inbound Traffic on Port 22(SSH) & Port 80(HTTP)**

```
# Create NSG rule for SSH and HTTP access
az network nsg rule create --resource-group WebServer-RG --nsg-name LinuxVMNSG --name AllowSSH --protocol Tcp --priority 1000 --destination-port-range 22 --access Allow
az network nsg rule create --resource-group WebServer-RG --nsg-name LinuxVMNSG --name AllowHTTP --protocol Tcp --priority 1001 --destination-port-range 80 --access Allow
```

![Port22](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3ww1qj7owig3aw9qz2oz.png)
![Port80](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ne0lup5ihiv27j9ezulg.png)
![nsg-rules](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5jyzh2yzn3frwlpf67rz.png)

**Create Data Disk & Associate New Disk to VM**

```
# Create Data Disk and attach it to the VM
az disk create --resource-group WebServer-RG --name DataDisk1 --size-gb 8 --sku Standard_LRS
az vm disk attach --resource-group WebServer-RG --vm-name LinuxVM --name DataDisk1  
```
![createdisk](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7nt9kellcizuzy4kav6z.png)

![disk](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/68h2t5kt32psgnh3domv.png)

**Connect to VM via Secure Shell (SSH)**
- Navigate to the Path where the ssh key is kept, typically would be in `/.ssh`

```
# Connect to the VM using SSH
ssh -i "file-path-to-ssh-key" azureuser@<vm-public-ip-address>
```
![connectvm](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/acle6q2oysbl25ic99hp.png)

**Mount Newly Created Data Disk on VM**

```
# Switch to root user
sudo su

# Mount Disk
<< EOF
sudo fdisk /dev/sdc << EOL
n
p
1
w
EOL
sudo mkfs.ext4 /dev/sdc1
sudo mkdir /mnt/data
sudo mount /dev/sdc1 /mnt/data
echo '/dev/sdc1 /mnt/data ext4 defaults 0 0' | sudo tee -a /etc/fstab
EOF

# List the disk in Linux VM with df command
df -h

# Show mounted disks
lsblk
```
![Mount Disk](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/lhwse3pu3b8wmw8h4olt.png)

**Install NGINX on Ubuntu Virtual Machine**

```
# Install NGINX on the VM
apt update
apt install -y nginx
systemctl start nginx
systemctl enable nginx

# Check NGINX status
systemctl status nginx
```
![InstallNGINX](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/06aq6ffwyuvj148cie3z.png)

![Webserver](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/72f4l1hte5akdbgfbmhf.png)

**Clean Up Resources**

```
# Stop the virtual machine
az vm stop --name LinuxVM --resource-group WebServer-RG

# Delete the virtual machine
az vm delete --name LinuxVM --resource-group WebServer-RG --yes --no-wait   

# Clean up the resource group
az group delete --name WebServer-RG --yes --no-wait
```

## **🧠 Final Thoughts**
Provisioning web servers across different platforms in Azure isn’t just a technical exercise—it’s a blueprint for cloud fluency. By deploying IIS via the portal and NGINX via CLI, you’ve shown how flexible Azure can be for hybrid workflows, real-world scenarios, and secure architecture.

