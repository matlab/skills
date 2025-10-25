# Contributing to MATLAB Skills

Thank you for your interest in contributing to MATLAB Skills! This document provides guidelines and instructions for contributing to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Skill Development Guidelines](#skill-development-guidelines)
- [Testing Requirements](#testing-requirements)
- [Pull Request Process](#pull-request-process)
- [Skill Ideas](#skill-ideas)

## Code of Conduct

We are committed to providing a welcoming and inclusive environment. Please be respectful and constructive in all interactions.

### Our Standards

- Be respectful and considerate
- Welcome newcomers and help them learn
- Focus on what is best for the community
- Show empathy towards others
- Accept constructive criticism gracefully

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

1. Open a [GitHub Discussion](https://github.com/matlab/skills/discussions) or Issue
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
└── SKILL.md          # Required: Main skill file
```

Optional supporting files:
```
skills/your-skill-name/
├── SKILL.md          # Required
├── examples.md       # Example usage
├── reference.md      # Additional reference material
└── scripts/          # Helper scripts if needed
    └── helper.m
```

### SKILL.md Format

Every skill requires a `SKILL.md` file with YAML frontmatter:

```yaml
---
name: your-skill-name
description: Clear description of what the skill does and when Claude should use it. Be specific about triggers.
license: MathWorks BSD-3-Clause (see LICENSE)
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
---

# Your Skill Name

[Detailed instructions for Claude...]
```

### Required Frontmatter Fields

- **name**: Lowercase hyphen-case matching the directory name (e.g., `matlab-live-script`)
- **description**: Clear, specific description (max 1024 characters)
  - What the skill does
  - When Claude should use it
  - Key capabilities

### Optional Frontmatter Fields

- **license**: Use `MathWorks BSD-3-Clause (see LICENSE)` to match repository license
- **allowed-tools**: List of Claude Code tools the skill can use
  - Common tools: `Read`, `Write`, `Edit`, `Bash`, `Grep`, `Glob`
  - Restrict for security or scope control

### Naming Conventions

- **Skill names**: lowercase, hyphen-separated (e.g., `matlab-debugging-helper`)
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

## Skill Ideas

Looking for inspiration? Here are some skill ideas:

- **MATLAB Test Generator**: Create unit tests using MATLAB Testing Framework
- **MATLAB Performance Optimizer**: Vectorization and performance improvement suggestions
- **Simulink Model Documentation**: Generate documentation for Simulink models
- **MATLAB App Designer Helper**: Guide for creating MATLAB App Designer applications
- **MATLAB Data Import Helper**: Assist with various data import formats
- **MATLAB Plot Styler**: Create publication-quality figures
- **MATLAB Debugging Assistant**: Help debug MATLAB code with common patterns
- **MATLAB Code Converter**: Convert between MATLAB and other languages
- **MATLAB Package Creator**: Help structure MATLAB packages and classes
- **MATLAB Parallel Computing Helper**: Optimize code for parallel execution

## Questions?

- Open a [GitHub Discussion](https://github.com/matlab/skills/discussions)
- Check existing [Issues](https://github.com/matlab/skills/issues)
- Review the [Agent Skills Specification](https://github.com/anthropics/skills/blob/main/agent_skills_spec.md)

## License

By contributing, you agree that your contributions will be licensed under the MathWorks BSD-3-Clause License. See the [LICENSE](LICENSE) file for full terms.

---

Thank you for helping make MATLAB development with Claude even better!
