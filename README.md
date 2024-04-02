# Introduction
Welcome to the Microsoft 365 assessment PowerShell module!

This tool is designed to provide a comprehensive evaluation of your Microsoft 365 environment, ensuring alignment with industry-leading standards such as CIS (Center for Internet Security) benchmarks, Microsoft secure score and other best practices prevalent in the industry.

## :ledger: Index

- [About](#beginner-about)
- [Usage](#zap-usage)
  - [Installation](#electric_plug-installation)
  - [Commands](#package-commands)
- [Demo](#camera-demo)
- [FAQ](#question-faq)

##  :beginner: About
In today's digital landscape, organizations rely heavily on Microsoft 365 to facilitate their daily operations, collaboration, and communication needs. However, ensuring that your Microsoft 365 configuration adheres to best practices and security standards can be a daunting task. This is where this PowerShell module comes into play.

**Key Features:**

1. **Automated Assessment:** Our module conducts an automated assessment of your Microsoft 365 environment, scanning through various configurations, settings, and policies to evaluate compliance with established best practices.

2. **Benchmark Compliance:** Leveraging the guidelines provided by the Center for Internet Security (CIS) and others, our module assesses your Microsoft 365 setup against industry-recognized benchmarks, helping you identify areas of improvement and potential security risks.

3. **Comprehensive Reporting:** Upon completion of the assessment, our module generates detailed reports outlining findings, highlighting areas of compliance, non-compliance, and recommended actions to enhance the security and efficiency of your Microsoft 365 environment.

4. **Remediation:** Step-by-step instructions will be provided on how to remediate potential findings gathered by the module.

An example of report generated [can be found here](https://github.com/System-Admins/m365assessment/blob/main/example/report/Contoso%20-%20Microsoft%20365%20Assessment.pdf).

## :zap: Usage
To get started with the Microsoft 365 assessment module, simply follow the instructions outlined in the documentation provided in this repository. You'll find detailed guidance on installation, configuration, and usage, enabling you to seamlessly integrate the module into your existing workflows.

###  :electric_plug: Installation

Before installing the module, the following prerequisites must be fulfilled:

- [ ] **PowerShell 7** installed, [see this for more information](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4).
- [ ] You must be a [**Global administrator** in Microsoft 365](https://learn.microsoft.com/en-us/microsoft-365/admin/add-users/assign-admin-roles?view=o365-worldwide#assign-a-user-to-an-admin-role-from-active-users).
- [ ] Able to execute PowerShell on your local machine.
- [ ] SharePoint Online license assigned to your user (this is required by Pnp.PowerShell).
- [ ] Microsoft Fabric license assigned to your user (this is required by the Fabric API).

###  :package: Commands
1. To install the module run the following in a PowerShell 7 session:

   ```powershell
   Install-Module -Name SystemAdmins.M365Assessment -Scope CurrentUser -Force
   ```

2. Import the module in the PowerShell 7 session.

   ```powershell
   Import-Module -Name SystemAdmins.M365Assessment
   ```

3. Now install all dependencies:

   ```powershell
   Install-M365Dependency
   ```

   > **Note:** After installing the dependencies, you need to close the PowerShell session and open a new. This is due to Microsoft not handling the assemblies correctly if multiple modules is installed. Hopefully this is sorted in the future by Microsoft.

4. Open a new PowerShell 7 session, and connect to the Microsoft 365 tenant.

   ```powershell
   Connect-M365Tenant
   ```

   > **Note:** This may prompt you up to 7 times for username/password, please make sure to follow the instructions in the PowerShell session. You also need to consent to the "Pnp.PowerShell" and "Microsoft Graph" module accessing your tenant. If a browser dont open, or it hangs, cancel the operation and rerun the "Connect-M365Tenant" cmdlet again.

5. After a successful connection to the Microsoft 365 tenant, run the assessment.

   ```powershell
   Invoke-M365Assessment
   ```


5. It will automatically open the asessment in your default browser, and output the HTML report zipped  "***yyyyMMdd*_m365assessment.zip**" on the users desktop.

6. When you are finished with running the assessment you can run the following to logout from the Microsoft 365 in the PowerShell 7 session.

   ```powershell
   Disconnect-M365Tenant
   ```



## :camera: ​Demo

Link to a small video (in GIF-format) with the module in action, can be found [here](example/usage/SystemAdmins.M365Assessment.gif) (if the GIF don't load below).

![Demo](example/usage/SystemAdmins.M365Assessment.gif)

## :question: FAQ

- **Are the module modifying anything in my Microsoft 365 tenant?**

  No, it only reads data and don't modify anything

- **Why can't I use a service principal (Entra ID app) to connect to the different services for Microsoft 365 used by the module?**

  Because the module uses undocumented APIs to get data needed for the assessment that are not supported without user_impersonation. Hopefully Microsoft will include all the information using Microsoft Graph or other tools in the future.

- **What other PowerShell module is SystemAdmins.M365Assessment module using?**

  Microsoft.Graph.Authentication

  Microsoft.Graph.Groups

  Microsoft.Graph.Users

  Microsoft.Graph.Identity.DirectoryManagement

  Microsoft.Graph.Identity.SignIns

  Microsoft.Graph.Identity.Governance

  Microsoft.Graph.Beta.Identity.DirectoryManagement

  Microsoft.Graph.Beta.Reports

  Microsoft.Graph.Reports

  Az.Accounts

  Az.Resources

  ExchangeOnlineManagement

  PnP.PowerShell

  MicrosoftTeams

- **Why is it free?**

  Why shouldn't it be.
