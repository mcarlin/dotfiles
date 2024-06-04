local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
  s({ trig = ";ie", snippetType = "autosnippet" },
    {
      t({
        "if err != nil {",
        "  "
      }),
      i(1),
      t({
        "",
        "}"
      }),
    }
  ),
  s({ trig = ";nn", snippetType = "autosnippet" },
    {
      t("if "),
      i(1),
      t({
        " != nil {",
        "  "
      }),
      i(2),
      t({
        "",
        "}"
      }),
    }
  ),

}
