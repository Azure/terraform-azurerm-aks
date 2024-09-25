REMOTE_SCRIPT := "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/scripts"

fmt:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/fmt.sh" | bash

fumpt:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/fumpt.sh" | bash

gosec:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/gosec.sh" | bash

tffmt:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/tffmt.sh" | bash

tffmtcheck:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/terraform-fmt.sh" | bash

tfvalidatecheck:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/terraform-validate.sh" | bash

terrafmtcheck:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/terrafmt-check.sh" | bash

gofmtcheck:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/gofmtcheck.sh" | bash
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/fumptcheck.sh" | bash

golint:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/run-golangci-lint.sh" | bash

tflint:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/run-tflint.sh" | bash

lint: golint tflint gosec

checkovcheck:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/checkovcheck.sh" | bash

checkovplancheck:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/checkovplancheck.sh" | bash

fmtcheck: gofmtcheck tfvalidatecheck tffmtcheck terrafmtcheck

pr-check: depscheck fmtcheck lint unit-test checkovcheck

unit-test:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/run-unit-test.sh" | bash

e2e-test:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/run-e2e-test.sh" | bash

version-upgrade-test:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/version-upgrade-test.sh" | bash

terrafmt:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/terrafmt.sh" | bash

pre-commit: tffmt terrafmt depsensure fmt fumpt generate

depsensure:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/deps-ensure.sh" | bash

depscheck:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/deps-check.sh" | bash

generate:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/generate.sh" | bash

gencheck:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/gencheck.sh" | bash

yor-tag:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/yor-tag.sh" | bash

autofix:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/autofix.sh" | bash

test: fmtcheck
	@TEST=$(TEST) curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/run-gradually-deprecated.sh" | bash
	@TEST=$(TEST) curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/run-test.sh" | bash

build-test:
	curl -H 'Cache-Control: no-cache, no-store' -sSL "$(REMOTE_SCRIPT)/build-test.sh" | bash

.PHONY: fmt fmtcheck pr-check