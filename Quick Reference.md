# Terraform Quick Reference
## Get Help
_**terraform -help**_ — Get a list of available commands for execution with descriptions. Can be used with any other subcommand to get more information.

**_terraform fmt -help_** — Display help options for the fmt command.

## Show Your Terraform Version
_**terraform version**_ — Shows the current version of your Terraform and notifies you if there is a newer version available for download.

## Format Your Terraform Code
This should be the first command you run after creating your configuration files to ensure your code is formatted using the HCL standards. This makes it easier to follow and aids collaboration.

_**terraform fmt**_ — Format your Terraform configuration files using the HCL language standard.

_**terraform fmt --recursive**_ — Also formats files in subdirectories

_**terraform fmt --diff**_ — Display differences between original configuration files and formatting changes.

**_terraform fmt --check_** — Useful in automation CI/CD pipelines, the check flag can be used to ensure the configuration files are formatted correctly, if not the exit status will be non-zero. If files are formatted correctly, the exit status will be zero.

## Initialize Your Directory
_**terraform init**_ — In order to prepare the working directory for use with Terraform, the terraform init command performs Backend Initialization, Child Module Installation, and Plugin Installation.

_**terraform init -get-plugins=false**_ — Initialize the working directory, do not download plugins.

_**terraform init -lock=false**_ — Initialize the working directory, don’t hold a state lock during backend migration.
**
_terraform init -input=false**_ — Initialize the working directory, and disable interactive prompts.

_**terraform init -migrate-state**_ — Reconfigure a backend, and attempt to migrate any existing state.

_**terraform init -verify-plugins=false**_ — Initialize the working directory, do not verify plugins for Hashicorp signature

See our detailed rundown of the terraform init command!

## Download and Install Modules
Note this is usually not required as this is part of the terraform init command.

_**terraform get**_ — Downloads and installs modules needed for the configuration.

_**terraform get -update**_ — Checks the versions of the already installed modules against the available modules and installs the newer versions if available.

## Validate Your Terraform Code
_**terraform validate**_ — Validates the configuration files in your directory, and does not access any remote state or services. terraform init should be run before this command.

## Plan Your Infrastructure
_**terraform plan**_ — Plan will generate an execution plan, showing you what actions will be taken without actually performing the planned actions.

_**terraform plan -out=<path>**_ — Save the plan file to a given path. Can then be passed to the terraform apply command.

_**terraform plan -destroy**_ — Creates a plan to destroy all objects, rather than the usual actions.

## Deploy Your Infrastructure
_**terraform apply**_ — Creates or updates infrastructure depending on the configuration files. By default, a plan will be generated first and will need to be approved before it is applied.

_**terraform apply -auto-approve**_ — Apply changes without having to interactively type ‘yes’ to the plan. Useful in automation CI/CD pipelines.

_**terraform apply <planfilename>**_ — Provide the file generated using the terraform plan -out command. If provided, Terraform will take the actions in the plan without any confirmation prompts.

_**terraform apply -lock=false**_ — Do not hold a state lock during the Terraform apply operation. Use with caution if other engineers might run concurrent commands against the same workspace.

_**terraform apply -parallelism=<n>**_ — Specify the number of operations run in parallel.

_**terraform apply -var="domainpassword=password123"**_ — Pass in a variable value.

_**terraform apply -var-file="varfile.tfvars"**_ — Pass in variables contained in a file.

_**terraform apply -target=”module.appgw.0"**_ — Apply changes only to the targeted resource.

## Destroy Your Infrastructure
_**terraform destroy**_ — Destroys the infrastructure managed by Terraform.

_**terraform destroy -target=”module.appgw.0"**_ — Destroy only the targeted resource.

_**terraform destroy -auto-approve**_ — Destroys the infrastructure without having to interactively type ‘yes’ to the plan. Useful in automation CI/CD pipelines.

## ‘Taint’ or ‘Untaint’ Your Resources
Use the taint command to mark a resource as not fully functional. It will be deleted and re-created.

_**terraform taint vm1.name**_ — Taint a specified resource instance.

