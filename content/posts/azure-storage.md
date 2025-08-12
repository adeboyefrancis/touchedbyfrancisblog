+++
title = "🛡️ Managing Azure Storage Accounts: Secure, Scalable, and Resilient Data Solutions with Blob Storage & Azure Files"
date = 2025-08-11
author = "Francis Adeboye"
draft = false
tags = ["Blob Storage", "Encryption", "Azure Files", "Vault", "Azure", "Microsoft", "Security"]
categories = ["Docs"]
+++

![cover](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/y4e52aj1tayrf2rw5ypt.png)

In today’s cloud-first world, businesses need storage solutions that are not just scalable—but secure, highly available, and resilient to failure. **Azure Storage Accounts** offer exactly that: a unified platform for storing **diverse data types—blobs (Binary Large Object), files, queues, tables, and disks—accessible globally over HTTP/HTTPS with a unique namespace**.

Whether you're backing up a **public website**, **managing internal documents**, or enabling **shared access** across departments, Azure’s storage services provide the **flexibility and control** needed to meet enterprise demands. With built-in **redundancy** options like **LRS, ZRS, GRS, RA-GRS and GZRS**, your data is protected against local failures and regional outages. And with **encryption at rest**, **network isolation**, and **identity-based access**, **security** is baked into every layer.

This hands-on guide walks through five real-world scenarios, each mapped to a specific Azure storage configuration:

### 🧪 Provisioning Storage for IT Team Training & Development

This solution requires a **low-cost**, flexible storage solution for **large files like software test builds and training videos**. Using Azure Blob Storage with **Locally Redundant Storage (LRS)** fits the bill perfectly. This setup is ideal because it's a **cost-effective** option that's designed for data that doesn't need a backup. Plus, **all data transfers are kept secure using TLS 1.2 encryption**

![ArchTask1](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ienjmdxed6g4tdy86g59.png)

- Create a **Resource Group** Container for this project: **StorageAccountLab-RG** 

> I'll be using my existing Resource Group for the Demonstration

![Create a Resource Group](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7370cyd7xgra9up38vpu.png)

- Deploy a **Storage Account** to support testing and training for the IT Team.

> Use the search Bar: **Storage Accounts** -> **Create**

![Search for storage account](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/qzaw96zpgt2ip30jjjsd.png)

![Create](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7spwi0fk9zbpxo6z06oj.png)

> Select Subscription -> Resource Group -> Storage Account Name ( Globally Unique) -> Standard -> Locally Redundant Storage ( LRS ) -> Review+Create -> Go to Resources

![Fill Parameter](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/31y0ajy075jkjp35gc00.png)

![Go to Resources](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ndtk2nk8l5pg7z4vj7xd.png)

- Configure simple settings  for Data Redundancy , Secure Transfer , Transport Layer Security (TLS) v1.2 , Shared Keys & Public Access.


![Data Redundancy](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/4k61l8zk04v9m0hfaied.png)


![Basic Settings](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/zwfrmfdot95wvfl7ove8.png)


![Set Public Network](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/411xc0wxm82dwsfb72ui.png)

![Enable Public Network](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5wt47sgqbhhfbs2e7h39.png)

### 🌐 Public Web Storage for Product Delivery to Global Customers

This task sets up **Azure Blob Storage** to host a public company website container with the intent to **deliver product images and content to global users**. We’ll create a highly available storage account with **RA-GRS redundancy**, configure **anonymous access** for fast public delivery, and enable features like **soft delete and versioning to protect and manage content**. The goal is to ensure quick load times, easy access, and resilience—without requiring users to log in.

![ArchTask2](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/yixll9f75skn83edm3nx.png)

- Create a Storage account to support public website using default settings

![Storage Account with HA](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/6nurdmuty1rrk39zq66x.png)


![Enabled](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/s4c3b2iledeos0lhz14b.png)

-  Configure High Availability that allows Read access in a Secondary Region if there is  Regional Failure

> Navigate to the **Data Management** section -> Select **Redundancy** -> Select **Read-access Geo Redundant storage** -> Review the Primary & Secondary Location

![RA-GRS](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/qovadbhvgcjs1oxhftag.png)

- Enable Accessibility to public website without customer login requirement

> Settings -> Configuration -> **Enable Allow Blob anonymous access** -> Save

![Allow Anonymous](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/dfv52sqrlbwupnfeg4uf.png)

- Create Blob Container where images & product catalogues will be uploaded

