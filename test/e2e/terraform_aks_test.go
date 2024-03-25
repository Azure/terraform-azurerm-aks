package e2e

import (
	"fmt"
	"io"
	"os"
	"regexp"
	"strings"
	"testing"
	"time"

	"github.com/hashicorp/go-retryablehttp"

	"github.com/stretchr/testify/require"

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
		assertOutputNotEmpty(t, output, "test_cluster_portal_fqdn")
		assertOutputNotEmpty(t, output, "test_cluster_private_fqdn")
	})
}

func assertOutputNotEmpty(t *testing.T, output test_helper.TerraformOutput, name string) {
	o, ok := output[name].(string)
	assert.True(t, ok)
	assert.NotEqual(t, "", o)
}

func TestExamplesWithoutMonitor(t *testing.T) {
	vars := make(map[string]interface{}, 0)
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
	vars := make(map[string]interface{})
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

func TestExamplesWithoutAssertion(t *testing.T) {
	examples := []string{
		"examples/with_acr",
		"examples/multiple_node_pools",
	}
	for _, e := range examples {
		example := e
		t.Run(example, func(t *testing.T) {
			test_helper.RunE2ETest(t, "../../", example, terraform.Options{
				Upgrade: true,
			}, nil)
		})
	}
}

func TestExamples_differentLocationForLogAnalyticsSolution(t *testing.T) {
	vars := make(map[string]any, 0)
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		vars = map[string]any{
			"managed_identity_principal_id": managedIdentityId,
		}
	}
	vars["log_analytics_workspace_location"] = "eastus2"
	test_helper.RunE2ETest(t, "../../", "examples/named_cluster", terraform.Options{
		Upgrade: true,
		Vars:    vars,
	}, nil)
}

func TestExamples_applicationGatewayIngress(t *testing.T) {
	useExistingAppGw := []struct {
		useBrownFieldAppGw        bool
		bringYourOwnVnet          bool
		createRoleBindingForAppGw bool
	}{
		{
			bringYourOwnVnet:          true,
			useBrownFieldAppGw:        true,
			createRoleBindingForAppGw: true,
		},
		{
			bringYourOwnVnet:          true,
			useBrownFieldAppGw:        false,
			createRoleBindingForAppGw: true,
		},
		{
			bringYourOwnVnet:          false,
			useBrownFieldAppGw:        false,
			createRoleBindingForAppGw: false,
		},
	}
	for _, u := range useExistingAppGw {
		t.Run(fmt.Sprintf("useExistingAppGw %t %t %t", u.bringYourOwnVnet, u.useBrownFieldAppGw, u.createRoleBindingForAppGw), func(t *testing.T) {
			test_helper.RunE2ETest(t, "../../", "examples/application_gateway_ingress", terraform.Options{
				Upgrade: true,
				Vars: map[string]interface{}{
					"bring_your_own_vnet":                             u.bringYourOwnVnet,
					"use_brown_field_application_gateway":             u.useBrownFieldAppGw,
					"create_role_assignments_for_application_gateway": u.createRoleBindingForAppGw,
				},
				MaxRetries:         20,
				TimeBetweenRetries: time.Minute,
				RetryableTerraformErrors: map[string]string{
					".*is empty list of object.*": "the ingress hasn't been created, need more time",
				},
			}, func(t *testing.T, output test_helper.TerraformOutput) {
				url, ok := output["ingress_endpoint"].(string)
				require.True(t, ok)
				html, err := getHTML(url)
				require.NoError(t, err)
				if strings.Contains(html, "Welcome to .NET") {
					return
				}
			})
		})
	}
}

func getHTML(url string) (string, error) {
	client := retryablehttp.NewClient()
	client.RetryMax = 10
	resp, err := client.Get(url)
	if err != nil {
		return "", err
	}
	defer func() {
		_ = resp.Body.Close()
	}()

	bytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	return string(bytes), nil
}
