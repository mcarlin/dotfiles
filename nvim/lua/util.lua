--- Merge together two tables into a new table
-- This function won't alter either table `a` or `b`.
function merge(a, b)
  local c = {}
  for k,v in pairs(a) do c[k] = v end
  for k,v in pairs(b) do c[k] = v end
  return c
end

