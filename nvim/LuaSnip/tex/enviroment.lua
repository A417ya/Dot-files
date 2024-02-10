local ls = require("luasnip")
local s = ls.snippet
local isn = ls.indent_snippet_node
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local utils = require("lib.snips")

return {
  -- some basic math snippets
  s({ trig = "tt", dscr = "expand tt into '\texttt{}'" }, fmta([[\texttt{<>}]], { d(1, utils.get_visual) })),
  s({ trig = "tbf", dscr = "expand tbf into \\textbf" }, fmta([[\textbf{<>}]], { d(1, utils.get_visual) })),

  s(
    { trig = ";env", dscr = "beging and ending statement", snippetType = "autosnippet" },
    fmta(
      [[
    \begin{<>}
    <>
    \end{<>}
    ]],
      {
        i(1),
        i(2),
        rep(1),
      }
    )
  ),

  -- some basic latex snippets
  s(
    { trig = "article", dscr = "article document class expand into documentclass{article}" },
    { t("\\documentclass{article}") }
  ),
  s(
    { trig = ";ce", dscr = "expand to \\center{}", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{center}
      <>
      \end{center}
   ]],
      { i(1) }
    )
  ),

  s(
    { trig = "base", dscr = "base template for latex" },
    fmta(
      [[
  \documentclass{article}

  \title{<>}
  \author{<>}
  \date{<>}

  \begin{document}
  \maketitle
  <>
  \end{document}
  ]],
      { i(1), i(2), i(3), i(4) }
    )
  ),
  s(
    { trig = "basee", dscr = "base template for latex" },
    fmta(
      [[
  \documentclass{article}
  \usepackage{asmath}

  \title{<>}
  \author{<>}
  \date{<>}

  \begin{document}
  \maketitle
  <>
  \end{document}
  ]],
      { i(1), i(2), i(3), i(4) }
    )
  ),

  s(
    { trig = ";sec", snippetType = "autosnippet" },
    fmta(
      [[
  \section{<>}
  <>
  ]],
      { i(1), i(2) }
    )
  ),
  s(
    { trig = ";seb", snippetType = "autosnippet" },
    fmta(
      [[
  \subsection{<>}
  <>
  ]],
      { i(1), i(2) }
    )
  ),
  -- table snippets

  s(
    { trig = "tabel", dscr = "generate a simple centering tabel" },
    fmta(
      [[
    \begin{tabel}
    \centering
    \begin{tabluar}{|c|c|}
    <>&<> \\
    \end{tabular}
    \caption{<>}
    \label{<>}
    \end{tabel}
    ]],
      { i(1), i(2), i(3), i(4) }
    )
  ),
}
