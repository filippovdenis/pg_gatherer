# pg_gatherer

project is designed to collect and store statistical data of postgresql into other postgresql.

# Architecture

* target: target database
* manager: database in which information is stored

![Architecture](/img/arch.png)

# Agent

Agent is golang-binary with plugins written in lua ( [vadv/gopher-lua-libs](https://github.com/vadv/gopher-lua-libs) ).

# AlertManager

AlertManager is also lua-pluginable. Currently supports telegram and PagerDuty only.

# Deploy

on manager database:

```
$ psql -h manager -d manager -U postgres -1 -f ./schema/manager/schema.sql
$ psql -h manager -d manager -U postgres -1 -f ./schema/manager/functions.sql
```

on target database:

```
$ psql -h target -d target -U postgres -1 -f ./schema/agent/init.sql
$ psql -h target -d target -U postgres -1 -f ./schema/agent/plugin*_.sql

or

$ AGENT_PRIV_CONNECTION="host=target user=postgres" glua-libs ./schema/agent/deploy.lua
```

# Seed

```sql
insert into manager.host (token, agent_token, databases, maintenance, severity_policy_id)
    values ( 'hostname', 'token-key', '{"dbname"}'::text[], f, null);
```

# Start Agent

```
$ go get github.com/vadv/gopher-lua-libs/cmd/glua-libs
$ TOKEN=xxx CONNECTION_AGENT=xxx CONNECTION_MANAGER=xxx glua-libs ./agent/init.lua
```

# Start AlertManager

```
$ CONNECTION_MANAGER=xxx PAGERDUTY_TOKEN=xxx PAGERDUTY_RK_DEFAULT=xxx glua-libs ./alertmanager/init.lua
```

# Examples

![common](/img/common-stats.png)
![activity](/img/activity.png)
![statements-disk](/img/statements-disk.png)
![statements-total-time](/img/statements-total-time.png)
![blocks](/img/blocks.png)
![databases](/img/databases.png)
![rows-statistics](/img/rows-statistics.png)
![disk-read-per-table](/img/disk-read-per-table.png)
![bgwriter-status](/img/bgwriter-status.png)
![linux-metrics-1](/img/linux-metrics-1.png)
![linux-metrics-2](/img/linux-metrics-2.png)
![vacuum-activity](/img/vacuum-activity.png)
