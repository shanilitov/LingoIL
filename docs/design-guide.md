# LingoIL Design Guide
## Inspired by Duolingo's Learning Experience

This document defines the visual design rules for LingoIL, researched and adapted
from Duolingo's award-winning learning interface.

---

## 1. Color Palette

Duolingo uses a vibrant, high-contrast palette that feels friendly and energetic.
LingoIL adapts this palette with Hebrew-learning context in mind.

### Primary Colors

| Token               | Hex       | Usage                                       |
|---------------------|-----------|---------------------------------------------|
| `featherGreen`      | `#58CC02` | Primary CTA buttons, correct answers, progress |
| `featherGreenDark`  | `#58A700` | Button bottom-shadow (3D press effect)      |
| `maskGreen`         | `#89E219` | Active/highlight green accents              |

### Feedback Colors

| Token          | Hex       | Usage                               |
|----------------|-----------|---------------------------------------|
| `cardinal`     | `#FF4B4B` | Errors, hearts, wrong answers         |
| `cardinalDark` | `#EA2B2B` | Error button shadow                   |
| `bee`          | `#FFC800` | XP rewards, achievements, streaks     |
| `beeDark`      | `#E5A000` | Reward shadow                         |
| `fox`          | `#FF9600` | Streak flame, warm accents            |
| `macaw`        | `#1CB0F6` | Info, tips, listen-exercises          |
| `macawDark`    | `#1899D6` | Info button shadow                    |

### Neutral Colors

| Token      | Hex       | Usage                             |
|------------|-----------|-------------------------------------|
| `snow`     | `#FFFFFF` | Card backgrounds, surfaces          |
| `polar`    | `#F7F7F7` | Page/scaffold background            |
| `swan`     | `#E5E5E5` | Borders, dividers, disabled states  |
| `hare`     | `#AFAFAF` | Placeholder text, hints, muted text |
| `wolf`     | `#777777` | Secondary text                      |
| `eel`      | `#4B4B4B` | Primary text, headings              |

### Semantic Surfaces

| Token                | Hex       | Usage                    |
|----------------------|-----------|--------------------------|
| `correctSurface`     | `#D7FFB8` | Correct answer banner bg |
| `incorrectSurface`   | `#FFDFE0` | Wrong answer banner bg   |

---

## 2. Typography

Duolingo uses **DIN Round** (proprietary) — rounded, bold, and playful.
LingoIL uses system fonts with similar characteristics.

### Type Scale

| Style           | Size | Weight   | Line Height | Usage                     |
|-----------------|------|----------|-------------|---------------------------|
| `displayLarge`  | 28   | ExtraBold (w800) | 1.2   | Lesson complete titles    |
| `headlineSmall` | 22   | ExtraBold (w800) | 1.2   | Exercise prompt (Hebrew)  |
| `titleLarge`    | 20   | Bold (w700)      | 1.3   | Section headers           |
| `titleMedium`   | 17   | Bold (w700)      | 1.3   | Option text, sub-headings |
| `bodyLarge`     | 16   | Regular          | 1.45  | Body text                 |
| `bodyMedium`    | 14   | Regular          | 1.4   | Secondary text, hints     |
| `labelLarge`    | 15   | ExtraBold (w800) | 1.2   | Button labels (uppercase) |
| `labelSmall`    | 12   | Bold (w700)      | 1.0   | Badges, pills, captions   |

### Typography Rules

1. **Button text** is always UPPERCASE with letter-spacing 1.0
2. **Hebrew text** is always rendered RTL with explicit `textDirection: TextDirection.rtl`
3. **English learning targets** are always LTR inside Unicode isolates
4. **Exercise prompts** use headlineSmall for maximum readability
5. **Font weight is generous** — Duolingo rarely uses regular weight for interactive elements

---

## 3. Spacing System

Duolingo uses a consistent 4px base grid.

