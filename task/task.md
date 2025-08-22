# Remove AzureRM v3 Support - Project Task Breakdown

## Project Context: Override Files Management

There are several `xxx_override.tf` files in both the root folder and the `v4` folder that need special handling:

### Root Folder Override Files
- These files contain **v3-only attributes** that are no longer supported in AzureRM v4
- **Action Required**: These files should be removed eventually as they are obsolete
- **Examples**: `extra_node_pool_override.tf`, `main_override.tf`, etc. in the root directory

### V4 Folder Override Files  
- These files contain **v4-specific configurations** that need to be preserved
- **Action Required**: These must be merged with the corresponding root module files
- **Location**: All override files in the `v4/` directory

### Important Merge Principle
**DO NOT modify variable names or value expressions during the merge process.**

For example: In `v4/extra_node_pool_override.tf` line 4, you will see:
```terraform
auto_scaling_enabled = each.value.enable_auto_scaling
```

When merging this into the root module:
- ✅ **KEEP**: The variable name `enable_auto_scaling` unchanged
- ✅ **KEEP**: The assignment expression `each.value.enable_auto_scaling` exactly as is
- ❌ **DO NOT**: Rename variables or modify the value expressions

This principle applies to all override file merges - preserve the original variable names and expressions to maintain compatibility.

## ⚠️ CRITICAL MULTI-AGENT COLLABORATION NOTICE ⚠️

**This is a multi-agent collaborative project. Each agent must remember their assigned role.**

### Agent Roles:
- **Manager**: Task breakdown, progress tracking, team coordination, safety oversight
- **Developer**: Implement specific code changes with preservation of source materials  
- **Reviewer**: Code change validation and authorized cleanup operations

### Agent Communication Protocol:

Each agent must run the following command to register itself fisrt, after it has read this `task.md`:

```
agent --role=<agent_role> --capabilities="<what's this agent good at>"
```

When you complete your current task OR need to hand off to another agent, you MUST call:
```
agent.exe -role <your_role> -yield-to <next_agent_role> -yield-msg "<command to next agent>"
```

# Query registered agents and their capabilities

```
agent --query-agents
```

- `agent.exe` is already installed and ready to use
- After calling yield, you will be blocked until someone calls you
- **Working Language**: English only
- **Special Role**: `people` represents human oversight. Yield to `people` when human decision/review is needed or when 4+ attempts at a task have failed

### Examples:
- Manager to Developer: `agent.exe -role Manager -yield-to Developer -yield-msg "Start Task 1.1: Process extra_node_pool.tf according to instructions"`
- Developer to Reviewer: `agent.exe -role Developer -yield-to Reviewer -yield-msg "Task 1.1 completed, please validate the merge of extra_node_pool_override.tf"`
- Reviewer to Manager: `agent.exe -role Reviewer -yield-to Manager -yield-msg "Task 1.1 validation passed, ready for next task assignment"`

### Documentation Rule:
**BEFORE yielding to another agent, you MUST document your work in `task/history.md`:**
- **What you accomplished** in this session
- **Important notes** for the next agent
- **Any issues encountered** or special considerations
- If `task/history.md` doesn't exist, create it
- **NEVER modify existing content** - only append to the end of the file

**Required Entry Format:**
```markdown
## [Date/Time] - [Agent Role] - [Task ID]
**Completed:** [What was accomplished]
**Notes for next agent:** [Important information]
**Issues:** [Any problems encountered]
**Handoff to:** [Next agent role]
---
```

### Agent Activation Rule:
**When you are called/activated, FIRST read `task/history.md` to understand:**
- What previous agents have accomplished
- Current project status and context
- Any issues or special considerations
- What you need to do next based on the latest situation

---

## Project Progress Tracking

### Overall Project Status
- **Project Start Date**: 2025-08-22
- **Target Completion Date**: 2025-08-24 (estimated, subject to validation)
- **Current Phase**: Phase 1 - Root Module File Processing
- **Overall Progress**: 0% - Project initialization completed, ready to begin Phase 1

### Task Progress Table
**Instructions for Manager**: 
1. **BEFORE creating this table**: Carefully analyze the current module structure by examining:
   - All files in the root directory (especially `*.tf` files)
   - All files in the `v4/` directory (especially `*_override.tf` files)
   - All example directories in `examples/` (both `*_v4` and non-`_v4` versions)
   - Check which override files actually exist vs. what's documented in the task breakdown
2. **Create the table below** based on actual files found, not assumptions
3. **Ask Reviewer to double-confirm** this table is correct before starting any work
4. **Update this table** after each task completion with status, assignee, completion date, and notes

