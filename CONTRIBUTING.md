# Contributing to MATLAB Skills

Thank you for your interest in contributing to MATLAB Skills! This document provides guidelines and instructions for contributing to this project.

## Table of Contents

- [How to Contribute](#how-to-contribute)
- [Skill Development Guidelines](#skill-development-guidelines)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)

## How to Contribute

### Reporting Bugs

If you find a bug in an existing skill:

1. Check if the issue already exists in [GitHub Issues](https://github.com/matlab/skills/issues)
2. If not, create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce the problem
   - Expected vs actual behavior
   - Claude platform/version (Claude Code, Claude.ai, etc.)
   - Example MATLAB code or task that triggered the issue

### Suggesting Enhancements

We welcome suggestions for new skills or improvements to existing ones:

1. Open a [GitHub Issue](https://github.com/matlab/skills/issues)
2. Describe the skill or enhancement
3. Explain the use case and benefits
4. Provide examples of how it would work

### Contributing Code

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-skill`)
3. Make your changes following our guidelines
4. Test thoroughly
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

## Skill Development Guidelines

### Directory Structure

Each skill must follow this structure:

```
skills/your-skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
├── knowledge/        # Optional: structured knowledge base
├── assets/           # Optional: templates, resources
└── ...               # Any additional files or directories
```

### SKILL.md Format

Every skill requires a `SKILL.md` file with YAML frontmatter followed by Markdown content. See the [Agent Skills Specification](https://agentskills.io/specification) for the complete format reference.

```yaml
---
name: your-skill-name
description: Clear description of what the skill does and when to use it. Be specific about triggers.
license: MathWorks BSD-3-Clause (see LICENSE)
metadata:
  author: MathWorks
  version: "1.0"
---

# Your Skill Name

[Detailed instructions for the agent...]
```

### Required Frontmatter Fields

- **name**: Max 64 characters. Lowercase letters, numbers, and hyphens only. Must not start or end with a hyphen, and must not contain consecutive hyphens. Must match the parent directory name.
- **description**: Max 1024 characters. Describes what the skill does and when to use it. Include specific keywords that help agents identify relevant tasks.

### Optional Frontmatter Fields

- **license**: License name or reference to a bundled license file. Use `MathWorks BSD-3-Clause (see LICENSE)` for skills in this repository.
- **compatibility**: Max 500 characters. Indicates environment requirements such as required toolboxes, system packages, or network access.
- **metadata**: Arbitrary key-value mapping for additional metadata (e.g., `author`, `version`).
- **allowed-tools**: Space-delimited list of pre-approved tools the skill may use. (Experimental; support may vary between agent implementations.)

### Naming Conventions

- **Skill names**: Lowercase letters, numbers, and hyphens only (e.g., `matlab-debugging-helper`)
- **Directory names**: Must exactly match the `name` field in frontmatter
- **File names**: `SKILL.md` (case-sensitive)

### Writing Effective Skills

1. **Be Specific in Description**
   - ❌ Vague: "Helps with MATLAB code"
   - ✅ Specific: "Optimize MATLAB code for performance, including vectorization and memory management. Use when user requests optimization or mentions slow code."

2. **Clear Activation Triggers**
   - Specify keywords, file types, or contexts that should activate the skill
   - Example: "Use when generating .m files, creating Live Scripts, or user mentions MATLAB documentation"

3. **Structured Instructions**
   - Use clear headings and sections
   - Provide concrete examples
   - Include dos and don'ts
   - Add checklists for complex tasks

4. **MATLAB-Focused**
   - Skills should be specific to MATLAB workflows
   - Include MATLAB-specific best practices
   - Reference official MATLAB conventions when applicable

### Skill Scope

Each skill should focus on a specific task or capability:

- ✅ Good scope: "MATLAB Live Script Generator"
- ✅ Good scope: "MATLAB Test Script Creator"
- ✅ Good scope: "MATLAB Performance Profiler Helper"
- ❌ Too broad: "MATLAB Everything Helper"

## Testing Requirements

Before submitting a skill, thoroughly test it:

### 1. Local Testing with Claude Code

```bash
# Copy skill to personal skills directory
cp -r skills/your-skill-name ~/.claude/skills/

# Start Claude Code and test
claude
```

### 2. Activation Testing

Verify the skill activates appropriately:

- Ask questions matching the description triggers
- Try edge cases and variations
- Ensure it doesn't activate inappropriately

### 3. Functionality Testing

- Follow the skill instructions manually
- Verify all examples work correctly
- Test with real MATLAB code
- Check outputs are correct

### 4. Documentation Review

- Ensure instructions are clear and complete
- Verify examples are accurate
- Check for typos and formatting
- Confirm YAML frontmatter is valid

## Pull Request Process

### Before Submitting

- [ ] Skill follows directory structure guidelines
- [ ] `SKILL.md` has proper YAML frontmatter
- [ ] `name` field matches directory name (hyphen-case)
- [ ] Description is clear and specific (triggers included)
- [ ] Instructions are comprehensive with examples
- [ ] Tested locally with Claude Code
- [ ] No sensitive information or credentials included
- [ ] Follows MATLAB best practices

### PR Guidelines

1. **Title**: Clear, descriptive (e.g., "Add MATLAB unit testing skill")

2. **Description**: Include:
   - What the skill does
   - Why it's useful
   - How you tested it
   - Example usage

3. **Single Purpose**: One skill per PR (unless closely related)

4. **Documentation**: Update README.md if adding a new skill:
   - Add to "Available Skills" section
   - Describe what it does
   - Mention activation triggers

### Review Process

1. Maintainers will review your PR
2. Address any requested changes
3. Once approved, your skill will be merged
4. Thank you for contributing!

## Questions?

- Check existing [Issues](https://github.com/matlab/skills/issues)
- Review the [Agent Skills Specification](https://agentskills.io/specification)

## License

By contributing, you agree that your contributions will be licensed under the MathWorks BSD-3-Clause License. See the [LICENSE](LICENSE) file for full terms.

