package unit

import (
	"os"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestDisableLogAnalyticsWorkspaceShouldNotCreateWorkspaceNorSolution(t *testing.T) {
	vars := dummyRequiredVariables()
	vars["log_analytics_workspace_enabled"] = false
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
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
		id:   "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.OperationalInsights/workspaces/workspace1",
		name: "workspace1",
	}
	vars["log_analytics_workspace_enabled"] = true
	vars["log_analytics_workspace"] = map[string]interface{}{
		"id":   dummyWorkspace.id,
		"name": dummyWorkspace.name,
	}
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
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
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
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
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
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
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		createSolution, ok := output["create_analytics_solution"].(bool)
		assert.True(t, ok)
		assert.False(t, createSolution)
	})
}

func TestAutomaticUpgrades(t *testing.T) {
	testCases := map[string]struct {
		name string
		vars map[string]interface{}
	}{
		"automatic_patches_no_patch_number_specified": {
			vars: map[string]interface{}{
				"prefix":                    "foo",
				"resource_group_name":       "bar",
				"automatic_channel_upgrade": "patch",
				"kubernetes_version":        "1.25",
				"orchestrator_version":      "1.25",
			},
		},
		"automatic_upgrades_to_newest_version": {
			vars: map[string]interface{}{
				"prefix":                    "foo",
				"resource_group_name":       "bar",
				"automatic_channel_upgrade": "rapid",
			},
		},
		"automatic_upgrades_to_stable_version": {
			vars: map[string]interface{}{
				"prefix":                    "foo",
				"resource_group_name":       "bar",
				"automatic_channel_upgrade": "stable",
			},
		},
	}
	t.Parallel()

	for name, tt := range testCases {
		t.Run(name, func(t *testing.T) {
			test_helper.RunUnitTest(t, "../../", "unit-test-fixture",
				terraform.Options{
					Upgrade: false,
					Vars:    tt.vars,
				},
				func(t *testing.T, output test_helper.TerraformOutput) {
					upgrades, ok := output["automatic_channel_upgrade_check"].(bool)
					assert.True(t, ok)
					assert.True(t, upgrades)
				})
		})
	}
}

func TestInvalidVarsForAutomaticUpgrades(t *testing.T) {
	testCases := map[string]struct {
		name string
		vars map[string]interface{}
	}{
		"automatic_patches_with_patch_number_specified": {
			vars: map[string]interface{}{
				"prefix":                    "foo",
				"resource_group_name":       "bar",
				"automatic_channel_upgrade": "patch",
				"kubernetes_version":        "1.25.3",
				"orchestrator_version":      "1.25.3",
			},
		},
		"automatic_upgrades_to_newest_version_with_fixed_versions": {
			vars: map[string]interface{}{
				"prefix":                    "foo",
				"resource_group_name":       "bar",
				"automatic_channel_upgrade": "rapid",
				"kubernetes_version":        "1.25.3",
				"orchestrator_version":      "1.24",
			},
		},
		"automatic_upgrades_to_stable_version_with_orchestrator": {
			vars: map[string]interface{}{
				"prefix":                    "foo",
				"resource_group_name":       "bar",
				"automatic_channel_upgrade": "stable",
				"orchestrator_version":      "1.24",
			},
		},
	}
	t.Parallel()

	for name, tt := range testCases {
		t.Run(name, func(t *testing.T) {
			test_helper.RunUnitTest(t, "../../", "unit-test-fixture",
				terraform.Options{
					Upgrade: false,
					Vars:    tt.vars,
				},
				func(t *testing.T, output test_helper.TerraformOutput) {
					upgrades, ok := output["automatic_channel_upgrade_check"].(bool)
					assert.True(t, ok)
					assert.False(t, upgrades)
				})
		})
	}
}

func TestScaleDownDelayAfterDeleteNotSetShouldUseScanInterval(t *testing.T) {
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    dummyRequiredVariables(),
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		scaleDownDelayAfterDelete, ok := output["auto_scaler_profile_scale_down_delay_after_delete"].(string)
		assert.True(t, ok)
		scanInterval, ok := output["auto_scaler_profile_scan_interval"].(string)
		assert.True(t, ok)
		assert.Equal(t, scanInterval, scaleDownDelayAfterDelete)
	})
}

func TestScaleDownDelayAfterDeleteSetShouldUseVar(t *testing.T) {
	vars := dummyRequiredVariables()
	vars["auto_scaler_profile_scale_down_delay_after_delete"] = "15s"
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		scaleDownDelayAfterDelete, ok := output["auto_scaler_profile_scale_down_delay_after_delete"].(string)
		assert.True(t, ok)
		assert.Equal(t, "15s", scaleDownDelayAfterDelete)
	})
}

func Test_DisabledLogAnalyticsWorkspaceShouldNotQueryDSForWorkspaceLocation(t *testing.T) {
	vars := dummyRequiredVariables()
	vars["log_analytics_workspace_enabled"] = false
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		r := output["query_datasource_for_log_analytics_workspace_location"].(bool)
		assert.False(t, r)
	})
}

func Test_NullLogAnalyticsWorkspaceVariableShouldNotQueryDSForWorkspaceLocation(t *testing.T) {
	vars := dummyRequiredVariables()
	vars["log_analytics_workspace_enabled"] = true
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade: false,
		Vars:    vars,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		r := output["query_datasource_for_log_analytics_workspace_location"].(bool)
		assert.False(t, r)
	})
}

func Test_LogAnalyticsWorkspaceWithLocationShouldNotQueryDSForWorkspaceLocation(t *testing.T) {
	vars := dummyRequiredVariables()
	vars["log_analytics_workspace_enabled"] = true
	vars["log_analytics_workspace"] = map[string]any{
		"id":       "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.OperationalInsights/workspaces/workspace1",
		"name":     "dummyName",
		"location": "dummyLocation",
	}
	varFile := test_helper.VarsToFile(t, vars)
	defer func() {
		_ = os.Remove(varFile)
	}()
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade:  false,
		VarFiles: []string{varFile},
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		r := output["query_datasource_for_log_analytics_workspace_location"].(bool)
		assert.False(t, r)
	})
}

func Test_LogAnalyticsWorkspaceWithoutLocationShouldQueryDSForWorkspaceLocation(t *testing.T) {
	vars := dummyRequiredVariables()
	vars["log_analytics_workspace_enabled"] = true
	vars["log_analytics_workspace"] = map[string]any{
		"id":   "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.OperationalInsights/workspaces/workspace1",
		"name": "dummyName",
	}
	varFile := test_helper.VarsToFile(t, vars)
	defer func() {
		_ = os.Remove(varFile)
	}()
	test_helper.RunUnitTest(t, "../../", "unit-test-fixture", terraform.Options{
		Upgrade:  false,
		VarFiles: []string{varFile},
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		r := output["query_datasource_for_log_analytics_workspace_location"].(bool)
		assert.True(t, r)
	})
}

func dummyRequiredVariables() map[string]interface{} {
	return map[string]interface{}{
		"prefix":              "foo",
		"resource_group_name": "bar",
	}
}
