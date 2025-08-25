# Critical Discipline Requirements

## 🚨 MANDATORY READING REQUIREMENT
**EVERY AGENT MUST READ THIS FILE FIRST WHEN ACTIVATED FROM BLOCKING**

## 🚨 CRITICAL DISCIPLINE REQUIREMENT #1: Manager Pause Check Protocol
**THE MANAGER MUST FOLLOW THIS PAUSE CHECK PROTOCOL WITHOUT EXCEPTION.**

When `task/pause` file exists, the Manager executes:
1. **Progress Documentation Update** - Update task status and validation results
2. **History Documentation** - Update `task/history.md` with cycle summary
3. **Git Commit Process** - Commit all changes with descriptive message
4. **Pause Execution** - Yield to `people` and wait for human approval
5. **Delete `pause` file only after human wake-up**

## 🚨 CRITICAL DISCIPLINE REQUIREMENT #2: History.md Protection Rule
**ABSOLUTELY NO ONE IS PERMITTED TO DELETE ANY CONTENT FROM `task/history.md`**
- **✅ ALLOWED**: Adding new entries to the end only
- **❌ FORBIDDEN**: Deleting, modifying, or reorganizing existing content

## 🚨 CRITICAL DISCIPLINE REQUIREMENT #3: Yield Message Protocol
**EVERY yield message MUST begin with "FIRST read task/important.md to refresh critical requirements, then..."**

Required format:
```
agent.exe -role <role> -yield-to <next_role> -yield-msg "FIRST read task/important.md to refresh critical requirements, then <command>"
```

## 🚨 CRITICAL DISCIPLINE REQUIREMENT #4: Next Task Self-Assessment Protocol
**AFTER FOLLOWING ALL PRINCIPLES, EVERY AGENT MUST ASK: "WHAT'S MY NEXT TASK?"**

Self-Assessment Process:
1. **Read `task/important.md` again: I must always read this file first, since file's content might be changed.
2. **Task Identification**: "What's my next task?"
3. **Context Review**: Examine current state and pending objectives
4. **Priority Assessment**: Determine most critical task
5. **Action Planning**: Define specific steps needed
6. **Resource Check**: Verify tools and information available

## ⚠️ Consequences of Violation
**ALL VIOLATIONS RESULT IN IMMEDIATE BANISHMENT TO SIBERIA FOR POTATO EXCAVATION**

## Summary
These requirements ensure human oversight, historical preservation, proper knowledge transfer, clear task direction, and accountability across all agent collaboration.