**ANALYSIS COMPLETED**: Manager has analyzed the project structure and identified the following files for processing:

**Root Module Files to Update:** main.tf, extra_node_pool.tf, variables.tf, versions.tf
**V4 Override Files to Merge:** v4/main_override.tf, v4/extra_node_pool_override.tf, v4/variables_override.tf, v4/versions_override.tf
**Root Override Files to Remove:** main_override.tf, extra_node_pool_override.tf (after validation)
**Example Directories:** 7 pairs of examples (14 total) requiring v4 consolidation

| Task ID | Task Name | Phase | Assignee | Status | Start Date | Completion Date | Validation Status | Notes |
|---------|-----------|-------|----------|--------|------------|-----------------|-------------------|-------|
| 1.1 | Merge v4/extra_node_pool_override.tf into extra_node_pool.tf | 1 | TBD | Not Started | | | Pending | Critical file - requires careful variable preservation |
| 1.2 | Merge v4/main_override.tf into main.tf | 1 | TBD | Not Started | | | Pending | Core module file - high impact changes |
| 1.3 | Merge v4/variables_override.tf into variables.tf | 1 | TBD | Not Started | | | Pending | Variable definitions - affects all modules |
| 1.4 | Merge v4/versions_override.tf into versions.tf | 1 | TBD | Not Started | | | Pending | Provider version constraints |
| 2.1 | Create consolidated application_gateway_ingress example | 2 | TBD | Not Started | | | Pending | Merge _v4 into base, preserve functionality |
| 2.2 | Create consolidated multiple_node_pools example | 2 | TBD | Not Started | | | Pending | Complex configuration - requires thorough testing |
| 2.3 | Create consolidated named_cluster example | 2 | TBD | Not Started | | | Pending | Encryption and security configurations |
| 2.4 | Create consolidated startup example | 2 | TBD | Not Started | | | Pending | Basic configuration template |
| 2.5 | Create consolidated uai_and_assign_role_on_subnet example | 2 | TBD | Not Started | | | Pending | Identity and role assignment logic |
| 2.6 | Create consolidated with_acr example | 2 | TBD | Not Started | | | Pending | Container registry integration |
| 2.7 | Create consolidated without_monitor example | 2 | TBD | Not Started | | | Pending | Monitoring configuration variations |
| 3.1 | Manager authorization for cleanup operations | 3 | Manager | Not Started | | | Pending | Final safety checkpoint before deletions |
| 3.2 | Reviewer-authorized cleanup of obsolete files | 3 | Reviewer | Not Started | | | Pending | Delete old override files and v4 directory |


### Status Legend
- **Not Started**: Task has not begun
- **In Progress**: Task is currently being worked on
- **Completed**: Task finished, awaiting validation
- **Validated**: Task completed and verified by Reviewer
- **Approved**: Task approved by Manager
- **Blocked**: Task cannot proceed due to dependencies or issues

### Validation Status Legend
- **Pending**: Awaiting validation
- **In Review**: Currently being reviewed
- **Passed**: Validation successful
- **Failed**: Validation failed, requires rework
- **Approved**: Manager approved for next phase

### Phase Completion Checklist
**Manager must check off each phase before proceeding to the next:**

#### Phase 1 Completion Criteria
- [ ] All 4 root module files processed (Tasks 1.1-1.4)
- [ ] All changes validated by Reviewer
- [ ] No syntax errors in modified files
- [ ] All backup files created successfully
- [ ] Change documentation complete

#### Phase 2 Completion Criteria
- [ ] New example structure created (Task 2.1)
- [ ] All override files processed (Task 2.2)
- [ ] New example structure validated (Task 2.3)
- [ ] All examples syntax-checked
- [ ] No functionality regressions detected

#### Phase 3 Completion Criteria
- [ ] All validation reports reviewed by Manager
- [ ] Manager authorization granted (Task 3.1)
- [ ] Final cleanup completed (Task 3.2)
- [ ] Project structure verified and complete

### Risk and Issue Tracking
**Manager must document any risks or issues encountered:**

| Date | Task ID | Issue Description | Severity | Resolution | Status |
|------|---------|-------------------|----------|------------|--------|
| | | | | | |

### Change Log for Manager Updates
**Manager must log all table updates:**

