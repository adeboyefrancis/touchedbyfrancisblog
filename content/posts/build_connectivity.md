+++
title = "🔒🚦Building Connectivity & Secure Resource Sharing via AWS Resource Access Manager🚦🔒"
date = 2024-11-14
author = "Francis Adeboye"
draft = false
tags = ["VPC", "Network", "RAM", "Subnet", "Internet Gateway" , "Natgateway" , "CDN" , "IaC" , "Hashicorp"]
categories = ["Docs"]
+++

![network_infra](https://github.com/user-attachments/assets/ac61ec97-5629-41c5-a875-442bd61bb5a7)

In this post, we'll explore how to secure and optimize cloud infrastructure,which can help **organizations** build a **Robust**, **Secure**, and **Scalable** cloud environment by leveraging powerful tools like **Virtual Private Cloud (VPC)** and **Resource Access Manager (RAM)**.
We'll also discuss how this project take a step further by combining VPC & RAM to ensure business-critical applications are secured and inaccessible from the public internet while **minimizing cost** by **sharing resources** with other multi-accounts created by **Control Tower**. <!--more-->

### Key Consideration
Before we dive into the main agenda, let’s highlight a few key points. For any organization to thrive in today’s fast-paced and constantly evolving digital landscape, **Speed, Agility, and Reliability** are crucial. These factors drive the delivery of successful products, software, value, and services to remain competitive and meet end-user expectations—from the point of inception through continuous improvement, all while adhering to SLAs.
Essentially, **People, Processes, and Products** must evolve to adapt to change. 
In this phase we will be focusing on **Continuous Integration with GitHub Action & Delivery of Infrastructure with Terraform**.

![Service_Value_Chain](https://github.com/user-attachments/assets/9512b437-28a1-4d51-a224-211c04b1f927)

# Why Do We Need VPC and RAM?
**Virtual Private Cloud (VPC)** is essentially a private network within a public cloud provider, comparable to a private hotel. Just like a hotel has a public lobby, a VPC has a public subnet, typically with an **Internet Gateway (IGW)** and **Network Address Translation (NAT) Gateway**. These gateways act as the hotel's reception, enabling communication with the outside world.
Within this VPC, resources like **virtual machines (VMs) and databases** are assigned to specific **subnets (private or public)**, depending on their criticality. This is similar to how guests are assigned to rooms on different floors in a hotel. For instance, a subnet might be designated as the "third floor," with **IP addresses** ranging from `10.0.3.0` to `10.0.3.255`.
Resources within the same subnet can communicate directly, like guests on the same floor using an intercom. However, **Security Groups** act as **virtual firewalls**, ensuring that only **authorized traffic** can flow between resources, even within the same subnet. To access the internet or communicate with resources in other subnets, they must go through the "reception" **(the NAT Gateway or IGW).** This ensures controlled and secure access, similar to how a hotel guest must go through the reception to make an international call.
By **isolating resources in private subnets** and leveraging **Security Groups**, organizations can significantly enhance **security and prevent unauthorized access.** This is parallel to guests being assigned to private rooms, limiting their interactions with other guests and the outside world. Additionally, **VPC Peering** allows organizations to connect multiple VPCs, similar to different hotels within a chain being able to communicate and share resources.

[**Deployment of Network Infrastructure via Terraform** can be found here](https://github.com/adeboyefrancis/infra-network)

**VPC created in Nework-Infrastructure OU Account**
![VPC_infrastructure](https://github.com/user-attachments/assets/de69faa3-abbf-4c89-9c3d-40c5ce295dd1)

# Resource Access Manager
While a **Virtual Private Cloud (VPC)** provides a secure, private network within a cloud provider, organizations often need to share specific resources, like **subnets or databases**, across different **departments or accounts**. This is where **Resource Access Manager (RAM)** becomes essential. RAM enables controlled sharing of cloud resources between accounts in the same **organization or with trusted external accounts**, without exposing them publicly.
For example, think of RAM as a secure, private channel between different hotels in the same hotel chain. RAM allows each "hotel" (or department/account) to access certain facilities or resources located in another "hotel" (or VPC), such as a shared dining hall, but with strict access control. By using RAM, organizations can efficiently share specific VPC subnets or other resources with other accounts, while still **maintaining security, reducing complexity**, and avoiding duplicate resources.
In the context of a VPC, RAM ensures that **shared resources are accessible only to authorized users and can be managed centrally, streamlining resource distribution and improving cost efficiency**. It also facilitates **cross-account collaboration** while maintaining each **VPC's privacy and security settings** as shown below where I share VPC subnets resource created in my **Network OU** with the **Sandbox OU Development** account where applications would be deployed.

![Shared-Newtork](https://github.com/user-attachments/assets/58bf5fd6-f9d0-44c4-b2fa-24c04486a82f)


**Shared Subnets with Development OU Account**
![Shared-Subnets](https://github.com/user-attachments/assets/3bab29cb-0850-4bb1-b958-065ca321bc3c)

### Benefits of VPC and RAM: Security, Control, Scalability, Flexibility and Collaboration

- **Isolation**: VPCs isolate business-critical resources from public internet threats, similar to a private hotel room where only authorized guests have access.

- **Controlled Access**: Gateways like **Internet Gateway (IGW) and NAT Gateway** act as controlled access points—much like a hotel's reception limiting who can enter and exit the private network.

- **Fine-grained Access Control**: **Resource Access Manager (RAM)** provides the ability to assign specific permissions (or "keys") to different **users, accounts, or organizational units (OUs)**. This ensures that only **authorized individuals can access specific resources**. In this project, RAM enables the sharing of specific subnets with a development account created by Control Tower, similar to a hotel chain selectively sharing certain facilities with another hotel.
  
- **Flexible Resource Allocation**: VPCs offer **flexibility** in resource allocation and scaling, adapting to evolving needs—much like a hotel adjusting to different guest capacities and room types. This flexibility extends to creating subnets of various sizes using CIDR blocks to accommodate diverse network requirements.

- **Cross-Account Collaboration**: RAM enables controlled sharing of resources across different accounts, promoting **collaboration and efficiency** without **compromising security**.

### Conclusion
By combining **VPC** and **RAM**, organizations can establish a **robust security posture, protect their valuable assets in the cloud**, and ensure **efficient collaboration between teams and departments**. In this phase, we achieve this by **sharing subnets from our network infrastructure account with the development account**.

### Relevant links
[AWS Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/network.html)

[Amazon Virtual Private Cloud (VPC)](https://aws.amazon.com/vpc/)

[Resource Access Manager](https://aws.amazon.com/ram/)

<iframe src="https://giphy.com/embed/EjuelmR5LHY7C" width="480" height="271" style="" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/boys-EjuelmR5LHY7C">via GIPHY</a></p>