> Data Storage section -> Select Container -> Name **publicwebsite** -> Create

![container](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/6tzjeqtc8uap1e69iwps.png)

- Configure anonymous read access for the public container blobs that allows global customers to view contents without authentication.

> Select the Public website container -> Change access level -> Select **Anonymous read access for blobs only** -> OK

![change access](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/n1kr8qj0t7o42jup60nb.png)

![anon read ](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/u2louitospc85plogd5e.png)

![access tier](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5lz8h4p6clj1qud74ms9.png)

- Upload files to the public website container to test access

![Upload files](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/pyt0fmrkzbkmf3s3lmja.png)

![Copy Url](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/c0i6ujab5ftvolnk1w9k.png)

![Open in browser](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/qzgh37l8d1z5zkbljgp1.png)

- Configure Soft Delete feature to protect website contents from accidental deletion

> Navigate to Data Management -> **Enable Soft Delete for blobs** -> Set retention period for 21 days -> Save

![Soft delete](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/t6m122zod9txtxvzvra6.png)

> Delete Uploaded files -> Select **show active and deleted blobs** to display files that has been deleted from the container -> select **Undelete** to restore file -> Select **Only show active blob** once file has been undeleted/restored

![active&deleted](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vlxo9wk526xhxguhwbuc.png)

![undelete](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/chi4nfj5jc4y395zr9fz.png)

![Test](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3qszzjugd2x3vgxkvhs1.png)

- Enable versioning to keep track of changes in product documents 

> Data Management -> Data Protection -> **Select Enable versioning for blobs** -> Keep all version -> Save

![Versioning](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/o52qhnrafnxejxwxk7ef.png)

- To understand version control, upload a new version of a file with a small change. This will create a new version of the document, allowing you to easily revert to the original if needed

> When you attempt to upload the same file after small changes has been made, You will notice the file already exist, select **overwrite if file exists**

![Already exist](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gdkw9ie4p5rog1tz08ac.png)

![Overwrite](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9kbpwrmnsyzs5ttdqg4h.png)

![New upload](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/u9qojobgsudgjzjuwdz1.png)

> View versions -> Show deleted version

![current version](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/bcuneulkres8011htp5c.png)

![versions](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/zr645i8mj0wca8trjs4z.png)


![more versions](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/im3iy9m2p5lfxuju9egx.png)

### 🔐 Private Internal Storage for Corporate Documents - Secure, Redundant, Cost Effective & Controlled Access

In this task, we’re provisioning a secure Azure Blob Storage solution for **internal corporate documents**, designed to meet enterprise-grade requirements for **availability, privacy, and operational efficiency**. The storage account is configured with **Geo-Redundant Storage (GRS) to ensure high availability** in the event of regional outages. **Sensitive files** are housed in a private container with **no anonymous access**, maintaining strict internal confidentiality. We’ll handle secure file uploads and generate **SAS tokens to enable scoped, time-bound access for external partners**. To **optimize costs, lifecycle management will automatically transition blobs to the cool tier after 30 days**. Finally, we’ll **replicate objects** from a public container into this private one, ensuring **internal backup continuity and data resilience**.

![Arch3](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/uidnt1h83ykaxbsxbnsl.png)

- Create a storage account for internal **private** corporate documents with High Availability **(GRS)**

![Private](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7p205d3dep6b7j8kceyg.png)

> Ensure to check **Data Management** section that Redundancy is set to **GRS** as Read access is not required in the Secondary Region, Apologies for the error :)

![GRS](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vd1o020ybqhdi3b1f5ej.png)

- Create private storage container to store corporate document
- Upload a file to the private container and test its not publicly accessible.

![Private](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9amyf7j3bd8w0kht2tuu.png)

![Nonaccessible](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/8pb2bab4cauvx8p89qpg.png)

- Generate a **Shared Access Signature (SAS) Token/URL** that with will be used by Third Party partners for **Read**/Write permissions

> Select uploaded file -> click on the 3 dots -> Select **Generate SAS**
> Set permission to Read -> Set Start and Expiry to 24hrs -> Https -> **Generate Token and URL** -> Copy URL to browser to view file

![SAS](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/w3o9ewqk9voi8wplpk0c.png)

![Read Permisson](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/w4ig82q4e02twgfmr737.png)

![View](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/y5np1u90zh2strc8j1xd.png)

- Configure a **Lifecycle rule in Data Management** section that move blobs from Hot to Cool Tier

> Data Management -> Lifecycle management -> Add rule

