config = require "lapis.config"

config "production", ->
  session_name "tangentfox.com"
  secret os.getenv("SESSION_SECRET") or "secret"
  postgres ->
    host os.getenv("POSTGRES_HOST") or "postgres"
    user os.getenv("POSTGRES_USER") or "postgres"
    password os.getenv("POSTGRES_PASSWORD") or "" -- I think this will work for nonexistant password but idgaf
    database os.getenv("POSTGRES_DB") or "postgres"
  port 80
  num_workers 4
  digest_rounds 9
