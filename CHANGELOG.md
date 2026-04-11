# 共处指数 Coexist Index — Changelog & Retrospective

## v10 Roguelike Rebuild (2026-04-11)

### What Changed
Complete rebuild of the Coexist Quiz as a roguelike exploration experience. Single-file HTML architecture, 3128 lines, ~96KB.

**Architecture:**
- Roguelike floor system: F0(1Q, 5 options) → F1(5Q) → F2(15Q) → F3(6 archetype clusters, 3Q each)
- 27 total question nodes with full routing table
- 31 result cards: 18 deep results, 5 F1 early exits, 4 F2 early exits, 4 hidden endings
- 5-axis psychological scoring: Recovery / Boundary / Sobriety / Truth / Coexist (0-100)
- Euclidean distance fallback for result matching

**New Systems:**
- Rarity system: ★出厂设置 / ★★有点东西 / ★★★不太对劲 / ★★★★停产了 / ★★★★★查无此人
- 6 archetypes: MIRR(职业好人) / GHST(人间404) / FGHT(行走的火药库) / DECT(人形显微镜) / PHIL(道理都懂) / COEX(着陆了)
- Hidden endings: DRUNK(random), LOOP(3+ retakes), SPEED(<3s avg), CTRL(NPD path)
- 适应指数/999 combat power score
- Canvas-based 1080×1920 share card PNG generation
- Historical "同频" stories: 3-4 per archetype
- Pentagonal radar chart with brand colors
- Behavior trigger mapping via Pete Walker 4F / DBT / Polyvagal Theory

**Brand System:**
- Paper #F6F1EB / Ink #2C2825 / Signal #B8845A
- Typography: DM Sans (200-400) + Noto Serif SC

### Bugs Fixed (12 total)
1. **loaderMsgs undefined** — Variable declared as loaderMessages but referenced as loaderMsgs. ROOT CAUSE of blank page bug.
2. **goHome() wrong page ID** — Referenced 'homePage' instead of 'introPage'
3. **showPage() wrong selector** — Used [data-page] instead of .page class
4. **loadQuestion() incompatible with HTML** — Wrong DOM IDs and property names
5. **selectOption() missing visual feedback** — No selected class toggle
6. **showResult() assumed pre-existing DOM** — Result page is innerHTML template
7. **drawRadar() wrong shape/colors** — Circular instead of pentagonal
8. **wrapText() was DOM-based** — Should be Canvas utility
9. **saveCard() generated HTML not PNG** — Rewrote to Canvas 1080×1920
10. **getBehaviorTriggers() wrong data source** — Used opt.trigger instead of modifiers
11. **getDataStats() wrong return shape** — Wrong object structure
12. **Unescaped quote in GHST-2** — Broke JS parsing

### Build Process
Built by splitting into 4 parallel parts to avoid token limits:
- v10-part1.js — State, data, stories (328 lines)
- v10-part2.js — Question tree, 27 nodes (885 lines)
- v10-part3.js — Results database, 31 entries (498 lines)
- v10-part4.js — Core functions, UI logic (~570 lines)

### Test Results
✅ JavaScript syntax: VALID
✅ All 19 core functions: PRESENT
✅ 27 question nodes: VERIFIED
✅ 31 result entries: VERIFIED
✅ All routing targets: VALID

---

## Retrospective

### What Went Well
- 4 parallel agent build avoided 32K token limit
- Roguelike floor structure is clean and extensible
- 24 historical stories across 6 archetypes
- Automated testing caught the critical loader bug

### What Went Wrong
- Part4 agent rewrote functions from scratch instead of referencing working file
- 11/12 bugs were in part4.js
- loaderMsgs vs loaderMessages typo was devastating

### Lessons Learned
1. Always use working file as canonical reference
2. Verify variable naming across all parts before assembly
3. Run automated tests immediately after assembly
4. A single typo in loader can make entire app appear broken
