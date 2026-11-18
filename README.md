# Public Skills

[Agent Skills](https://agentskills.io) for Claude, by John Telford.

| Skill | What it does |
|---|---|
| [polish](skills/polish/SKILL.md) | Adversarial sounding board for your own writing: it critiques your draft round by round until it's ready to send, and never rewrites it for you. |

## Install

**Claude Code.** Add this repo as a plugin marketplace, then install the skills you want:

```
/plugin marketplace add john-telford/public-skills
/plugin install polish@john-telford-skills
```

**Claude.ai and the desktop app.** Download `polish.skill` from the [latest release](https://github.com/john-telford/public-skills/releases/latest), then upload it under **Settings → Capabilities → Skills**.

**Anywhere else.** Copy the skill's folder (for example `skills/polish/`) into your agent's skills directory, such as `~/.claude/skills/`.

## Repo layout

```
skills/<name>/SKILL.md          one folder per skill; the folder name matches the skill's `name`
template/SKILL.md               starting point for a new skill
.claude-plugin/marketplace.json the Claude Code plugin marketplace listing
scripts/package.sh              validates every skill and builds dist/<name>.skill
```

## Adding a skill

1. Copy `template/` to `skills/<name>/` and fill in `SKILL.md`.
2. Add a plugin entry for it to `.claude-plugin/marketplace.json`.
3. Run `scripts/package.sh` to validate it and build the `.skill` file.
4. Commit, then attach `dist/*.skill` to a new GitHub release.

## License

[Apache 2.0](LICENSE)
