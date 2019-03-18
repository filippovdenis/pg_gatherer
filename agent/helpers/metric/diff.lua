local time = require("time")
local crypto = require("crypto")

local counter = 0
local data = {
  -- key = {value=value, unixts=now}
}

local function diff(key, value)

  local hash_key = crypto.md5(key)

  if not value then return nil end
  local prev = data[hash_key]
  local now = time.unix()
  data[hash_key] = {value = value, unixts = now}

  -- first run
  if not prev then return nil end
  -- overflow
  if prev.value > value then return nil end

  -- compress
  counter = counter + 1
  if counter % 100 == 0 then
    local new_data = {}
    for hash_key, v in pairs(data) do
      if v.unixts > now - 60*60 then new_data[hash_key] = v end
    end
    data = new_data
  end

  return value - prev.value
end

return diff
