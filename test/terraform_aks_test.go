package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
)

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestTerraformBasicExample(t *testing.T) {
	t.Parallel()

	fixtureFolder := "./fixture"

	// At the end of the test, clean up any resources that were created
	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
		terraform.Destroy(t, terraformOptions)
	})

	// Deploy the example
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(t, fixtureFolder)

		// Save the options so later test stages can use them
		test_structure.SaveTerraformOptions(t, fixtureFolder, terraformOptions)

		// This will init and apply the resources and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	// Check whether the length of output meets the requirement
	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)

		// Kubenet
		aks_kubenet_aks_id := terraform.Output(t, terraformOptions, "aks_kubenet_aks_id")
		if len(aks_kubenet_aks_id) <= 0 {
			t.Fatal("aks_kubenet_aks_id is empty.")
		}

		aks_kubenet_kube_config_raw := terraform.Output(t, terraformOptions, "aks_kubenet_kube_config_raw")
		if len(aks_kubenet_kube_config_raw) <= 0 {
			t.Fatal("aks_kubenet_kube_config_raw is empty.")
		}

		// Private
		aks_private_aks_id := terraform.Output(t, terraformOptions, "aks_private_aks_id")
		if len(aks_private_aks_id) <= 0 {
			t.Fatal("aks_private_aks_id is empty.")
		}

		aks_private_identity := terraform.Output(t, terraformOptions, "aks_private_identity")
		if len(aks_private_identity) <= 0 {
			t.Fatal("aks_private_identity is empty.")
		}
	})
}

func configureTerraformOptions(t *testing.T, fixtureFolder string) *terraform.Options {

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: fixtureFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{},
	}

	return terraformOptions
}
