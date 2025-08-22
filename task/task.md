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

| Task ID | Task Name | Phase | Assignee | Status | Start Date | Completion Date | Validation Status | Notes |
|---------|-----------|-------|----------|--------|------------|-----------------|-------------------|-------|


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
| | | Manager | Table created | Initial setup |

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

TODO:Manager should analyze tasks carefully and ask for reviewer's double confirm

### Phase 2: Example Directory Cleanup and Processing

#### Task 2.1: Create New Example Structure (DO NOT DELETE OLD)
TODO:Manager should analyze tasks carefully and ask for reviewer's double confirm

#### Task 2.2: Process Override Files in New Examples
TODO:Manager should analyze tasks carefully and ask for reviewer's double confirm

#### Task 2.3: Validate New Example Structure
TODO:Manager should analyze tasks carefully and ask for reviewer's double confirm

### Phase 3: Final Validation and Authorized Cleanup

#### Task 3.1: Manager Authorization for Final Cleanup
TODO:Manager should analyze tasks carefully and ask for reviewer's double confirm

#### Task 3.2: Authorized Final Cleanup
- **Assignee:** Reviewer (with Manager authorization)
- **Instructions (Execute ONLY after Manager authorization):**
TODO:Manager should analyze tasks carefully and ask for reviewer's double confirm
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