![Lifecylerule](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/058d97gh9asr885ek8sc.png)

![Movetocool30](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/n5u1oixxzqksy2q1k1n3.png)

![30days](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/damlnwvinpdyw0m4nvjm.png)

- Set up **Backup container** in the private storage account for **object replication** from the public website to the private back up container.

> Data Storage -> Add Container -> enter parameters for **backup** and default setting -> Create

![BackUp](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ggodse0o9f2tqczhrt18.png)

- Navigate back to the **public website storage account** to set up replication rule
- Add Replication rule with **Destination Storage Account(Private)** **Source container (public)** to **Destination container (private)**
- Review **replication rule**
- Upload a file into the public container
- Check the **private container** to check object was replicated, This can take up to 2-5mins, so you might need to refresh a couple of times.

![Replication](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ox9zu0booce16wdyrt9y.png)
![Rules](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/230k4qtht3dhdrgh34ng.png)
![replication rule](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/34fg97fefipfs7reqbai.png)
![Upload object in public object](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3hsibawf8a9xf2z24hdu.png)
![Replication completed](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/cu7ufeha4989jm30wa61.png)

### 🗂️ Secure Shared File Storage for Finance Department Using Azure Files

We’ll configure **Azure Files** to support **shared file storage** for the company’s **finance department**. The solution uses a **Premium-tier storage account with ZRS redundancy** to ensure **performance and availability across zones**. We’ll create a dedicated file share and directory for corporate use, enable **snapshot protection to guard against accidental deletions**, and test restore functionality. To secure access, we’ll restrict connectivity to a specific virtual network using **service endpoints**, and switch the storage account from public to selected network access only, ensuring that file access is **tightly controlled and compliant with internal policies**.

![ArchTask4](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/q5u3civ2cgkf3cthcsqt.png)

- Create a **Zone Redundant** storage account for the finance department's shared files in the Resource Group **StorageAccountLab-RG".

> Storage accounts -> + Create -> Resource group -> Create new -> [enter name] -> OK -> Storage account name -> [enter name] -> Performance -> Premium -> Premium account type -> File shares -> Redundancy -> Zone-redundant storage -> Review -> Create -> Go to resource

![sarg](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/yf0f7e611ojdehe0rctj.png)

![sa](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/johrpn35f6ru71y4mmsc.png)

![createsafile](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/l5gq35l6cugbcr4e5lih.png)

![Gotoresources](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/zwejryds2hsislrew5qc.png)

- Create file share for the corporate office 

> **File shares** -> + File share -> Name -> [enter a name] -> Go to back up tab to disable backup -> Create

![fileshare](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7qmlf8y3vgs5xoiyp079.png)
![gotobackup](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1rt80hojcbr0a0h1ukin.png)
![disable backup](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/uu8bcnc8a0geskdlrnm1.png)

- Configure a directory for  the finance department

> **Select your file share** -> + Add directory -> Name -> finance -> Browse -> [select finance directory] -> Upload -> [select a file]

![storagebrowser](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/muimehhifi7zsbji4lqk.png)
![directory](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/xqwxhrmraz1o0z3xgl78.png)
![fiance](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/o9a7dl943m2qfcdpk87q.png)
![upload](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/48o5rq4z9cbg3f52rvk9.png)
![uploadedfile](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/i01qjf0a14p6sr72t3fo.png)

- Create Snapshot of the file share to protect against accidental deletion

> Select your file share -> Operations -> Snapshots -> + Add snapshot -> OK -> Select your snapshot -> [verify file directory]

![Snapshots](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/talgfjazjwhnva2s16yp.png)

- Restore a File from a Snapshot

> Return to file share -> Browse -> [locate and select file] -> Properties -> Delete -> Yes -> Snapshots -> [select snapshot] -> [navigate to file] -> Restore -> [enter new file name] -> Verify

![DeleteOps](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3zdlivkfmavptje1puk7.png)
![RestoreSnap](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/atptr1ba0vhyeasioof8.png)
![retoration](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/s9xv2hqq2mzkigfkleve.png)
![res](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/uqp37ic9cuw28t5gy2mb.png)
![completerestore](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/n1z72h3xrsilnbgsn74n.png)

- Configure storage access restriction to selected Virtual Network & Subnet

> Virtual networks -> Create -> [select resource group] -> [name virtual network] -> Review + create -> Create -> Go to resource -> Settings -> Subnets -> default -> Service endpoints -> Services -> **Microsoft.Storage** -> Save

