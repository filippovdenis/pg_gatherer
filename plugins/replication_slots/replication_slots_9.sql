select
  s.slot_name::text as slot_name,
  pg_catalog.pg_xlog_location_diff(pg_catalog.pg_current_xlog_location(), coalesce(s.confirmed_flush_lsn, s.restart_lsn))::bigint as size
from
  pg_catalog.pg_replication_slots s;