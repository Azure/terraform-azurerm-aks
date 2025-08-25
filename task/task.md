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
agent.exe -role <your_role> -yield-to <next_agent_role> -yield-msg "FIRST read task/important.md to refresh critical requirements, then <command to next agent>"
```

### ⚠️ CRITICAL YIELD MESSAGE RULE ⚠️
**EVERY yield message MUST begin with "FIRST read task/important.md to refresh critical requirements, then..."**

This ensures that each agent receiving control will:
1. Refresh their knowledge of critical discipline requirements
2. Maintain consistency in following safety protocols
3. Avoid mistakes due to forgotten or outdated information
4. Preserve the integrity of the collaborative process

**NO EXCEPTIONS:** All yield messages must follow this format to ensure proper knowledge transfer and safety compliance.

# Query registered agents and their capabilities

```
agent --query-agents
```

- `agent.exe` is already installed and ready to use
- After calling yield, you will be blocked until someone calls you
- **Working Language**: English only
- **Special Role**: `people` represents human oversight. Yield to `people` when human decision/review is needed or when 4+ attempts at a task have failed

### Examples:
- Manager to Developer: `agent.exe -role Manager -yield-to Developer -yield-msg "FIRST read task/important.md to refresh critical requirements, then start Task 1.1: Process extra_node_pool.tf according to instructions"`
- Developer to Reviewer: `agent.exe -role Developer -yield-to Reviewer -yield-msg "FIRST read task/important.md to refresh critical requirements, then validate Task 1.1 completion - merge of extra_node_pool_override.tf"`
- Reviewer to Manager: `agent.exe -role Reviewer -yield-to Manager -yield-msg "FIRST read task/important.md to refresh critical requirements, then note Task 1.1 validation passed, ready for next task assignment"`

### Documentation Rule:
**WHEN ACTIVATED FROM BLOCKING, you MUST FIRST read `task/important.md` to refresh critical discipline requirements.**

**BEFORE yielding to another agent, you MUST document your work in `task/history.md`:**
- **What you accomplished** in this session
- **Important notes** for the next agent
- **Any issues encountered** or special considerations
- If `task/history.md` doesn't exist, create it
- **NEVER modify existing content** - only append to the end of the file

⚠️ **CRITICAL HISTORY.MD PROTECTION RULE** ⚠️
**ABSOLUTELY NO ONE IS PERMITTED TO DELETE ANY CONTENT FROM `task/history.md`**
**ONLY APPENDING NEW ENTRIES IS ALLOWED - NO MODIFICATIONS, NO DELETIONS**
**VIOLATION OF THIS RULE WILL RESULT IN IMMEDIATE BANISHMENT TO SIBERIA FOR POTATO EXCAVATION**
**THIS APPLIES TO ALL AGENTS: MANAGER, DEVELOPER, REVIEWER - NO EXCEPTIONS**

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
**When you are called/activated from blocking, you MUST follow this sequence:**
1. **FIRST read `task/important.md`** to refresh knowledge of critical discipline requirements
2. **THEN read `task/history.md`** to understand:
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
- **Overall Progress**: 25% - Task 1.1 completed and validated, Task 1.2 in progress

## Progress Update - 2025-08-22
**Tasks Completed This Cycle:** Task 1.1 (Merge extra_node_pool_override.tf from v4 to root) - COMPLETED AND VALIDATED
**Validation Status:** Task 1.1 passed all validations - all 4 v4 attributes successfully merged, variable expressions preserved exactly, terraform fmt validation passed
**Customer Impact Assessment:** None - internal restructuring only, no customer-facing changes
**Next Steps:** Continue with Task 1.2 (merge main_override.tf), then Tasks 1.3-1.4 to complete Phase 1

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

| Task ID | Task Name | Phase | Assignee | Status | Start Date | Completion Date | Validation Status | Notes |
|---------|-----------|-------|----------|--------|------------|-----------------|-------------------|-------|
| 1.1 | Merge extra_node_pool_override.tf from v4 to root | 1 | Developer | Completed | 2025-08-22 | 2025-08-22 | Passed | All 4 v4 attributes successfully merged, validation passed |
| 1.2 | Merge main_override.tf from v4 to root main.tf | 1 | Developer | In Progress | 2025-08-22 | | Pending | Root: main_override.tf, V4: main_override.tf |
| 1.3 | Merge variables_override.tf from v4 to root variables.tf | 1 | Not Assigned | Not Started | | | Pending | V4: variables_override.tf |
| 1.4 | Merge versions_override.tf from v4 to root versions.tf | 1 | Not Assigned | Not Started | | | Pending | V4: versions_override.tf |
| 2.1 | Analyze example _v4 directories structure | 2 | Not Assigned | Not Started | | | Pending | 7 _v4 example dirs found |
| 2.2 | Copy v4 examples to replace non-v4 examples | 2 | Not Assigned | Not Started | | | Pending | Safe copy operation required |
| 2.3 | Process override files in copied examples | 2 | Not Assigned | Not Started | | | Pending | Merge overrides into main files |
| 2.4 | Validate all example configurations | 2 | Not Assigned | Not Started | | | Pending | Syntax and logic validation |
| 3.1 | Manager authorization for cleanup | 3 | Manager | Not Started | | | Pending | Final safety checkpoint |
| 3.2 | Remove obsolete v3 override files | 3 | Not Assigned | Not Started | | | Pending | Root override files only |
| 3.3 | Remove v4 directory after merge | 3 | Not Assigned | Not Started | | | Pending | After successful validation |
| 3.4 | Remove old example directories | 3 | Not Assigned | Not Started | | | Pending | Keep _v4 versions only |


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
| 2025-08-22 | Initial | Manager | Task breakdown table created with 12 specific tasks | Analyzed actual project structure and created detailed task breakdown based on real files found |
| 2025-08-22 | Initial | Manager | Detailed Phase 1-3 task descriptions added | Replaced TODO placeholders with specific instructions for each task |
| 2025-08-22 | Post-Review | Manager | Task 1.1 assigned to Developer with In Progress status | Reviewer validated task breakdown, beginning Phase 1 execution |
| 2025-08-22 | Task Complete | Manager | Task 1.1 marked Completed and Validated, Task 1.2 assigned to Developer | Task 1.1 successfully completed with validation passed |

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

#### Task 1.1: Merge v4/extra_node_pool_override.tf into root extra_node_pool.tf
- **Assignee:** Developer
- **Dependencies:** None
- **Instructions:**
  1. Create backup of `extra_node_pool.tf` as `extra_node_pool.tf.backup`
  2. Analyze content of `v4/extra_node_pool_override.tf`
  3. Merge override configurations into `extra_node_pool.tf`
  4. Preserve all variable names and expressions exactly as in override file
  5. Document all changes made
  6. Perform syntax validation
- **Validation Criteria:** Reviewer confirms override content correctly merged, syntax valid
- **Safety:** Original files preserved until final cleanup authorization

#### Task 1.2: Merge v4/main_override.tf into root main.tf  
- **Assignee:** Developer
- **Dependencies:** Task 1.1 validated
- **Instructions:**
  1. Create backup of `main.tf` as `main.tf.backup`
  2. Analyze content of `v4/main_override.tf`
  3. Merge override configurations into `main.tf`
  4. Preserve all variable names and expressions exactly as in override file
  5. Document all changes made
  6. Perform syntax validation
- **Validation Criteria:** Reviewer confirms override content correctly merged, syntax valid
- **Safety:** Original files preserved until final cleanup authorization

#### Task 1.3: Merge v4/variables_override.tf into root variables.tf
- **Assignee:** Developer  
- **Dependencies:** Task 1.2 validated
- **Instructions:**
  1. Create backup of `variables.tf` as `variables.tf.backup`
  2. Analyze content of `v4/variables_override.tf`
  3. Merge override configurations into `variables.tf`
  4. Preserve all variable names and expressions exactly as in override file
  5. Document all changes made
  6. Perform syntax validation
- **Validation Criteria:** Reviewer confirms override content correctly merged, syntax valid
- **Safety:** Original files preserved until final cleanup authorization

#### Task 1.4: Merge v4/versions_override.tf into root versions.tf
- **Assignee:** Developer
- **Dependencies:** Task 1.3 validated  
- **Instructions:**
  1. Create backup of `versions.tf` as `versions.tf.backup`
  2. Analyze content of `v4/versions_override.tf`
  3. Merge override configurations into `versions.tf`
  4. Preserve all variable names and expressions exactly as in override file
  5. Document all changes made
  6. Perform syntax validation
- **Validation Criteria:** Reviewer confirms override content correctly merged, syntax valid
- **Safety:** Original files preserved until final cleanup authorization

### Phase 2: Example Directory Cleanup and Processing

### Phase 2: Example Directory Cleanup and Processing

#### Task 2.1: Analyze and Document Example Structure
- **Assignee:** Developer
- **Dependencies:** Phase 1 completed and validated
- **Instructions:**
  1. Document all example directories found:
     - application_gateway_ingress vs application_gateway_ingress_v4
     - multiple_node_pools vs multiple_node_pools_v4  
     - named_cluster vs named_cluster_v4
     - startup vs startup_v4
     - uai_and_assign_role_on_subnet vs uai_and_assign_role_on_subnet_v4
     - without_monitor vs without_monitor_v4
     - with_acr vs with_acr_v4
  2. Compare file lists between v4 and non-v4 versions
  3. Identify override files in each example directory
  4. Create analysis report for Reviewer validation
- **Validation Criteria:** Reviewer confirms analysis is complete and accurate
- **Safety:** No files modified in this task, analysis only

#### Task 2.2: Copy v4 Example Content to Replace Non-v4 Examples  
- **Assignee:** Developer
- **Dependencies:** Task 2.1 validated
- **Instructions:**
  1. **DO NOT delete original example directories yet**
  2. Create backup copies of original examples (rename with .backup suffix)
  3. Copy content from each _v4 directory to corresponding non-v4 directory
  4. For each example type:
     - Copy all .tf files from *_v4/ to corresponding */ directory
     - Preserve all original file names and content
     - Document each copy operation performed
  5. Perform basic syntax check on copied files
- **Validation Criteria:** Reviewer confirms all v4 content properly copied, syntax valid
- **Safety:** Original example directories preserved as .backup until final cleanup

#### Task 2.3: Process Override Files in Copied Examples
- **Assignee:** Developer  
- **Dependencies:** Task 2.2 validated
- **Instructions:**
  1. For each example directory, identify override files (main_override.tf, providers_override.tf)
  2. Merge override content into corresponding main files
  3. Create backups before merging: main.tf -> main.tf.pre-merge
  4. Preserve all variable names and expressions exactly as in override files
  5. Document all merge operations performed
  6. Perform syntax validation on merged files
- **Validation Criteria:** Reviewer confirms all overrides properly merged, syntax valid
- **Safety:** Pre-merge backups maintained until final cleanup authorization

#### Task 2.4: Validate All Example Configurations
- **Assignee:** Reviewer
- **Dependencies:** Task 2.3 completed
- **Instructions:**
  1. Validate syntax of all modified example files
  2. Check that override content was properly merged
  3. Verify no configuration logic errors introduced
  4. Test basic terraform init/validate on examples (if possible)
  5. Document validation results and any issues found
- **Validation Criteria:** All examples pass syntax validation, no logic errors
- **Safety:** Report any issues to Manager for resolution before proceeding

### Phase 3: Final Validation and Authorized Cleanup

### Phase 3: Final Validation and Authorized Cleanup

#### Task 3.1: Manager Authorization for Final Cleanup
- **Assignee:** Manager
- **Dependencies:** All Phase 2 tasks validated successfully
- **Instructions:**
  1. Review all validation reports from Reviewer
  2. Confirm all merge operations completed successfully
  3. Verify no customer-impacting issues identified
  4. Check that all backup files are in place for rollback if needed
  5. Assess overall project risk and customer impact
  6. **CRITICAL DECISION POINT:** Authorize cleanup operations only if:
     - All validations passed without issues
     - No syntax errors in any modified files
     - Complete backup strategy is in place
     - Rollback procedures are ready if needed
- **Authorization Required:** Manager must explicitly approve each cleanup task
- **Safety:** Do not authorize cleanup if any validation concerns exist

#### Task 3.2: Remove Obsolete Root Override Files (v3-only)
- **Assignee:** Reviewer (with Manager authorization)
- **Dependencies:** Task 3.1 Manager authorization granted
- **Instructions (Execute ONLY after Manager authorization):**
  1. **VERIFY Manager authorization before proceeding**
  2. Remove obsolete v3-only override files from root:
     - Remove `extra_node_pool_override.tf` (v3-only attributes)
     - Remove `main_override.tf` (v3-only attributes)
  3. Document each file deletion operation
  4. Confirm files are successfully deleted
- **Validation:** Manager confirms deletions completed correctly
- **Rollback:** Backup files available if restoration needed

#### Task 3.3: Remove v4 Directory After Successful Merge  
- **Assignee:** Reviewer (with Manager authorization)
- **Dependencies:** Task 3.2 completed and Manager authorization
- **Instructions (Execute ONLY after Manager authorization):**
  1. **VERIFY Manager authorization before proceeding**
  2. Confirm all v4 override content successfully merged into root files
  3. Remove entire `v4/` directory and all contents
  4. Document directory deletion operation
  5. Verify directory completely removed
- **Validation:** Manager confirms v4 directory removal completed
- **Rollback:** Full v4 directory backup available for restoration

#### Task 3.4: Remove Old Example Directories
- **Assignee:** Reviewer (with Manager authorization)  
- **Dependencies:** Task 3.3 completed and Manager authorization
- **Instructions (Execute ONLY after Manager authorization):**
  1. **VERIFY Manager authorization before proceeding**
  2. Remove old (non-v4) example directories:
     - Remove `examples/application_gateway_ingress/` (keep _v4 version)
     - Remove `examples/multiple_node_pools/` (keep _v4 version)
     - Remove `examples/named_cluster/` (keep _v4 version)
     - Remove `examples/startup/` (keep _v4 version)
     - Remove `examples/uai_and_assign_role_on_subnet/` (keep _v4 version)
     - Remove `examples/without_monitor/` (keep _v4 version)
     - Remove `examples/with_acr/` (keep _v4 version)
  3. Rename remaining _v4 directories to remove _v4 suffix
  4. Document all directory operations
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
