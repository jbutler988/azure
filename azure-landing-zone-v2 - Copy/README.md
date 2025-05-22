# Landing Zone v2
## <b>This is the current standard landing zone deployment as of 2/2025. </b>

## The following outlined steps below shows the tasks required for setting up an Azure Landing Zone using Terraform and Azure DevOps using the source code developed.


<b>High Level Steps</b>


```
Create Management Groups Structure as per customer design
Create SPN with Owner permissions on hub MG and Policy contributor on Prod MG
Create Devops service connection to Hub MG
Create Agent Pool
Create PAT
Create Variable Group devops-region_abbrev-env
 Create TF_VAR_PAT
 Create TF_VAR_VPN_PSK
 Create TF_VAR_AGENT_POOL
Update Pipeline Variables
Update Settings.yaml
Create Pipeline and Run
 Comment out Firewall, VPN Gateway and Peering transit options until needed for faster deployment
Update DNS when DNS servers or resolvers are configured
Grant User Assigned Identity the following roles on Prod-MG for policy remediation
 Contributor
 Security Admin
 Log Analytics contributor
 Azure monitor contributor
Deploy firewall, VPN and remaining resources and policies
Set PaaS Firewall access to deny in settings.yaml (after dns is deployed)
```


Source code can be found here: - https://dev.azure.com/shi-dev/Cloud-Azure/_git/azure-landing-zone-v2 

Recorded Sessions for ALZ source code walkthrough and deployment can be found below:

https://shiandms.sharepoint.com/:f:/r/teams/CloudDeliveryTeam/Shared%20Documents/Collab-Azure/Knowledge%20Sharing/Azure%20Landing%20Zone%20Deployment?csf=1&web=1&e=5WfbHh 
