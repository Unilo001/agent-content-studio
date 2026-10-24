# agent-content-studio

A connected set of agent skills for a small AI team that makes short-form video (reels, shorts, TikToks), carousels and website content — with quality over volume.

One **master skill** holds the principles, pipeline and quality system. Eight **role skills** each give one agent one job. Every skill links to the others, so work flows from story to animation to review to insights without anyone loading twenty overlapping skills.

| Skill | Agent role |
|---|---|
| `content-studio` | Master. Every content agent reads §1–4 first |
| `cs-orchestrator` | Lead/producer: briefs, dispatch, gates, asking the human |
| `cs-story` | Premise, hook, beats, script, on-screen text, captions |
| `cs-animation` | The agent as animation engine: HTML/GSAP, HyperFrames, canvas, Three.js |
| `cs-3d` | 3D assets: find, build in code, generate or order, verify scale, register |
| `cs-design` | Site, carousels, stills, palette and type |
| `cs-audio-edit` | Footage, cut rhythm, grading, voice-over, sound, mix |
| `cs-review` | Quality gates: FACTS, TASTE, MEASURE |
| `cs-insights` | Reading results, experiments, teardowns, lessons back into the system |

## Pipeline

```
brief → story → FACTS → design / 3D / footage → animation → stills TASTE
      → sound → final TASTE + MEASURE → human approves → post → insights → lessons
```

Anything under 8/10 goes back to its owner. The human only sees work that passed.

## Install

```bash
git clone https://github.com/Unilo001/agent-content-studio ~/agent-content-studio
~/agent-content-studio/install.sh
```

This symlinks every skill into `~/.claude/skills` (Claude Code) and `~/.agents/skills` (Codex and other agents that read that folder), so `git pull` updates them. Use `--copy` to copy instead, `--uninstall` to remove.

## Make it yours

Skills stay generic. Your brand lives in one file:

```bash
mkdir -p content-studio && cp ~/agent-content-studio/templates/BRAND.md content-studio/BRAND.md
```

Fill in product, audience, canonical facts, voice, banned words, visual system, approval rules and asset folders. Every skill reads it. When the approver rejects something, the lesson goes into BRAND.md's taste rules, so the team does not repeat it.

If a project needs deeper brand-specific skills, put them in the project's own `.claude/skills/`; project skills win over the global ones.

## One skill per agent

Give each worker agent `content-studio` §1–4 plus exactly one role skill. The orchestrator never implements; it briefs, delegates and judges.

## License

MIT