| Token    | Value | Usage                               |
|----------|-------|---------------------------------------|
| `xxs`    | 2     | Tight inline spacing                  |
| `xs`     | 4     | Icon-to-text gap                      |
| `sm`     | 8     | Chip spacing, compact gaps            |
| `md`     | 12    | Between related elements              |
| `lg`     | 16    | Section gaps, card padding            |
| `xl`     | 20    | Between sections                      |
| `xxl`    | 24    | Page-level padding                    |
| `xxxl`   | 32    | Large section separators              |

---

## 4. Border Radius

Duolingo uses generously rounded corners on everything.

| Token          | Value | Usage                             |
|----------------|-------|-------------------------------------|
| `radiusSm`     | 8     | Small badges, tags                  |
| `radiusMd`     | 13    | Chips, small cards                  |
| `radiusLg`     | 16    | Buttons, input fields, cards        |
| `radiusXl`     | 22    | Exercise cards, large containers    |
| `radiusFull`   | 999   | Circles, progress bars, pills       |

---

## 5. Button Design (Signature 3D Buttons)

Duolingo's most recognizable UI element is the **3D push button** with a
colored bottom shadow that disappears on press.

### Button Anatomy

```
┌──────────────────────────────┐  ← border-radius: 16
│                              │
│       BUTTON LABEL           │  ← height: 54-58px
│                              │
├──────────────────────────────┤  ← 4px bottom shadow
└──────────────────────────────┘    (darker shade of fill color)
```

### Button States

| State     | Fill Color     | Shadow          | Text Color |
|-----------|----------------|-----------------|------------|
| Default   | featherGreen   | 4px featherGreenDark | white  |
| Pressed   | featherGreenDark | 0px (no shadow) | white     |
| Disabled  | swan           | 0px              | hare       |
| Error     | cardinal       | 4px cardinalDark | white     |
| Info      | macaw          | 4px macawDark    | white      |

### Button Rules

1. Primary action buttons are always **full-width** at the bottom of the screen
2. Button height is **54–58px** for easy tapping
3. Bottom shadow is exactly **4px** offset-y
4. Press animation duration: **100ms**
5. Button labels are always **UPPERCASE**, **ExtraBold (w800)**, letter-spacing **1.0**

---

## 6. Cards & Containers

### Exercise Card

```
┌───────────────────────────────────┐
│  padding: 16px all sides          │
│                                   │
│  • White background (snow)        │
│  • Border: 2px swan               │
│  • Border-radius: 22px            │
│  • No elevation/shadow            │
│                                   │
└───────────────────────────────────┘
```

### Rules

1. Cards use **border** instead of elevation/shadow (flat design)
2. Card borders are **2px** with `swan` color
3. Card border-radius is **22px** (generous rounding)
4. Card internal padding is **16px**
5. Nested elements within cards have **12px** spacing

---

## 7. Progress Bar

The progress bar appears at the top of every exercise screen.

### Specifications

