for _, inserter in pairs(data.raw["inserter"]) do
  if inserter.cidl_ignore then
    inserter.cidl_ignore = nil
  else
    inserter.allow_custom_vectors = true
  end
end
