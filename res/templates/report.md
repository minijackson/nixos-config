---
title: Example report
subtitle: This is an example
author: Minijackson
numbersections: true
links-as-notes: true
colorlinks: true
toc: true
lof: true
papersize: a4
header-includes: |
  \usepackage{float}
  \makeatletter
  \def\fps@figure{H}
  \makeatother
  \usepackage{fvextra}
  \DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,breakafter=a,breakafter={,},commandchars=\\\{\}}
---

<!--
  Compile with:

  pandoc report.md -o  report.md   --filter pandoc-imagine --pdf-engine xelatex
  pandoc report.md -so report.html --filter pandoc-imagine --self-contained --toc --css report.css
-->

<!--
  Add this header for when you have really long lines in code excerpts:

  \renewcommand{\NormalTok}[1]{\FancyVerbBreakStart{}#1\FancyVerbBreakStop}
-->

# Introduction

This is an [introduction][1].

```{.graphviz im_fmt="svg"}
digraph G {
	a -> b -> c -> a -> c;
}
```

```{.plantuml im_fmt="svg"}
@startuml

class A {
	void a(b: C)
}

@enduml
```

```haskell
main :: IO ()
main = print . md5 . pack . unwords =<< getArgs
         where md5 x = hash x :: Digest MD5
```

header 1     header 2    header 3
---------- ------------  ----------
1          2             3
1          2             3
1          2             3
1          2             3
1          2             3

[1]: <https://ddg.gg/>
