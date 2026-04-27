# Workflow: from blank manuscript to live listing

This is the full process for getting one product from idea to live SKU. Time estimates assume product 4+, after the pipeline is internalized.

---

## 0. Preconditions

- DTRPG publisher account exists (one-time setup, free, ~10 min to register)
- itch.io account exists (one-time, free, ~5 min)
- PayPal connected to DTRPG payouts
- Build environment passes `make check`

---

## 1. Brief (~30 min)

Open `products/<n>-<slug>/metadata.yaml` and fill in:

- `title` — evocative, two-or-three-word ideal
- `subtitle` — the angle in one sentence
- `series` — "The Mire End Cycle  ·  No. <n>"
- `system` — "System-Neutral / OSR" for this series
- `party-size`, `runtime` — be honest, not aspirational

Then, in your head or in a private notes file (gitignored), answer:

- **Central image.** One sentence, one picture. (For Salt Wedding: "a wedding feast frozen in salt mid-toast.")
- **Buyer's problem.** What does this product solve for a GM that they can't solve in 30 minutes themselves?
- **Page target.** 8–14 pages. Resist scope creep.
- **Tone register.** Folk-horror / weird / liminal / quiet. Match prior products in the series.

If you cannot state the central image in one sentence, the brief isn't ready.

---

## 2. First Claude pass (~30 min Claude work, ~30 min review)

Prompt Claude with:

> I'm writing a product in the Mire End Cycle series — system-neutral OSR adventures with a folk-horror register. The central image of this one is: <one sentence>. The buyer is a GM running a single ~3-hour session for 3–5 PCs. Page target: 10. Tone: <reference an existing product>.
>
> Generate the structural skeleton: Quickstart (4 paragraphs), Background (2-3 paragraphs), 3 hooks, an approach/atmosphere section, 6-8 keyed locations, 1-2 NPCs with voice, 4-5 endings, a system-neutral mechanic that's specific to this product, a d6 rumor table, and a GM note.

Read what Claude produces. Cut what's redundant. Keep what surprises you. The first pass is structural — voice comes next.

---

## 3. Voice pass (~45 min)

Prompt Claude with:

> Rewrite the prose for the Mire End Cycle voice: terse, folkloric, slightly archaic; no sentence does two jobs at once; use specific concrete detail in place of adjectives; allow rhythm and silence in paragraph breaks. Keep all content. Match the register of <reference product>.

Paste back. This is where the writing becomes shippable.

---

## 4. Editorial pass (~45 min — this is non-delegable)

Read the manuscript aloud. Yes, aloud. Mark:

- Anything that catches in your throat.
- Anything that sounds like a list when it should sound like a story.
- Anything that's a Claude tic ("It is worth noting that..." / "Indeed,..." / em-dash overuse).
- Mechanical errors — wrong DCs, broken stat blocks, system inconsistencies.
- Locations or NPCs that don't earn their wordcount.

Cut hard. The product gets better with every paragraph removed.

---

## 5. Build (~15 min)

```bash
make build PRODUCT=<n>-<slug>
```

Open the PDF. Look for:

- Widows and orphans (single lines stranded at top/bottom of page) — usually self-resolves with small content edits
- Section headers landing at bottom of page — same fix
- Anything that looks weirdly spaced — could be a markdown formatting issue

Iterate until satisfied. Each rebuild is ~3 seconds.

---

## 6. Cover (~30 min if backup, 3–5 days if commission)

- Backup: type-only cover with EB Garamond + a public-domain texture. Use Affinity Publisher, Inkscape, or even Figma. 1500×2400px minimum.
- Commission: post the brief from `operations/cover-briefs/<n>-<slug>.md` on Fiverr. $15–25 budget. Allow 3–5 days.

---

## 7. Upload (~45 min, real time)

### DTRPG

1. Log in. Go to "Publisher Tools" → "Add Title".
2. Title, subtitle, full description (paste from `operations/listing-copy/<n>-<slug>.md`).
3. Categories: "Adventure" + "Setting" + system tag.
4. Tags: paste from listing copy.
5. Pricing: PWYW, $2.95 floor, $4.95 suggested.
6. Upload PDF and cover.
7. Enable preview: first 3 pages.
8. AI disclosure: tick "Created with AI assistance" (DTRPG policy as of 2025; check current language).
9. Publish.

### itch.io

1. Create new project. Type: "Physical game" → "Tabletop role-playing game" subtype.
2. Same title, description, cover.
3. Pricing: same as DTRPG.
4. Upload PDF.
5. Publish.

---

## 8. Single launch announcement (~20 min)

Post once, in one community where you have legitimate presence (r/osr, r/rpg, r/Mork_Borg, or a relevant Discord). One post. Cover image. Two-line description. Link.

Do **not** cross-post the same content to five subs — this reads as spam and gets you shadowbanned.

Do **not** announce on social media you don't already use — building presence after launch is harder than not announcing.

---

## 9. Wait

DTRPG indexes new products into "New Releases" within 24 hours. Sales — if any — start arriving in days 2–7. Do not refresh the dashboard. Start product `<n+1>`.

---

## Time totals

- Brief: 30 min
- Claude passes: 75 min
- Editorial: 45 min
- Build + iterate: 30 min
- Cover (backup): 30 min
- Upload: 45 min
- Announcement: 20 min

**Total active work per product (no commission): ~4.5 hours.**

With commission, add wallclock days but no additional active work beyond a 5-min review.