![Vnet](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/q4v5clfg0v0rvsldflpc.png)
![IPAddressTab](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9z8wtkzk7hpe2kda90nz.png)
![ServiceEP](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/6dtbnlb0ctpl3c3q31b3.png)
![ReviewVnet](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/97dvxa8box1n1viptcx4.png)
![ValidateVnet](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/uufg7ff6eedtszht75az.png)
![deployment complete](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/xb2we3q8lydf7j07dqnw.png)

- Restrict storage account to only access from selected Virtual Network

> Return to files storage account -> Security + networking -> Networking -> Public network access -> Enabled from selected virtual networks and IP addresses -> Virtual networks -> Add existing virtual network -> [select virtual network and subnet] -> Add -> Save

![navigatetosa](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/pr10mmk7cjaoqmmn43ll.png)
![network](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/qonp2ixkzntmc2nls2l0.png)
![SelectNetwork](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/g7hzewoxq3oo14449400.png)
![ready](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/zgc2aqef923syms9cg4j.png)

- Verify Access Restriction

> Storage browser -> [navigate to file share] -> Verify message ("not authorized to perform this operation")

![Restriction](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/r55kxsb1zobhtqvvh9rk.png)

### 🔐 Securing Azure Blob Storage for App Development Using Key Vault, Encryption, Managed Identities & Immutable Protection

In this task, we’re configuring a **Secure Azure Blob Storage** solution to support the development of a new internal application. The focus is on enforcing strict **access controls using managed identities and access keys**, while applying **role-based access control (RBAC)** to streamline permissions across development and testing environments. To safeguard critical test data, we’ll enable **immutable blob protection**, ensuring that once written, data cannot be altered or deleted during retention. This setup supports secure automation, identity-driven access, and robust data integrity—ideal for modern app development workflows that demand both agility and compliance.

![Arch5](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tr3spko8c41kilv4ny5u.png)

- Create Storage Account with **Infrastructure Encryption Enabled**

> Storage accounts -> + Create -> Resource group -> Create new -> [name your resource group] -> OK -> Storage account name -> [enter a name] -> Encryption Tab -> Enable infrastructure encryption -> Review + Create -> Create

![StorageAccEncrypt](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/u4jjjmx04ezmqta43qkt.png)
![Encryption](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/9t3xk22h1cro94tbf0vb.png)
![Review](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/8rittrxaswp2giojfyus.png)
![Deployment](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gdmrsq554ol51sie14bx.png)

- Create **User-Assigned Managed Identity**

> Managed identities -> Create -> [select your resource group] -> Name -> [give it a name] -> Review and create -> Create

![ManagedID](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rsn9pll2kgqtjpkieedq.png)
![MangedID](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/2zzffglyhidkm37hn7g6.png)
![ManagedID](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/2v7bfvgf2ga7sulvodim.png)
![MangagedID](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/khf49th651bvxphyey7c.png)

-  Add **Role Assignment** to Managed Identity

> Storage account -> Access Control (IAM) -> Add role assignment -> **Storage Blob Data Reader** -> Members -> Managed identity -> Select members -> [select your managed identity] -> Select -> Review + assign -> Review + assign

![RoleAssignment](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ud6xwhi60fpqc5aqfmj2.png)
![RoleAssignment](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1mgpvpv6mmufsf99gi0q.png)
![RoleAssignment](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jq2bqepgmv8ujecicdl0.png)
![RoleAssignment](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tmzk1mhghfatim91gd7q.png)
![RoleAssignment](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/wls5jqhxz4gtf2e1ofox.png)

- Assign **Key Vault Administrator** Role to User

> Resource groups -> [select your resource group] -> Access Control (IAM) -> Add role assignment -> Key Vault Administrator -> Members -> User, group, or service principal -> Select members -> [select your user account] -> Select -> Review + assign -> Review + assign  (**Activate Role**)

![KeyADMIN](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/55f94wfw5n6j7m7dbxuv.png)
![kEYaDMINROLE](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/j0qbboq23ldxzgmtwnlj.png)
![KeyAdminRole](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/j4cl4hu3kxg6pl9nck95.png)
![KeyAdmin](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/64p2g9v5vpk4hns7khkr.png)
![Activate](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/lrqo2t2sm1hx2n2zmh7s.png)
![Activate](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/67gf4gw9g0e8o8w058w4.png)
![Activate](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/xwknul7q9jmxxtd82dlb.png)

