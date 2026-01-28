# MATLAB Skills for Coding Agents

A collection of [Agent Skills](https://agentskills.io) for MATLAB development using coding agents. Skills are specialized instruction sets that extend the capabilities of coding agents for specific tasks, automatically activating when needed.

## What are Skills?

Skills are modular, portable capabilities that work across coding agents:

- **Composable**: Skills stack together automatically when needed
- **Efficient**: Only load when relevant to your current task
- **Powerful**: Combine instructions with executable code for reliable results

## Available Skills

### MATLAB Live Script Generator
**Skill ID**: `matlab-live-script`

Creates properly formatted MATLAB plain text Live Scripts (.m files) with rich text documentation, equations, and visualizations. Automatically handles:

- Section formatting with `%[text]` markers
- LaTeX equation rendering with double backslashes
- Bulleted lists with proper termination
- Required appendix formatting
- Plot and figure management
- Code and documentation integration

**When it activates**: Creating MATLAB scripts, educational content, Live Scripts, or .m files with documentation.

### MATLAB Test Generator
**Skill ID**: `matlab-test-generator`

Creates unit tests using the MATLAB Testing Framework. Generates test classes, test methods, and test suites following best practices:

- Class-based test structure with `matlab.unittest.TestCase`
- Proper test method naming and organization
- Comprehensive assertion methods (`verifyEqual`, `verifyError`, etc.)
- Parameterized tests for data-driven testing
- Setup and teardown methods for test fixtures
- Test tagging and selective execution
- Mock objects and performance testing

**When it activates**: Generating test files, test cases, unit tests, test suites, or when testing MATLAB code is requested.

### MATLAB Performance Optimizer
**Skill ID**: `matlab-performance-optimizer`

Optimizes MATLAB code for better performance through vectorization, memory management, and profiling guidance:

- Vectorization of loops and operations
- Array preallocation strategies
- Memory optimization techniques (data types, sparse matrices)
- Profiling and benchmarking workflows
- Built-in function usage over manual implementations
- Parallel computing with `parfor` and GPU arrays
- Algorithm-specific optimizations
- Performance pitfall identification

**When it activates**: User requests optimization, mentions slow code, performance issues, speed improvements, or asks to make code faster or more efficient.

### MATLAB uihtml App Builder
**Skill ID**: `matlab-uihtml-app-builder`

Builds interactive web applications using HTML/JavaScript interfaces with MATLAB computational backends via the uihtml component:

- Bidirectional HTML-MATLAB communication patterns
- Event handling and data transfer strategies
- Security and input validation best practices
- Complete working examples (calculator, visualizer, forms)
- Modern UI design with CSS styling
- Error handling and debugging techniques
- Performance optimization for web apps
- Testing strategies for HTML/MATLAB integration

**When it activates**: Creating HTML-based MATLAB apps, JavaScript MATLAB interfaces, web UIs, interactive GUIs, or when user mentions uihtml, HTML, JavaScript, web apps, or web interfaces.

### MATLAB Digital Filter Design
**Skill ID**: `matlab-digital-filter-design`

Designs and validates digital filters in MATLAB using Signal Processing Toolbox and DSP System Toolbox:

- FIR and IIR filter design (lowpass, highpass, bandpass, bandstop, notch)
- Architecture selection guidance (single-stage vs efficient alternatives)
- `designfilt()` workflow with proper sample rate handling
- Filter Analyzer for visual comparison of designs
- Multirate and multistage filter optimization for narrow transitions
- Streaming (causal) vs offline (batch) mode support
- Zero-phase filtering with `filtfilt()` for offline processing
- Numerical verification of passband ripple and stopband attenuation

**When it activates**: Cleaning up noisy signals, removing interference, filtering signals, designing FIR/IIR filters, or comparing filters in Filter Analyzer.

## Installation & Usage

### Claude Code (CLI)

**Recommended**: Install all MATLAB agent skills using the plugin marketplace:

```bash
# (Step 1) Add the marketplace to Claude Code
/plugin marketplace add matlab/skills

# (Step 2) Install all the MATLAB Agent Skills
/plugin install matlab-skills@matlab-skills
```

This installs all MATLAB skills (`matlab-live-script`, `matlab-test-generator`, `matlab-performance-optimizer`, `matlab-uihtml-app-builder`, `matlab-digital-filter-design`) in one command. Skills automatically activate when Claude detects relevant tasks.

**Alternative**: Manually install to your personal skills directory:

```bash
# Clone the repository
git clone https://github.com/matlab/skills.git

# Copy all skills to your Claude skills directory
cp -r skills/skills/* ~/.claude/skills/
```

Once installed, just ask Claude to "create a MATLAB Live Script" or "optimize this code" and the appropriate skill will load automatically.

### Claude.ai (Web) and Claude Desktop

Skills are available to Pro, Max, Team, and Enterprise users. Each skill must be uploaded separately as a ZIP file.

**Uploading Skills:**

1. Open **Settings** → **Capabilities**
2. Enable Skills (Team/Enterprise admins must enable organization-wide first)
3. Click **Upload Skill** for each skill you want to add

**Creating ZIP Files:**

Each skill requires a ZIP file with `SKILL.md` at the root level. Some skills include additional resource folders (like `knowledge/`) that must be included.

*Single skill (macOS/Linux):*

```bash
cd skills/<skill-name>
zip -r ../<skill-name>.zip .
```

*Single skill (Windows PowerShell):*

```powershell
cd skills
Compress-Archive -Path "<skill-name>\*" -DestinationPath "<skill-name>.zip"
```

*All skills at once (macOS/Linux):*

```bash
cd skills
for d in */; do (cd "$d" && zip -r "../${d%/}.zip" .); done
```

*All skills at once (Windows PowerShell):*

```powershell
cd skills
Get-ChildItem -Directory | ForEach-Object {
    Compress-Archive -Path "$($_.Name)\*" -DestinationPath "$($_.Name).zip" -Force
}
```

Upload the ZIP files to get the MATLAB skills collection. Skills activate automatically when Claude detects relevant tasks.

### Claude API

Use the Skills API for programmatic control:

```python
import anthropic

client = anthropic.Anthropic(api_key="your-api-key")

response = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=4096,
    skills=["matlab-live-script"],
    messages=[
        {"role": "user", "content": "Create a Live Script showing Fourier transforms"}
    ]
)
```

**Requirements**:
- Skills API access (see [API documentation](https://docs.anthropic.com/))
- Code Execution Tool beta enabled

## Contributing

We welcome contributions! Whether you want to:

- Add new MATLAB skills (code generation, debugging, testing, etc.)
- Improve existing skills
- Fix bugs or typos
- Suggest enhancements

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Quick Start for Contributors

1. Fork this repository
2. Create a new skill directory: `skills/your-skill-name/`
3. Add a `SKILL.md` file with proper frontmatter
4. Test thoroughly with a coding agent
5. Submit a pull request

## Skill Development Resources

- [Official Skills Documentation](https://code.claude.com/docs/en/skills) - Claude Code documentation for using and creating skills
- [Agent Skills Specification](https://agentskills.io/specification) - Complete format specification for SKILL.md files
- [Agent Skills Repository](https://github.com/agentskills/agentskills) - Specification and documentation for Agent Skills
- [Anthropic Skills Repository](https://github.com/anthropics/skills) - Example skills demonstrating Agent Skills capabilities
- [Claude Code Plugin Guide](https://code.claude.com/docs/en/plugins) - Guide for installing and managing skill plugins

## Related Projects

- [matlab/matlab-mcp-core-server](https://github.com/matlab/matlab-mcp-core-server) - Official MATLAB MCP Server for running MATLAB using AI applications like Claude Code and VS Code
- [matlab/rules](https://github.com/matlab/rules) - MATLAB coding rules and guidelines optimized for AI coding assistants
- [matlab/prompts](https://github.com/matlab/prompts) - Curated collection of AI prompts for MATLAB development
- [matlab/slash-commands](https://github.com/matlab/slash-commands) - Slash commands for streamlining MATLAB development workflows in Claude Code

## License

This project is licensed under the MathWorks BSD-3-Clause License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025-2026, The MathWorks, Inc. All rights reserved.

## Community

- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/matlab/skills/issues)
- **Discussions**: Share ideas and ask questions in [MATLAB Central GenAI Discussions Channel](https://www.mathworks.com/matlabcentral/discussions/ai)

---

**Supported Coding Agents**: Agent Skills are supported by [Claude Code](https://claude.ai/code), [Claude.ai](https://claude.ai), [Cursor](https://cursor.com), [VS Code](https://code.visualstudio.com), [GitHub Copilot](https://github.com), [Gemini CLI](https://geminicli.com), [OpenAI Codex](https://developers.openai.com/codex), [Amp](https://ampcode.com), [Goose](https://block.github.io/goose), [Roo Code](https://roocode.com), and [many more](https://agentskills.io). Feature availability may vary by plan and platform.