_**terraform untaint vm1.name**_ — Untaint the already tainted resource instance.

## Refresh the State File
_**terraform refresh**_ — Modifies the state file with updated metadata containing information on the resources being managed in Terraform. Will not modify your infrastructure.

## View Your State File
_**terraform show**_ — Shows the state file in a human-readable format.

_**terraform show <path to statefile>**_ — If you want to read a specific state file, you can provide the path to it. If no path is provided, the current state file is shown.

### Manipulate Your State File
_**terraform state**_ — One of the following subcommands must be used with this command in order to manipulate the state file.

_**terraform state list**_ — Lists out all the resources that are tracked in the current state file.

_**terraform state mv**_ — Moves an item in the state, for example, this is useful when you need to tell Terraform that an item has been renamed, e.g. terraform state mv vm1.oldname vm1.newname

_**terraform state pull > state.tfstate**_ — Gets the current state and outputs it to a local file.
**
_terraform state push**_ — Update remote state from the local state file.

_**terraform state replace-provider hashicorp/azurerm customproviderregistry/azurerm**_ — Replace a provider, useful when switching to using a custom provider registry.

_**terraform state rm**_ — Remove the specified instance from the state file. Useful when a resource has been manually deleted outside of Terraform.

_**terraform state show <resourcename>**_ — Show the specified resource in the state file.

## Import Existing Infrastructure into Your Terraform State
_**terraform import vm1.name -i id123**_ — Import a VM with id123 into the configuration defined in the configuration files under vm1.name.

_**terraform import vm1.name -i id123 -allow-missing-config**_ — Import and allow if the configuration block does not exist.

See our terraform import tutorial for more details.

## Get Provider Information
_**terraform providers**_ — Displays a tree of providers used in the configuration files and their requirements.

## Manage Your Workspaces
_**terraform workspace**_ — One of the following subcommands must be used with the workspace command. Workspaces can be useful when an engineer wants to test a slightly different version of the code. It is not recommended to use Workspaces to isolate or separate the same infrastructure between different development stages, e.g. Dev / UAT / Production, or different internal teams.

_**terraform workspace show**_ — Show the name of the current workspace.

_**terraform workspace list**_ — List your workspaces.

_**terraform workspace select <workspace name>**_ — Select a specified workspace.

_**terraform workspace new <workspace name>**_ — Create a new workspace with a specified name.

_**terraform workspace delete <workspace name>**_ — Delete a specified workspace.

## View Your Outputs
_**terraform output**_ — Lists all the outputs currently held in your state file. These are displayed by default at the end of a terraform apply, this command can be useful if you want to view them independently.

_**terraform output -state=<path to state file>**_ — Lists the outputs held in the specified state file.

_**terraform output -json**_ — Lists the outputs held in your state file in JSON format to make them machine-readable.

_**terraform output vm1_public_ip**_ — List a specific output held in your state file.

## Release a Lock on Your Workspace
_**terraform force-unlock <lock_id>**_ — Remove the lock with the specified lock ID from your workspace. Useful when a lock has become ‘stuck’, usually after an incomplete Terraform run.

## Log In and Out to a Remote Host (Terraform Cloud)
_**terraform login**_ — Grabs an API token for Terraform cloud (app.terraform.io) using your browser.

**terraform login <hostname>** — Log in to a specified host.
**
_terraform logout**_ — Removes the credentials that are stored locally after logging in, by default for Terraform Cloud (app.terraform.io).

_**terraform logout <hostname>**_ — Removes the credentials that are stored locally after logging in for the specified hostname.

## Produce a Dependency Diagram
_**terraform graph**_ — Produces a graph in DOT language showing the dependencies between objects in the state file. This can then be rendered by a program called Graphwiz (amongst others).

_**terraform graph -plan=tfplan**_ — Produces a dependency graph using a specified plan file (generated using terraform plan -out=tfplan).

_**terraform graph -type=plan**_ — Specifies the type of graph to output, either plan, plan-refresh-only, plan-destroy, or apply.

## Test Your Expressions
_**terraform console**_ — Allows testing and exploration of expressions on the interactive console using the command line. e.g. 1+2
