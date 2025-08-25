# Critical Discipline Requirements

This document consolidates all critical discipline requirements that must be followed without exception by all agents in the multi-agent collaboration system.

## 🚨 MANDATORY READING REQUIREMENT

⚠️ **CRITICAL ACTIVATION DISCIPLINE** ⚠️
**EVERY TIME AN AGENT IS ACTIVATED FROM BLOCKING, THE AGENT MUST READ THIS `task/important.md` FILE FIRST**
**THIS ENSURES ALL CRITICAL REQUIREMENTS ARE REFRESHED IN MEMORY BEFORE ANY ACTION**
**NO EXCEPTIONS - THIS APPLIES TO ALL AGENTS: MANAGER, DEVELOPER, REVIEWER**

## 🚨 CRITICAL DISCIPLINE REQUIREMENT #1: Manager Pause Check Protocol

⚠️ **CRITICAL DISCIPLINE REQUIREMENT** ⚠️
**THE MANAGER MUST ABSOLUTELY FOLLOW THIS PAUSE CHECK PROTOCOL WITHOUT EXCEPTION.**
**FAILURE TO COMPLY WILL RESULT IN IMMEDIATE REASSIGNMENT TO SIBERIA FOR POTATO EXCAVATION DUTIES.**
**NO EXCEPTIONS. NO NEGOTIATIONS. ABSOLUTE COMPLIANCE REQUIRED.**

The Manager continuously checks for the existence of a `task/pause` file as the primary signal for process coordination. When the `task/pause` file is not empty, the Manager executes the following sequence:

### 1. Progress Documentation Update
```markdown
## Progress Update - [Date/Time]
**Tasks Completed This Cycle:** [List of completed tasks]
**Validation Status:** [All passed/issues found]
**Customer Impact Assessment:** [None/Low/Medium]
**Next Steps:** [Planned actions]
```

### 2. History Documentation
- Updates `task/history.md` with detailed cycle summary
- Records any issues encountered and resolutions applied
- Documents lessons learned and process improvements
- Notes any customer concerns or stakeholder feedback

### 3. Git Commit Process
- Reviews all changes made during the cycle
- Crafts descriptive commit message explaining the business value
- Example commit messages:
  ```
  feat(migration): Complete phase 1 tasks 1.1-1.3 - merge v4 overrides safely
  
  - Merged extra_node_pool_override.tf configurations
  - Validated main.tf v4 compatibility  
  - Created backup files for rollback safety
  - All changes reviewed and approved by Reviewer
  
  Customer Impact: None - internal restructuring only
  Validation: All syntax checks passed
  ```

### 4. Pause Execution Sequence
- Updates `task/task.md` with current status and progress
- Updates `task/history.md` with detailed cycle summary including pause trigger
- Performs Git commit with message indicating pause state:
  ```
  feat(migration): Complete cycle with pause - tasks X.X-X.X completed
  
  - [List completed tasks and changes]
  - All changes validated and approved by Reviewer
  - PAUSE requested - awaiting human review and approval
  - Ready for manual intervention or continuation
  
  Customer Impact: None - safe pause point
  Status: Paused for human oversight
  ```
- Yields to `people` with comprehensive pause notification
- Waits for explicit human approval to resume operations
- Empty `pause` file only after human authorization

### 5. Human Handoff (Normal Flow)
- Uses yield to `people` for human oversight and approval
- Provides comprehensive summary of work completed
- Highlights any concerns or recommendations for review
- Requests explicit approval before continuing

---

## 🚨 CRITICAL DISCIPLINE REQUIREMENT #2: History.md Protection Rule

⚠️ **CRITICAL HISTORY.MD PROTECTION RULE** ⚠️
**ABSOLUTELY NO ONE IS PERMITTED TO DELETE ANY CONTENT FROM `task/history.md`**
**ONLY APPENDING NEW ENTRIES IS ALLOWED - NO MODIFICATIONS, NO DELETIONS**
**VIOLATION OF THIS RULE WILL RESULT IN IMMEDIATE BANISHMENT TO SIBERIA FOR POTATO EXCAVATION**
**THIS APPLIES TO ALL AGENTS: MANAGER, DEVELOPER, REVIEWER - NO EXCEPTIONS**