- Create **Key Vault** to Store Access Keys

> Key vaults -> Create -> [select your resource group] -> Name -> [provide a name] -> Access configuration -> Azure role-based access control (recommended) -> Review + create -> Create -> Go to resource -> Overview -> [verify soft-delete and purge protection are enabled]

![KeyVault](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/218xswf9dnoo7f9u93la.png)
![KeyVault](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vv9guuml4vzu737vbbmb.png)
![KeyVault](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/pug7o8oxyxi0zg8ljt58.png)
![KeyVault](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/wrr0p9un6etg42h7ivdn.png)
![Keyvault](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/0z1s4j4qqq260n2q6wf2.png)
![KeyVault](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vsj4sldiiqczaejnu89h.png)

- Create a **Customer Managed Key (CMK)**

> Key vault -> Objects -> Keys -> Generate/Import -> Name -> [name the key] -> Create

![cmk](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/we7uhlwg67niqev5fj18.png)
![CMK](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/udn6tvc1f22mwitd4gik.png)
![CMK](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/t6njrk7y39rhsimhb1cs.png)

- Assign **Key Vault Crypto Service Encryption User** Role to Managed Identity

> Resource groups -> [select your resource group] -> Access Control (IAM) -> Add role assignment -> Key Vault Crypto Service Encryption User -> Members -> Managed identity -> Select members -> [select your managed identity] -> Select -> Review + assign -> Review + assign

![kvcs](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3kk1moutj1vv282f5fck.png)
![kvcs](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/37ka10koaox019n54z25.png)
![kvcs](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/124t9sdw38sk51j10gdk.png)
![kvcs](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/o4qhrv4bxqzuaitrj5sq.png)
![kvcs](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/m6jldyfv0cmszo0qh1pi.png)

- Configure **Encryption** for Storage Account to use **Customer-Managed Keys (CMK)** in the Key Vault

> Return to storage account -> Security + networking -> Encryption -> Customer-managed keys -> Select a key vault and key -> [select your key vault and key] -> Identity type -> User-assigned -> Select an identity -> [select your managed identity] -> Add -> Save

![ENCMK](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/t0bsdmctj9s84jem5w2q.png)
![ENCMK](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/r4qywmc61phyy67wybyp.png)
![ENCMK](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/htwf46fiwcr2oxbutc1r.png)
![ENCMK](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/4v8umjiipl17vyd9irn4.png)
![ENCMK](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/dtl1nqgwx3yf2nxio3fv.png)

- Configure an **Immutable Policy (Time-based Retention) and Encryption Scope**

> Storage account -> Data storage -> Containers -> Create container -> hold -> Create -> [upload a file] -> Settings -> Access policy -> + Add policy -> Policy type -> time-based retention -> Retention period -> 5 days -> Save -> [try to delete file] -> [verify "failed to delete blobs" message]

![scope](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/d6kiblmdaeq4uz6pq07x.png)
![Upload](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/4y3c6nf1fl4g9le3ejey.png)
![scope](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1d2xsand1n4f3wkb17br.png)
![scope](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/cur6zpf4647efwcx34wv.png)

- Create and Apply **Encryption Scope** that enables infrastructure encryption to storage account

> Storage account -> Security + networking -> Encryption -> Encryption scopes -> Add -> Name -> [enter a name] -> Encryption type -> Microsoft-managed key -> Infrastructure encryption -> Enable -> Create -> [return to storage account] -> Create a new container -> Advanced -> Encryption scope -> [select your new scope]

![scope2](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/bz7y7wqoym6e6wnbdovi.png)
![scope2](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/72x4wqjjw26taea55rci.png)

- Clean up resources

> Resource groups -> [select your resource group] -> Delete resource group -> [type the resource group name] -> Delete

![CleanUp](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/3gypmsu55alqqstvu9iv.png)

### Conclusion

Across these five tasks, we’ve explored how Azure Storage can be tailored to meet a wide range of enterprise needs—from public content delivery and internal document protection to secure app development and departmental file sharing. Each scenario demonstrates how thoughtful configuration—whether through redundancy models like RA-GRS and ZRS, access control via RBAC and managed identities, or data protection features like snapshots, versioning, and immutability—can transform storage from a passive resource into a strategic asset.

By aligning storage architecture with business goals, security standards, and operational workflows, we not only meet technical requirements—we build solutions that scale, adapt, and protect. Whether you're designing for global reach or internal governance, Azure provides the flexibility and control to do it right.