| Date | Time | Updated By | Changes Made | Reason |
|------|------|------------|--------------|--------|
| 2025-08-22 | 14:45 | Manager | Created comprehensive task breakdown table with 13 tasks across 3 phases | Based on actual file analysis - found 4 v4 override files to merge and 7 example pairs to consolidate |
| 2025-08-22 | 14:45 | Manager | Added detailed Phase 1 instructions for root module file processing | Specified exact source/target files and safety requirements for each merge operation |
| 2025-08-22 | 14:45 | Manager | Added detailed Phase 2 instructions for example consolidation | Identified all 7 example pairs requiring v4 to base directory merging |
| 2025-08-22 | 14:45 | Manager | Added detailed Phase 3 instructions for cleanup operations | Specified authorization requirements and exact cleanup procedures with safety controls |

## Project Overview
Remove support for AzureRM v3 from the terraform-azurerm-aks module and migrate all configurations to support AzureRM v4 only.

## Role Definitions

### Manager
**Responsibilities:** Task breakdown, progress tracking, team coordination, safety oversight
**Work Details:**
- Break down work to individual file level with clear, actionable instructions
- Define task execution order and dependencies ensuring safety
- Monitor completion status of each subtask
- Coordinate work between Developer and Reviewer
- Ensure no critical files are deleted before validation is complete
- Make final decisions on file deletions only after successful validation
- **Safety Priority:** Preserve all source materials until final validation confirms success

### Developer
**Responsibilities:** Implement specific code changes with preservation of source materials
**Work Details:**
- Analyze `*_override.tf` files in the `v4` directory
- Merge override content into corresponding root module files
- Create backup copies before making changes
- Document all changes made for Reviewer validation
- **CRITICAL:** Never delete any override files, directories, or source materials
- **CRITICAL:** Never delete example directories - only create renamed copies
- Run initialization commands only after Manager approval
- Provide detailed change documentation for each modification

### Reviewer
**Responsibilities:** Code change validation and authorized cleanup operations
**Work Details:**
- Validate each subtask change made by Developer
- Compare original override files with merged results
- Check if override content is correctly merged
- Confirm configuration syntax and logic correctness
- Test functionality where possible
- **AUTHORITY:** Only Reviewer can authorize file deletions after validation
- **PROCESS:** Request Manager approval before any deletion operations
- Ensure changes do not introduce errors
- Document validation results for Manager review

## Task Breakdown

### Phase 1: Root Module File Processing

**MANAGER ANALYSIS COMPLETED**: The following v4 override files have been identified for merging into root module files:

#### Task 1.1: Merge v4/extra_node_pool_override.tf into extra_node_pool.tf
- **Assignee:** Developer
- **Priority:** HIGH - Critical node pool configuration file
- **Source File:** `v4/extra_node_pool_override.tf`
- **Target File:** `extra_node_pool.tf`
- **Safety Requirements:**
  - Create backup: `extra_node_pool.tf.backup-[timestamp]`
  - Preserve all variable names and expressions exactly as written
  - Validate syntax after merge completion
- **Instructions:**
  1. Create backup of target file before any modifications
  2. Analyze v4 override file content and structure  
  3. Merge override configurations into root module file
  4. Preserve original variable names (e.g., `enable_auto_scaling`) unchanged
  5. Keep value expressions (e.g., `each.value.enable_auto_scaling`) exactly as written
  6. Run `terraform validate` to confirm syntax correctness
  7. Document all changes made for Reviewer validation

#### Task 1.2: Merge v4/main_override.tf into main.tf
- **Assignee:** Developer  
- **Priority:** HIGH - Core module configuration
- **Source File:** `v4/main_override.tf`
- **Target File:** `main.tf`
- **Safety Requirements:**
  - Create backup: `main.tf.backup-[timestamp]`
  - This is the main AKS cluster resource - extreme caution required
  - Validate syntax and logical consistency after merge
- **Instructions:**
  1. Create backup of target file before any modifications
  2. Analyze v4 override file for AzureRM v4-specific configurations
  3. Merge override content while preserving existing structure
  4. Maintain all variable references and expressions unchanged
  5. Run `terraform validate` to confirm syntax correctness
  6. Document all changes made for Reviewer validation

#### Task 1.3: Merge v4/variables_override.tf into variables.tf
- **Assignee:** Developer
- **Priority:** HIGH - Affects all module interfaces
- **Source File:** `v4/variables_override.tf`
- **Target File:** `variables.tf`
- **Safety Requirements:**
  - Create backup: `variables.tf.backup-[timestamp]`
  - Variable changes affect all examples and dependent modules
  - Ensure no breaking changes to public interface