### Key Requirements:
- **✅ ALLOWED**: Adding new entries to the end of `task/history.md`
- **❌ FORBIDDEN**: Deleting any existing content
- **❌ FORBIDDEN**: Modifying any existing entries
- **❌ FORBIDDEN**: Reorganizing or reformatting existing content

### Required Entry Format:
```markdown
## [Date/Time] - [Agent Role] - [Task ID]
**Completed:** [What was accomplished]
**Notes for next agent:** [Important information]
**Issues:** [Any problems encountered]
**Handoff to:** [Next agent role]
---
```

### Documentation Rules:
- If `task/history.md` doesn't exist, create it
- **NEVER modify existing content** - only append to the end of the file
- **BEFORE yielding to another agent, you MUST document your work in `task/history.md`**

---

## 🚨 CRITICAL DISCIPLINE REQUIREMENT #3: Yield Message Protocol

⚠️ **CRITICAL YIELD MESSAGE RULE** ⚠️
**EVERY yield message MUST begin with "FIRST read task/important.md to refresh critical requirements, then..."**
**NO EXCEPTIONS - ALL YIELD MESSAGES MUST FOLLOW THIS EXACT FORMAT**
**VIOLATION OF THIS RULE WILL RESULT IN IMMEDIATE BANISHMENT TO SIBERIA FOR POTATO EXCAVATION**

### Required Yield Message Format:
```
agent.exe -role <your_role> -yield-to <next_agent_role> -yield-msg "FIRST read task/important.md to refresh critical requirements, then <command to next agent>"
```

### Purpose and Benefits:
This ensures that each agent receiving control will:
1. **Refresh their knowledge** of critical discipline requirements
2. **Maintain consistency** in following safety protocols
3. **Avoid mistakes** due to forgotten or outdated information
4. **Preserve the integrity** of the collaborative process

### Examples of Correct Yield Messages:
- Manager to Developer: `"FIRST read task/important.md to refresh critical requirements, then start Task 1.1: Process extra_node_pool.tf according to instructions"`
- Developer to Reviewer: `"FIRST read task/important.md to refresh critical requirements, then validate Task 1.1 completion - merge of extra_node_pool_override.tf"`
- Reviewer to Manager: `"FIRST read task/important.md to refresh critical requirements, then note Task 1.1 validation passed, ready for next task assignment"`

### Key Requirements:
- **✅ REQUIRED**: Start every yield message with the exact phrase "FIRST read task/important.md to refresh critical requirements, then"
- **❌ FORBIDDEN**: Any yield message that doesn't include this prefix
- **❌ FORBIDDEN**: Modifying or abbreviating the required prefix

**This rule ensures proper knowledge transfer and safety compliance across all agent handoffs.**

---

## ⚠️ Consequences of Violation

All three critical discipline requirements carry severe consequences for non-compliance:

1. **Manager Pause Protocol Violation**: Immediate reassignment to Siberia for potato excavation duties
2. **History.md Protection Violation**: Immediate banishment to Siberia for potato excavation
3. **Yield Message Protocol Violation**: Immediate banishment to Siberia for potato excavation

**NO EXCEPTIONS. NO NEGOTIATIONS. ABSOLUTE COMPLIANCE REQUIRED.**

---

## Summary

These three critical discipline requirements ensure:
- **Human oversight** at critical decision points through the pause mechanism
- **Complete historical record** preservation through history.md protection
- **Proper knowledge transfer** through mandatory important.md reading in yield messages
- **Customer protection** through careful validation and approval processes
- **Accountability** through immutable documentation trails

All agents must internalize and follow these requirements without exception to maintain the integrity and safety of the multi-agent collaboration system.
