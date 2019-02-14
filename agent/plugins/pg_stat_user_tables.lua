local plugin = 'pg_stat_user_tables'

local function main(agent, manager)
  local result, err = agent:query("select gatherer.snapshot_id(), * from gatherer.pg_stat_user_tables()")
  if err then error(err) end
  for _, row in pairs(result.rows) do
    insert_metric(host, plugin, row[1], nil, nil, row[2], manager)
  end
end

return main