- **Instructions:**
  1. Create backup of target file before any modifications
  2. Analyze v4 override for new or modified variable definitions
  3. Merge variable definitions while preserving existing ones
  4. Maintain backward compatibility where possible
  5. Run `terraform validate` to confirm syntax correctness
  6. Document all changes made for Reviewer validation

#### Task 1.4: Merge v4/versions_override.tf into versions.tf
- **Assignee:** Developer
- **Priority:** MEDIUM - Provider version constraints
- **Source File:** `v4/versions_override.tf`
- **Target File:** `versions.tf`
- **Safety Requirements:**
  - Create backup: `versions.tf.backup-[timestamp]`
  - Version constraints affect all provider compatibility
  - Confirm AzureRM v4+ requirement is properly set
- **Instructions:**
  1. Create backup of target file before any modifications
  2. Analyze v4 override for updated provider version constraints
  3. Merge version requirements ensuring AzureRM v4+ only
  4. Remove any v3 compatibility constraints
  5. Run `terraform validate` to confirm syntax correctness
  6. Document all changes made for Reviewer validation

### Phase 2: Example Directory Cleanup and Processing

### Phase 2: Example Directory Cleanup and Processing

**MANAGER ANALYSIS COMPLETED**: Found 7 example pairs requiring consolidation from `_v4` versions into base versions:

#### Task 2.1: Create Consolidated application_gateway_ingress Example
- **Assignee:** Developer
- **Action:** Merge `examples/application_gateway_ingress_v4/` into `examples/application_gateway_ingress/`
- **Safety:** Create backup directory before modifications
- **Priority:** MEDIUM - Application Gateway integration example

#### Task 2.2: Create Consolidated multiple_node_pools Example  
- **Assignee:** Developer
- **Action:** Merge `examples/multiple_node_pools_v4/` into `examples/multiple_node_pools/`
- **Safety:** Create backup directory before modifications
- **Priority:** HIGH - Complex multi-pool configuration

#### Task 2.3: Create Consolidated named_cluster Example
- **Assignee:** Developer
- **Action:** Merge `examples/named_cluster_v4/` into `examples/named_cluster/`
- **Safety:** Create backup directory before modifications
- **Priority:** HIGH - Contains encryption and security configurations

#### Task 2.4: Create Consolidated startup Example
- **Assignee:** Developer
- **Action:** Merge `examples/startup_v4/` into `examples/startup/`
- **Safety:** Create backup directory before modifications
- **Priority:** LOW - Basic configuration template

#### Task 2.5: Create Consolidated uai_and_assign_role_on_subnet Example
- **Assignee:** Developer
- **Action:** Merge `examples/uai_and_assign_role_on_subnet_v4/` into `examples/uai_and_assign_role_on_subnet/`
- **Safety:** Create backup directory before modifications
- **Priority:** MEDIUM - Identity and role assignment logic

#### Task 2.6: Create Consolidated with_acr Example
- **Assignee:** Developer
- **Action:** Merge `examples/with_acr_v4/` into `examples/with_acr/`
- **Safety:** Create backup directory before modifications
- **Priority:** MEDIUM - Container registry integration

#### Task 2.7: Create Consolidated without_monitor Example
- **Assignee:** Developer
- **Action:** Merge `examples/without_monitor_v4/` into `examples/without_monitor/`
- **Safety:** Create backup directory before modifications
- **Priority:** LOW - Monitoring configuration variations

**General Instructions for All Example Tasks (2.1-2.7):**
1. **SAFETY FIRST**: Create backup of target directory as `[directory].backup-[timestamp]`
2. **Merge Strategy**: 
   - Compare files in both `base` and `_v4` versions
   - Merge `_v4` configurations into `base` directory files
   - Focus on merging `*_override.tf` and `providers_override.tf` files
   - Preserve any unique configurations from both versions
3. **File Processing Priority:**
   - Start with `providers_override.tf` (if exists)
   - Then process `main_override.tf` (if exists) 
   - Finally handle any other override files
4. **Validation Required:**
   - Run `terraform validate` in each updated example directory
   - Verify all variable references remain valid
   - Confirm no syntax errors introduced
5. **Documentation**: Record all changes made for Reviewer validation

#### Task 2.8: Validate All Consolidated Examples
- **Assignee:** Reviewer
- **Instructions:**
  - Perform syntax validation on all 7 updated example directories
  - Verify merge completeness by comparing with backed-up `_v4` versions
  - Confirm no functionality loss during consolidation
  - Test at least 2 examples with `terraform plan` if possible
  - Approve examples for Phase 3 or request Developer corrections

