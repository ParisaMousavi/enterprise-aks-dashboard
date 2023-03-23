module "rg_name" {
  source             = "github.com/ParisaMousavi/az-naming//rg?ref=2022.10.07"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "resourcegroup" {
  # https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}
  source   = "github.com/ParisaMousavi/az-resourcegroup?ref=2022.10.07"
  location = var.location
  name     = module.rg_name.result
  tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

# ------------------------------------------
#  usage Monitoring
# ------------------------------------------
module "usage_query_name" {
  source   = "github.com/ParisaMousavi/az-naming//query?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

# resource "azurerm_log_analytics_saved_search" "example" {
#   name                       = "exampleSavedSearch"
#   log_analytics_workspace_id = "/subscriptions/e75710b2-d656-4ee7-bc64-d1b371656208/resourcegroups/projn-rg-monitoring-dev-weu/providers/microsoft.operationalinsights/workspaces/projn-log-monitoring-dev-weu"

#   category     = "exampleCategory"
#   display_name = "exampleDisplayName"
#   query        = "Usage | where TimeGenerated > startofday(ago(31d))| where IsBillable == true | where TimeGenerated > startofday(ago(31d)) | where IsBillable == true | summarize BillableDataGB = sum(Quantity) / 1000. by bin(TimeGenerated, 1d), DataType | render barchart"
# }

# module "vms_query" {
#   source            = "git::git@ssh.dev.azure.com:v3/havdb-labor/havdb/iac-azure-modules//terraform/modules/resource-graph-query?ref=v1.0.13"
#   resource_type     = "Microsoft.ResourceGraph/queries@2018-09-01-preview"
#   name              = module.vms_query_name.result
#   location          = var.location
#   resource_group_id = azurerm_resource_group.this.id
#   additional_tags = {
#     component = "Monitoring VMs Query"
#   }
#   json_body = data.template_file.vms_query.rendered
# }


# ------------------------------------------
#  Monitoring Dashboard
# ------------------------------------------
module "dashboard_name" {
  source             = "github.com/ParisaMousavi/az-naming//dashboard?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "dashboard" {
  source               = "github.com/ParisaMousavi/az-dashboard?ref=main"
  name                 = module.dashboard_name.result
  resource_group_name  = module.resourcegroup.name
  location             = var.location
  dashboard_properties = data.template_file.dashboard.rendered
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}
