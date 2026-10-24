# Choosing design skills

Design skills differ per install. Treat every name as optional ("if installed"). If a skill is missing, apply the rule in the third column yourself. BRAND.md and its design system always override a generic skill.

| Task | Skill (if installed) | Rule to apply even without it |
|---|---|---|
| Reference research before any visual choice | a moodboard/inspiration skill, or manual research | 3-6 real references, what you take from each, saved beside the work; every new value traceable to it |
| New surface, direction, redesign | `frontend-design`, `impeccable` | two-pass plan (tokens/type/layout in one sentence + sketch, then revise); the brief and the brand's world win |
| Quality floor before editing UI | `impeccable` craft references | read the floor once per session; skip decorative effects |
| Critique, audit, polish | `impeccable`, a web-interface-guidelines review, `accessibility` | one scoring scale per report; sentence case headings, never Title Case |
| Color, tokens, contrast | `better-colors` + `scripts/contrast.py` | measure the rendered pair; report, do not repaint tokens; approver decides new colors |
| Grouping, spacing, columns, carousel grid | `better-layout`, `refactoring-ui` | gap between groups >= 2x the gap inside; no shadows on cards unless the system has them |
| Typesetting, font loading | `web-typography` | families are chosen by the brand; the skill sets them well, it does not pick new ones |
| Editorial composition (carousels, sections, decks) | an editorial-layout skill | four checks: anchor edge, air, type-scale contrast (>= 6:1 title:body), one accent < 10 % |
| Brand book, tokens, logo rules | a brand-guidelines skill | everything at brand level needs the approver |
| Should something move on the page? | `emil-design-eng`, an Apple-style fluid-motion skill | one motion per page; cs-animation builds it |
| UI copy, empty states, errors | `better-writing` | cs-story owns the words, you own space and hierarchy |
| Usability (waitlist, tools, FAQ) | `ux-heuristics` | dark-pattern check: sign-up flows must be honest |
| Robustness with real data | `break-ui` | 0 / 1 / NaN / very long / accented characters / long compounds |
| Directions for the approver to choose between | a variants/prototype skill | previews rendered at true size; never mark a favorite |
| Signature moment, brainstorming | `top-design` (critique only) | dampen: no extreme scale contrast, custom cursors, or extra motion |
| Performance | `performance`, `core-web-vitals` | measure before/after (3 runs); without field data the page is "not measured" |

## Session rules
- Load a skill the first time you need it in a session, not "just in case". One role skill + the design skills the task needs.
- When a skill's advice conflicts with BRAND.md (a different palette, an effect the brand bans), BRAND.md wins; note the conflict in the hand-over.
- Skills that assume a SaaS landing page (hero-metric tiles, pricing cards, gradient CTAs) are a source of slop for a brand site; use them for method, not for look.
- Use the cheapest model that can do the job; mechanical checks (contrast, token scan, contact sheet) do not need the strongest one.
