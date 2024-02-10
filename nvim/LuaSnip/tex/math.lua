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

return {
  -- some basic snippets
  s({ trig = ";a", snippetType = "autosnippet" }, { t("\\alpha") }),
  s({ trig = ";b", snippetType = "autosnippet" }, { t("\\beta") }),
  s({ trig = ";g", snippetType = "autosnippet" }, { t("\\gamma") }),

  s({ trig = "int" }, { t("\\int") }),
  s({ trig = ";int_", snippetType = "autosnippet" }, fmta([[\[\int_<>\] ]], { i(1) })),
  -- putting simple  expanstion

  s({ trig = "frac", dscr = "exapand to \\frac{num}{deno}" }, fmta([[\frac{<>}{<>}]], { i(1, "num"), i(2, "deno") })),
  s({ trig = "$" }, fmta([[$$<>$$]], { i(1) })),

  -- bigger snippets
  s(
    { trig = ";eq", dscr = "expand to equations", snippetType = "autosnippet" },
    fmta(
      [[
      \begin{equation*}
      <>
      \end{equation*}
      ]],
      { i(1) }
    )
  ),
}
