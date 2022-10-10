package unit

import (
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestDisableLogAnalyticsWorkspaceShouldNotCreateWorkspaceNorSolution(t *testing.T) {
	vars := dummyRequiredVariables()
	vars["log_analytics_workspace_enabled"] = false
	test_helper.RunE2ETest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		createSolution, ok := output["create_analytics_solution"].(bool)
		assert.True(t, ok)
		assert.False(t, createSolution)
		createWorkspace, ok := output["create_analytics_workspace"].(bool)
		assert.True(t, ok)
		assert.False(t, createWorkspace)
		_, ok = output["log_analytics_workspace"]
		assert.False(t, ok)
	})
}

func TestLogAnalyticsWorkspaceEnabledButWorkspaceIdProvidedShouldNotCreateWorkspace(t *testing.T) {
	vars := dummyRequiredVariables()
	dummyWorkspace := struct {
		id   string
		name string
	}{
		id:   "dummyId",
		name: "dummyName",
	}
	vars["log_analytics_workspace_enabled"] = true
	vars["log_analytics_workspace"] = map[string]interface{}{
		"id":   dummyWorkspace.id,
		"name": dummyWorkspace.name,
	}
	test_helper.RunE2ETest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		createWorkspace, ok := output["create_analytics_workspace"].(bool)
		assert.True(t, ok)
		assert.False(t, createWorkspace)
		workspace, ok := output["log_analytics_workspace"].(map[string]interface{})
		assert.True(t, ok)
		assert.Equal(t, dummyWorkspace.id, workspace["id"])
		assert.Equal(t, dummyWorkspace.name, workspace["name"])
	})
}

func TestLogAnalyticsWorkspaceEnabledNoWorkspaceProvidedShouldCreateWorkspace(t *testing.T) {
	vars := dummyRequiredVariables()
	expected := struct {
		id   string
		name string
	}{
		id:   "azurerm_log_analytics_workspace_id",
		name: "azurerm_log_analytics_workspace_name",
	}
	vars["log_analytics_workspace_enabled"] = true
	test_helper.RunE2ETest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		createWorkspace, ok := output["create_analytics_workspace"].(bool)
		assert.True(t, ok)
		assert.True(t, createWorkspace)
		workspace, ok := output["log_analytics_workspace"].(map[string]interface{})
		assert.True(t, ok)
		assert.Equal(t, expected.id, workspace["id"])
		assert.Equal(t, expected.name, workspace["name"])
	})
}

func TestLogAnalyticsWorkspaceEnabledNoSolutionProvidedShouldCreateSolution(t *testing.T) {
	vars := dummyRequiredVariables()
	vars["log_analytics_workspace_enabled"] = true
	test_helper.RunE2ETest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		createSolution, ok := output["create_analytics_solution"].(bool)
		assert.True(t, ok)
		assert.True(t, createSolution)
	})
}

func TestLogAnalyticsWorkspaceEnabledSolutionProvidedShouldNotCreateSolution(t *testing.T) {
	vars := dummyRequiredVariables()
	vars["log_analytics_workspace_enabled"] = true
	vars["log_analytics_solution"] = map[string]interface{}{
		"id": "dummySolutionId",
	}
	test_helper.RunE2ETest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		createSolution, ok := output["create_analytics_solution"].(bool)
		assert.True(t, ok)
		assert.False(t, createSolution)
	})
}

func dummyRequiredVariables() map[string]interface{} {
	return map[string]interface{}{
		"prefix":              "foo",
		"resource_group_name": "bar",
	}
}