### Phase 3: Final Validation and Authorized Cleanup

### Phase 3: Final Validation and Authorized Cleanup

#### Task 3.1: Manager Authorization for Final Cleanup
- **Assignee:** Manager
- **Requirements for Authorization:**
  - All Phase 1 tasks (1.1-1.4) completed and validated by Reviewer
  - All Phase 2 tasks (2.1-2.8) completed and validated by Reviewer  
  - No syntax errors detected in any modified files
  - All backup files created and verified
  - Customer impact assessment confirms zero risk
  - Documentation complete in `task/history.md`
- **Authorization Criteria:**
  - [ ] Reviewer has approved all root module merges (Tasks 1.1-1.4)
  - [ ] Reviewer has approved all example consolidations (Tasks 2.1-2.7)
  - [ ] All target files pass `terraform validate` checks
  - [ ] All backup files are confirmed recoverable
  - [ ] No customer-facing functionality has been altered
  - [ ] Change documentation is complete and accurate
- **Instructions:**
  1. Review all Reviewer validation reports from Phases 1 and 2
  2. Verify completion status of all prerequisite tasks
  3. Confirm backup and rollback procedures are functional
  4. Assess overall customer impact (should remain zero)
  5. If all criteria met, authorize Reviewer to proceed with cleanup
  6. Document authorization decision and reasoning in history.md

#### Task 3.2: Authorized Final Cleanup
- **Assignee:** Reviewer (with Manager authorization)
- **Authority Required:** Manager must explicitly authorize this task
- **Instructions (Execute ONLY after Manager authorization):**
  1. **Delete Root Override Files** (v3-only configurations):
     - Remove `extra_node_pool_override.tf` from root directory
     - Remove `main_override.tf` from root directory
     - Confirm these files contained only v3 compatibility code
  
  2. **Delete V4 Directory and Contents**:
     - Remove entire `v4/` directory and all files within
     - Confirm all v4 configurations have been merged into root module
     - These files are now redundant after successful merge
  
  3. **Delete V4 Example Directories**:
     - Remove `examples/application_gateway_ingress_v4/`
     - Remove `examples/multiple_node_pools_v4/`
     - Remove `examples/named_cluster_v4/`
     - Remove `examples/startup_v4/`
     - Remove `examples/uai_and_assign_role_on_subnet_v4/`
     - Remove `examples/with_acr_v4/`
     - Remove `examples/without_monitor_v4/`
     - Confirm all configurations merged into corresponding base examples
  
  4. **Clean Up Backup Files** (ONLY after final validation):
     - Remove all `*.backup-[timestamp]` files created during the process
     - Remove all `*.backup-[timestamp]` directories created during the process
     - Only delete backups after Manager confirms project completion
  
  5. **Final Project Validation**:
     - Run `terraform validate` on root module one final time
     - Run `terraform validate` on at least 3 example directories
     - Confirm project structure is clean and functional
     - Document final cleanup completion in history.md

- **Emergency Rollback Procedure** (if issues discovered):
  - Stop all deletion operations immediately
  - Restore files from backup copies
  - Report issues to Manager for assessment
  - Do not proceed until Manager provides corrective instructions

- **Final Validation:** Manager confirms project structure is correct and complete

## Execution Order and Safety Protocol
1. **Phase 1**: Execute tasks 1.1 → 1.2 → 1.3 → 1.4 (sequential, with validation after each)
2. **Phase 2**: Execute tasks 2.1 → 2.2 → 2.3 (sequential, with validation after each)
3. **Phase 3**: Execute tasks 3.1 → 3.2 (sequential, with Manager authorization required)

## Safety Checkpoints and Authority Matrix
- **Developer Authority**: Modify files, create backups, document changes
- **Reviewer Authority**: Validate changes, delete backup files only after validation
- **Manager Authority**: Authorize all deletion operations, final cleanup decisions
- **Checkpoint Rule**: No deletion without prior validation and Manager authorization
- **Rollback Safety**: All original files preserved until final Manager authorization

## Quality and Safety Controls
- **Before each task**: Developer creates backups of files to be modified
- **After each file modification**: Developer performs self-check for syntax
- **Before Reviewer validation**: Developer provides detailed change documentation
- **During Reviewer validation**: Check configuration logic, syntax correctness, change completeness
- **Before any deletion**: Reviewer validation + Manager authorization required
- **Final safety check**: Manager reviews all validation reports before authorizing cleanup
- **Emergency protocol**: If any validation fails, stop process and restore from backups
