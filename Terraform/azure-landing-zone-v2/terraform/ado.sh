#!/bin/bash
set -e

ADO_TOKEN=${ADO_TOKEN}
DEVOPS_ORG=${DEVOPS_ORG}
AGENT_POOL=${AGENT_POOL}

export AGENT_ALLOW_RUNASROOT=1



# Select a default agent version if one is not specified
if [ -z "$ADO_AGENT_VERSION" ]; then
  ADO_AGENT_VERSION=2.200.2
fi

# Verify Azure Pipelines token is set
if [ -z "${ADO_TOKEN}" ]; then
  echo 1>&2 "error: missing ADO_TOKEN environment variable"
  exit 1
fi

# Create the Downloads directory under the user's home directory
if [ -n "$HOME/Downloads" ]; then
  mkdir -p "$HOME/Downloads"
fi

# Download the agent package
curl https://vstsagentpackage.azureedge.net/agent/$ADO_AGENT_VERSION/vsts-agent-linux-x64-$ADO_AGENT_VERSION.tar.gz > $HOME/Downloads/vsts-agent-linux-x64-$ADO_AGENT_VERSION.tar.gz

# Create the working directory for the agent service to run jobs under
if [ -n "$ADO_WORK" ]; then
  mkdir -p "$ADO_WORK"
  chmod 777 "$ADO_WORK"
fi

# Create a working directory to extract the agent package to
mkdir -p $HOME/ado/agent
chmod 777 $HOME/ado/agent

# Move to the working directory
cd $HOME/ado/agent

# Check if Devops Agent has already been installed
if [ ! -f $HOME/ado/agent/svc.sh ]; then

# Extract the agent package to the working directory

tar zxvf $HOME/Downloads/vsts-agent-linux-x64-$ADO_AGENT_VERSION.tar.gz

echo $ADO_TOKEN
echo $AGENT_POOL
echo $DEVOPS_ORG

# Allows config to run as root
AGENT_ALLOW_RUNASROOT=1 ./config.sh --unattended \
  --agent $HOSTNAME \
  --url "https://dev.azure.com/${DEVOPS_ORG}" \
  --auth PAT \
  --token ${ADO_TOKEN} \
  --pool ${AGENT_POOL} \
  --replace \
  --acceptTeeEula & wait $!

# Install and start the agent service
    ./svc.sh install
    ./svc.sh start

# Install packages to run Terraform in Azure
    curl -sL https://aka.ms/InstallAzureCLIDeb |  bash
    apt-get update &&  apt-get install -y gnupg software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
    apt update
    apt-get install terraform
    apt-get -y install jq

else
    echo "Devops Agent has already been configured" 
    exit 0
fi