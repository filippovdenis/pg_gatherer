local sql = read_file_in_plugin_dir("errors.sql")
local key = "errors"

local function check(host, unix_ts)
  local result = storage:query(sql, host, unix_ts)
  if not (result.rows[1] == nil) and not (result.rows[1][1] == nil) then
    local percentile_90_rollbacks, percentile_90_conflicts = result.rows[1][1], result.rows[1][2]
    if (percentile_90_rollbacks > 500) or (percentile_90_conflicts > 100) then
      local jsonb      = {
        host           = host,
        key            = key,
        created_at     = get_last_created_at(host, key, unix_ts),
        custom_details = {
          percentile_90_rollbacks = percentile_90_rollbacks,
          percentile_90_conflicts = percentile_90_conflicts,
        }
      }
      local jsonb, err = json.encode(jsonb)
      if err then error(err) end
      storage:insert_metric({ host = host, plugin = plugin_name, json = jsonb })
    end
  end
end

return check