| Property          | Value                      |
|-------------------|----------------------------|
| Height            | 16px                       |
| Border-radius     | full (999)                 |
| Track color       | swan (#E5E5E5)             |
| Fill color        | featherGreen (#58CC02)     |
| Animation         | 300ms ease-out             |

### Layout Rule

```
[X close] [────── progress bar ──────] [❤️ 5]
```

- Close button: left-aligned
- Progress bar: fills available space
- Hearts counter: right-aligned with heart icon

---

## 8. Feedback Banners

### Correct Answer Banner

```
┌─────────────────────────────────────┐
│ ✅  Great job! / !מעולה              │
│                                      │
│ bg: correctSurface (#D7FFB8)         │
│ border: 2px featherGreen             │
│ border-radius: 16px                  │
│ text: featherGreenDark, bold         │
└─────────────────────────────────────┘
```

### Incorrect Answer Banner

```
┌─────────────────────────────────────┐
│ ❌  Correct answer: "..."           │
│                                      │
│ bg: incorrectSurface (#FFDFE0)       │
│ border: 2px cardinal                 │
│ border-radius: 16px                  │
│ text: cardinal, bold                 │
└─────────────────────────────────────┘
```

---

## 9. Exercise Type Layouts

### Translation Exercise (He → En)

```
┌─────────────────────────────────────┐
│ 🧑‍🏫  "שלום"                         │  ← Prompt card
│      [🔊 audio button]              │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ Type your answer in English...       │  ← Input area
│ _________________________________   │
└─────────────────────────────────────┘

         [ CHECK ✓ ]                     ← Bottom CTA
```

### Build Sentence Exercise

```
┌─────────────────────────────────────┐
│ [selected] [tokens] [here]          │  ← Answer zone
└─────────────────────────────────────┘

  (word) (bank) (tokens) (tap-to-add)    ← Word bank

         [ CHECK ✓ ]                     ← Bottom CTA
```

### Match Pairs Exercise

```
   LEFT COLUMN         RIGHT COLUMN
  ┌──────────┐        ┌──────────┐
  │  תפוח    │        │  apple   │
  └──────────┘        └──────────┘
  ┌──────────┐        ┌──────────┐
  │  לחם     │        │  bread   │
  └──────────┘        └──────────┘
```

### Multiple Choice (Chat) Exercise

```
  🧑‍🏫  "How do you say ___?"

  ┌─────────────────────────────┐
  │  Option A                   │  ← Tap to select
  └─────────────────────────────┘
  ┌─────────────────────────────┐
  │  Option B                   │  ← Selected state: green border
  └─────────────────────────────┘
  ┌─────────────────────────────┐
  │  Option C                   │
  └─────────────────────────────┘

         [ CHECK ✓ ]
```

---

## 10. Animation Guidelines

| Animation              | Duration | Curve        | Usage                  |
|------------------------|----------|--------------|------------------------|
| Button press           | 100ms    | easeOut      | 3D button depression   |
| Progress bar fill      | 300ms    | easeOut      | Exercise progress      |
| Feedback banner appear | 200ms    | easeInOut    | Correct/wrong slide-in |
| Card transition        | 250ms    | easeInOut    | Exercise card swap     |
| XP counter increment   | 400ms    | bounceOut    | Score updates          |

---

## 11. Lesson Summary Screen

After completing all exercises, show a celebration screen:

```
        🎉

   Lesson Complete!

  ┌──────────┐  ┌──────────┐
  │ ⚡ XP    │  │ 🎯 95%   │
  │   45     │  │ accuracy  │
  └──────────┘  └──────────┘

  ┌─────────────────────────┐
  │ ❤️ Hearts left: 4       │
  └─────────────────────────┘

       [ CONTINUE → ]
```

---

## 12. Dashboard / Lesson Map

The lesson map uses a **vertical node path** with connected nodes:

```
    ● ─── Unit 1: Food Basics (unlocked, green)
    │
    ● ─── Unit 2: Daily Phrases (locked, gray)
    │
    ● ─── Unit 3: At the Airport (locked, gray)
```

### Node States

| State    | Circle Color   | Text Color | Icon       |
|----------|----------------|------------|------------|
| Unlocked | featherGreen   | eel        | Number     |
| Current  | featherGreen   | eel        | ★ Star     |
| Locked   | swan           | hare       | 🔒 Lock   |

---

## 13. RTL/LTR Handling

1. **App chrome** (nav, headers): Follows device locale (RTL for Hebrew)
2. **Hebrew content**: Always `textDirection: TextDirection.rtl`
3. **English content**: Always `textDirection: TextDirection.ltr` + Unicode LTR isolate
4. **Mixed content**: Use BiDi isolates (`\u2066`...`\u2069` for LTR, `\u2067`...`\u2069` for RTL)
5. **Input fields**: Direction matches expected answer language

---

## 14. Accessibility Rules

1. Minimum touch target: **48x48px**
2. Color contrast ratio: **4.5:1** minimum for text
3. All interactive elements have visible focus indicators
4. Feedback is conveyed through **color + icon + text** (never color alone)
5. Animations respect `reduceMotion` system preference
