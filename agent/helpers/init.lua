local filepath  = require('filepath')

local current_dir = filepath.dir(debug.getinfo(1).source)

local helpers = {}

-- config
helpers.config = {}
helpers.config.load = dofile(filepath.join(current_dir, "config", "load.lua"))
helpers.config.host = dofile(filepath.join(current_dir, "config", "host.lua"))

-- linux
helpers.linux = {}
helpers.linux.pid_stat = dofile(filepath.join(current_dir, "linux", "pid_stat.lua"))
helpers.linux.disk_stat = dofile(filepath.join(current_dir, "linux", "disk_stat.lua"))

-- metric
helpers.metric = {}
helpers.metric.speed = dofile(filepath.join(current_dir, "metric", "speed.lua"))
helpers.metric.diff = dofile(filepath.join(current_dir, "metric", "diff.lua"))
helpers.metric.insert = dofile(filepath.join(current_dir, "metric", "insert.lua"))

-- rds
helpers.rds = {}
helpers.rds.is_rds = dofile(filepath.join(current_dir, "rds", "is_rds.lua"))

if os.getenv("CONFIG_INITILIZED") == "TRUE" then
  helpers.connections = {}
  helpers.connections.manager = dofile(filepath.join(current_dir, "connections", "manager.lua"))
  helpers.connections.agent = dofile(filepath.join(current_dir, "connections", "agent.lua"))
  helpers.is_rds = helpers.rds.is_rds( helpers.connections.agent )
  helpers.host = helpers.config.host( os.getenv("TOKEN"), helpers.connections.manager )
end

return helpers
