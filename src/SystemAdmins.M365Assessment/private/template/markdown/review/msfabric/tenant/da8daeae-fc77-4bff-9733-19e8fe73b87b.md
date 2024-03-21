## {{TITLE}}

{{DATE}}

###  Information

| ID     | Category     | Subcategory     | Review     |
| :----- | :----------- | --------------- | :--------- |
| {{ID}} | {{CATEGORY}} | {{SUBCATEGORY}} | {{REVIEW}} |

### Description

The Invite external users setting helps organizations choose whether new external users can be invited to the organization through Power BI sharing, permissions, and subscription experiences. This setting only controls the ability to invite through Power BI.

The recommended state is Enabled for a subset of the organization or Disabled.

### Technical explanation

Establishing and enforcing a dedicated security group prevents unauthorized access to Microsoft Fabric for guests collaborating in Azure that are new or assigned guest status from other applications. This upholds the principle of least privilege and uses role-based access control (RBAC). These security groups can also be used for tasks like conditional access, enhancing risk management and user accountability across the organization.

### Advised solution

1. Navigate to Microsoft Fabric https://app.powerbi.com/admin-portal

2. Select **Tenant settings**.

3. Scroll to **Export and Sharing settings**.

4. Set **Invite external users to your organization** to one of these states:
   - State 1: **Disabled**
   - State 2: **Enabled with Specific security groups** selected and defined.

### More information

- https://learn.microsoft.com/en-us/power-bi/admin/service-admin-portal-export-sharing
- https://learn.microsoft.com/en-us/power-bi/enterprise/service-admin-azure-ad-b2b#invite-guest-users


### Data