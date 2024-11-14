+++
title = "🤖Lets Spice Things Up with a Taste of DevOps🤖 -> Building a Secure Tech Blog: From Manual to Automated using GitHub Actions & Terraform"
date = 2024-11-11
author = "Francis Adeboye"
draft = false
tags = ["GitHub Action", "S3", "RBAC", "ACM", "SSL/TLS" , "OIDC" , "CDN" , "IaC" , "Terraform"]
categories = ["Docs"]
+++

![Final_Arch](https://github.com/user-attachments/assets/cf305e44-184f-4b2a-8074-976ff0068812)


In this episode, I'll walk you through how I built my tech blog infrastructure using **Hugo** as my build tool while combining it with some **Cloud Native Services**, evolving from a basic console setup to a fully automated, secure platform. 
If you're looking to create a similar setup, here's what I learned along the way. <!--more-->

# Phase 1 -> Getting Started with GitHub Actions
I began with AWS services as my foundation. I chose **S3** for its **scalable** and **cost-effective storage** capabilities, perfect for blog content. Adding **CloudFront** as a **CDN** significantly improved content delivery through edge location caching.

- **S3 and CloudFront Setup**  
  Configured S3 for storage and CloudFront as a CDN, implementing **Origin Access Control (OAC)** to secure content delivery. This setup allows blog visitors to access content only via the CloudFront endpoint, enhancing both security and performance.

- **Automated Build Process**  
  Using **Hugo** as a static site generator, we implemented an automated build process through **GitHub Actions**. Now, each repository change triggers a rebuild of the blog, keeping it up-to-date with minimal manual intervention.

- **Security Integration**  
  We set up **IAM Identity Provider** with **OpenID Connect (OIDC)** to enable secure, temporary access for GitHub workflows. Through **Role-Based Access Control (RBAC)** policies, this setup ensures that S3 syncing and CloudFront cache invalidation actions are only performed by authorized GitHub processes.

- **Deployment Pipeline**  
  A robust workflow was created to automate the build, deployment, and CloudFront cache management processes upon repository updates. This pipeline not only speeds up deployment but also maintains site performance by managing CloudFront cache invalidation seamlessly.

# Phase 2: Embracing Terraform and Infrastructure as Code to Automate Continuous Integration & Continuous Deployment

Transitioning to **Infrastructure as Code (IaC)** felt transformative, like switching from manual to automatic transmission. Using **Terraform** simplified and streamlined the management of infrastructure by allowing me to codify configurations and automate deployments. Here’s a look at the key benefits and challenges I encountered along the way.
![terraform-CLIworkflow](https://github.com/user-attachments/assets/d06f6c51-9e40-4ac4-8649-98925afc923f)

# Why Terraform Made a Difference

Using Terraform brought a range of improvements to my deployment process:

- **Increased Reliability**  
  With infrastructure managed as code, deployments became more consistent and less prone to manual errors.

- **Consistency Across Environments**  
  Terraform ensured that each deployment had the same infrastructure setup, reducing discrepancies between environments.

- **Multi-Cloud Flexibility**  
  I could reuse configurations across different cloud providers, making the setup versatile and adaptable.

  ### Terraform Cloud: A Game-Changer

Adopting **Terraform Cloud** for state management was one of the most impactful decisions in this project. Unlike local state management, which can be risky and cumbersome, Terraform Cloud provides a robust, secure solution for handling infrastructure state, which is especially valuable in a team environment. Here’s what makes Terraform Cloud a game-changer:

- **Secure Storage of State Files**  
  Terraform Cloud automatically encrypts and securely stores state files, ensuring that sensitive information, such as credentials and configuration details, is well-protected.

- **State Locking**  
  To prevent conflicting changes, Terraform Cloud implements state locking, which prevents concurrent modifications. This feature ensures that deployments remain stable and consistent, even when multiple team members are working on the same infrastructure.

- **Version History**  
  Terraform Cloud maintains a detailed version history of all infrastructure changes, allowing easy rollbacks if issues arise. This history provides transparency and accountability, making it simple to track changes over time.

- **Simplified Team Collaboration**  
  By centralizing state management, Terraform Cloud eliminates the need for complex backend configurations, enabling team collaboration right out of the box. Team members can access shared infrastructure states without the risk of overwriting each other's work, streamlining workflows and reducing potential errors.

Using Terraform Cloud has greatly improved the reliability, security, and collaborative capabilities of our deployment process, making it an invaluable part of this project’s infrastructure.
![TerraformCloud](https://github.com/user-attachments/assets/4cfabb70-ca88-4abc-af1d-2eb03e54776e)


### Challenges and Lessons Learned

While Terraform made IaC more manageable, there were several important lessons learned through troubleshooting and iteration:

- **Selecting the Right Workflow**  
  Initially, I started with Terraform’s VCS (Version Control System) workflow, but found that the **CLI/API workflow** integrated more smoothly with GitHub Actions, making it easier to trigger automatic deployments from repository updates.

- **Learning GitHub Actions**  
  I encountered a learning curve with GitHub Actions, particularly in passing outputs between workflow steps. By mastering **GitHub outputs**, I was able to pass parameters effectively between steps, streamlining the automation process.

- **Navigating CloudFront Complexities**  
  Cache invalidation with CloudFront introduced some complications. Properly managing **Distribution IDs** resolved issues, ensuring that changes were reflected promptly on the CDN.

- **Managing S3 with Caution**  
  A key lesson learned: handling S3 bucket deletion requires caution. I experienced the importance of double-checking bucket dependencies before deletion to avoid accidental data loss.


# Phase 3: Optimizing Tech Blog Security and Performance with ACM & CloudFront Functions

In this final update, I’ve enhanced my tech blog’s security and performance by combining **AWS Certificate Manager (ACM)** and **CloudFront Functions**. This powerful duo helps deliver a safer, faster, and more seamless user experience.

## How ACM and CloudFront Functions Improve Security and Performance

### AWS Certificate Manager (ACM)
ACM provides **SSL/TLS certificates**, enabling HTTPS for secure data transmission. This ensures that sensitive information, like login credentials or credit card details, is encrypted over HTTPS, protecting it from potential interception. With ACM, implementing encrypted connections across the blog has become both straightforward and scalable.

### CloudFront Functions
CloudFront Functions allow for the execution of custom JavaScript code directly at edge locations, empowering you to:
- **Strengthen Security**: Implement custom security measures, including authentication, authorization, and input validation.
- **Optimize Performance**: Reduce latency and tailor content delivery based on user location.
- **Improve User Experience**: Automatically append `index.html` to directory URLs, ensuring smooth navigation for users.

Together, ACM and CloudFront Functions make it possible to build a blog that’s not only secure but also optimized for performance, delivering a high-quality experience to users worldwide.
![Infra-Output](https://github.com/user-attachments/assets/7da5c757-0d5b-425a-9e2f-df67759f2f1f)

### Implementation Challenge: Certificate Validation Delays

One issue I faced was delays in ACM certificate validation due to DNS propagation times on a third-party hosted domain. To address this in **Terraform**, I used the `depends_on` attribute to enforce proper sequencing, ensuring the infrastructure only proceeded once the certificate validation was complete. This change streamlined the deployment process and helped prevent further delays.

## Conclusion

Integrating **ACM** with **CloudFront Functions** has substantially elevated my blog’s security, performance, and overall user experience. These enhancements ensure not only robust data protection and optimized load times but also a smooth, responsive browsing experience for visitors. This combination of tools is ideal for developers aiming to upgrade their web applications with strong security and seamless content delivery.

Whether you’re building your first tech blog or enhancing an existing one, I hope sharing these insights helps you navigate common challenges and make the most of these powerful AWS tools. If you have any questions about implementing these components, don’t hesitate to reach out!

### Relevant links
[Understanding GitHub Actions](https://docs.github.com/en/actions/about-github-actions/understanding-github-actions)

[GitHub Actions Workflow](https://github.com/aws-powertools/powertools-lambda-python/blob/develop/.github/workflows/release-v3.yml)

[Setup-Terraform Action](https://github.com/hashicorp/setup-terraform)

[IAM Identity Provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html#manage-oidc-provider-console)

[OIDC](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws)

<iframe src="https://giphy.com/embed/EElQxkbh3Bywg" width="480" height="374" style="" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/chappelles-show-EElQxkbh3Bywg">via GIPHY</a></p>
