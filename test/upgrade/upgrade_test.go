package upgrade

import (
	"os"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExampleUpgrade_startup(t *testing.T) {
	currentRoot, err := test_helper.GetCurrentModuleRootPath()
	if err != nil {
		t.FailNow()
	}
	currentMajorVersion, err := test_helper.GetCurrentMajorVersionFromEnv()
	if err != nil {
		t.FailNow()
	}
	vars := map[string]interface{}{
		"client_id":     "",
		"client_secret": "",
	}
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		vars["managed_identity_principal_id"] = managedIdentityId
	}
	test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-aks", "examples/startup", currentRoot, terraform.Options{
		Upgrade: true,
		Vars:    vars,
	}, currentMajorVersion)
}

func TestExampleUpgrade_without_monitor(t *testing.T) {
	currentRoot, err := test_helper.GetCurrentModuleRootPath()
	if err != nil {
		t.FailNow()
	}
	currentMajorVersion, err := test_helper.GetCurrentMajorVersionFromEnv()
	if err != nil {
		t.FailNow()
	}
	var vars map[string]interface{}
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		vars = map[string]interface{}{
			"managed_identity_principal_id": managedIdentityId,
		}
	}
	test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-aks", "examples/without_monitor", currentRoot, terraform.Options{
		Upgrade: true,
		Vars:    vars,
	}, currentMajorVersion)
}

func TestExampleUpgrade_named_cluster(t *testing.T) {
	currentRoot, err := test_helper.GetCurrentModuleRootPath()
	if err != nil {
		t.FailNow()
	}
	currentMajorVersion, err := test_helper.GetCurrentMajorVersionFromEnv()
	if err != nil {
		t.FailNow()
	}
	var vars map[string]interface{}
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		vars = map[string]interface{}{
			"managed_identity_principal_id": managedIdentityId,
		}
	}
	test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-aks", "examples/named_cluster", currentRoot, terraform.Options{
		Upgrade: true,
		Vars:    vars,
	}, currentMajorVersion)
}

func TestExampleUpgrade(t *testing.T) {
	examples := []string{
		"examples/with_acr",
		"examples/multiple_node_pools",
	}
	for _, e := range examples {
		example := e
		t.Run(example, func(t *testing.T) {
			currentRoot, err := test_helper.GetCurrentModuleRootPath()
			if err != nil {
				t.FailNow()
			}
			currentMajorVersion, err := test_helper.GetCurrentMajorVersionFromEnv()
			if err != nil {
				t.FailNow()
			}
			test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-aks", example, currentRoot, terraform.Options{
				Upgrade: true,
			}, currentMajorVersion)
		})
	}
}
