package e2e

import (
	"os"
	"regexp"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExamplesStartup(t *testing.T) {
	vars := map[string]interface{}{
		"client_id":     "",
		"client_secret": "",
	}
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		vars["managed_identity_principal_id"] = managedIdentityId
	}
	test_helper.RunE2ETest(t, "../../", "examples/startup", terraform.Options{
		Upgrade: true,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		aksId, ok := output["test_aks_id"].(string)
		assert.True(t, ok)
		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.ContainerService/managedClusters/.+"), aksId)
	})
}

func TestExamplesWithoutMonitor(t *testing.T) {
	var vars map[string]interface{}
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		vars = map[string]interface{}{
			"managed_identity_principal_id": managedIdentityId,
		}
	}
	test_helper.RunE2ETest(t, "../../", "examples/without_monitor", terraform.Options{
		Upgrade: true,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		aksId, ok := output["test_aks_without_monitor_id"].(string)
		assert.True(t, ok)
		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.ContainerService/managedClusters/.+"), aksId)
		identity, ok := output["test_aks_without_monitor_identity"].(map[string]interface{})
		assert.True(t, ok)
		assert.NotNil(t, identity)
		assert.NotEmptyf(t, identity, "identity should not be empty")
		principleId, ok := identity["principal_id"]
		assert.True(t, ok)
		assert.NotEqual(t, "", principleId)
	})
}

func TestExamplesNamedCluster(t *testing.T) {
	var vars map[string]interface{}
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		vars = map[string]interface{}{
			"managed_identity_principal_id": managedIdentityId,
		}
	}
	test_helper.RunE2ETest(t, "../../", "examples/named_cluster", terraform.Options{
		Upgrade: true,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		aksId, ok := output["test_aks_named_id"].(string)
		assert.True(t, ok)
		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.ContainerService/managedClusters/.+"), aksId)
		identity, ok := output["test_aks_named_identity"].(map[string]interface{})
		assert.True(t, ok)
		assert.NotNil(t, identity)
		assert.NotEmptyf(t, identity, "identity should not be empty")
		identityIds, ok := identity["identity_ids"]
		assert.True(t, ok)
		identityIdsArray := identityIds.([]interface{})
		assert.Equal(t, 1, len(identityIdsArray))
		assert.Regexp(t, regexp.MustCompile("/subscriptions/.+/resourceGroups/.+/providers/Microsoft.ManagedIdentity/userAssignedIdentities/.+"), identityIdsArray[0])
	})
}
