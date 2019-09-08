---
title: Slides Template
author: Minijackson
date: 2019-09-08
slide-level: 2
aspectratio: 169
theme: metropolis
toc: true

header-includes: |
  \usepackage{pgfpages}
  \setbeameroption{show notes on second screen=right}

  \usecolortheme{owl}
  \setbeamercolor{section in toc}{
    use=normal text,
    fg=normal text.fg
  }
  \setbeamercolor{subsection in toc}{
    use=normal text,
    fg=normal text.fg
  }

  \usepackage{fvextra}
---

<!-- Compile with:
`pandoc slides.md -t beamer slides.pdf --highlight-theme breezedark` -->

# In the morning

## Getting up

### It's hard

- Turn off alarm
- Get out of bed

## Breakfast

- Eat eggs
- Drink coffee

# In the evening

## Dinner

- Eat spaghetti
- Drink wine

## This frame {.standout}

This Is Important!™

. . .

This Is Important×2!™

---

This Is Important×3!™

## The End {.standout}

That's all folks!

. . .

Questions?
