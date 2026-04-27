# The Mire End Cycle

A series of system-neutral OSR adventure supplements published on DriveThruRPG and itch.io. This repository is the production pipeline: source manuscripts, build system, listing copy, cover briefs.

The pipeline is designed to ship one product every 3–5 days at near-zero marginal cost. Catalog target: 30 products in 4 months.

---

## Repository layout

```
tsw/
├── Makefile                          One command builds any product.
├── README.md                         This file.
├── shared/
│   ├── template/template.tex         Pandoc → LaTeX template (digest size, folk-horror typography).
│   └── fonts/                        EB Garamond + IM Fell English (OFL licensed, shipped in repo).
├── products/
│   └── 01-the-salt-wedding/
│       ├── manuscript.md             The text. This is what you write.
│       ├── metadata.yaml             Title, subtitle, system, etc. Two minutes to fill out.
│       └── build/                    PDF output goes here. Gitignored.
├── operations/
│   ├── listing-copy/                 DTRPG product page text per product.
│   └── cover-briefs/                 Cover art commission briefs per product.
└── docs/
    └── workflow.md                   Step-by-step ship process.
```

---

## First-time setup

You need three things on your machine:

**1. Pandoc** (≥3.0).
- macOS: `brew install pandoc`
- Linux: `apt install pandoc` (or your distro equivalent)
- Windows: WSL recommended; install via apt inside WSL

**2. A TeX distribution with `xelatex`.**
- macOS: `brew install --cask mactex-no-gui` (or full MacTeX)
- Linux: `apt install texlive-xetex texlive-fonts-recommended`
- Windows: install MiKTeX or TeX Live in WSL

**3. The bundled fonts installed for fontconfig.**
   Run once: `make install-fonts`

Verify everything is wired up:

```bash
make check
```

Expected output:
```
✓ pandoc:    pandoc 3.x
✓ xelatex:   XeTeX 3.x
✓ EB Garamond installed
✓ IM Fell English installed
```

If anything fails, fix it before continuing. The build will not work without all four checks.

---

## Building a product

```bash
make build PRODUCT=01-the-salt-wedding
```

Or, for the default product (set in the Makefile):

```bash
make build
```

Output: `products/<name>/build/<name>.pdf`

To build everything in `products/`:

```bash
make all
```

To rebuild on every save (requires `entr` — `apt install entr` / `brew install entr`):

```bash
make watch PRODUCT=01-the-salt-wedding
```

---

## Adding a new product

1. Create the directory: `mkdir products/02-the-drowned-belfry`
2. Copy the metadata template: `cp products/01-the-salt-wedding/metadata.yaml products/02-the-drowned-belfry/`
3. Edit `metadata.yaml` — change title, subtitle, series number.
4. Write `manuscript.md` (start by copying an existing one for structure, then replace the content).
5. `make build PRODUCT=02-the-drowned-belfry`
6. Iterate until satisfied.
7. Add listing copy at `operations/listing-copy/02-the-drowned-belfry.md`
8. Add cover brief at `operations/cover-briefs/02-the-drowned-belfry.md`
9. Commission or DIY the cover.
10. Upload to DTRPG and itch.io.

Realistic time per product after the first three: **4–8 hours.**

---

## Manuscript conventions (Pandoc-flavored markdown)

The template assumes specific conventions. Stick to them; they are the difference between a clean build and an evening of debugging.

| Element | Markdown | Result |
|---|---|---|
| Section heading | `# Quickstart` | Section title in IM Fell English with rule below |
| Subsection | `## Keyed Locations` | Subsection in EB Garamond, slightly smaller |
| Bold | `**The hook.**` | Bold inline emphasis |
| Italic | `*hold*` | Italic inline emphasis |
| Em-dash | `---` | Real em-dash (—), with smart-typography on |
| Block quote (NPC speech) | `> *"It is not haunted."*` | Indented, italicized, salt-grey color |
| Numbered list | `1. The Invitation.` | Numbered list |
| Bullet list | `- Salt-tax debt.` | Bulleted list with oxblood bullets |

**Do not** use horizontal rules (`---` on their own line) for thematic breaks — they conflict with em-dash parsing. The template handles section breaks via headers.

---

## The weekly workflow

Once the catalog is moving, the loop is:

1. **Monday.** Brief next product to Claude. Pick system, niche, central image, page count, tone. ~30 min.
2. **Tuesday.** First Claude pass. Generate locations, NPCs, hooks, resolutions, mechanical content. ~30 min Claude work, ~30 min review.
3. **Wednesday.** Voice pass with Claude. Tighten prose, kill redundancies. ~45 min.
4. **Thursday.** Editorial pass (you, alone, no LLM). Read aloud. Cut what's weak. ~45 min.
5. **Friday.** `make build`. Layout review. Cover decision. Upload to DTRPG + itch.io. ~90 min.

Total weekly time at steady state: **3–5 hours.**

---

## What can break

| Symptom | Likely cause | Fix |
|---|---|---|
| `make check` fails on fonts | Fonts not installed | `make install-fonts`, then close and re-open the shell |
| PDF builds but Italic is missing/garbled | System has WOFF version of EB Garamond | Already handled — fonts in repo bypass system fontconfig |
| `pandoc: not found` | Pandoc not on PATH | Install pandoc per First-time setup |
| `xelatex: not found` | TeX not installed | Install TeX distribution per First-time setup |
| `Missing number` warnings during build | Custom LaTeX command broke (e.g. redefining `\hrule`) | Check recent template edits |
| Section title appears as plain text | YAML frontmatter problem | Validate `metadata.yaml` is valid YAML |

If a build fails and the error isn't obvious, the full LaTeX log is at `products/<name>/build/<name>.log`. Search for `^!` to find errors.

---

## What this repo is not

- **Not a CI/CD system.** No automated publishing to DTRPG. Upload is manual — DTRPG's API is gated and not worth the integration overhead at this scale.
- **Not a sales tracker.** Sales data lives on DTRPG. Don't put it in this repo.
- **Not a CMS.** No web interface. The repo is the system. The Makefile is the UI.
- **Not magic.** The pipeline produces clean PDFs from clean markdown. Bad markdown produces bad PDFs.

---

## License

Adventures in `products/` are released under Creative Commons Attribution 4.0 (CC-BY 4.0). See each product's "Credits & License" section.

Bundled fonts are SIL Open Font License (OFL) — see `shared/fonts/OFL.txt`.

Build system (Makefile, template) is for the operator's use; not licensed for redistribution as a standalone product.
