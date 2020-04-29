import create_table, types, add_column from require "lapis.db.schema"

{
  [1582717955]: =>
    create_table "users", {
      { "id", types.serial primary_key: true }
      { "name", types.varchar unique: true }
      { "email", types.varchar null: true }
      { "digest", types.varchar }
    }
    create_table "submissions", {
      { "id", types.serial primary_key: true }
      { "user_id", types.foreign_key null: true }
      { "game", types.integer default: 0 }
      { "version", types.varchar null: true }
      { "name", types.varchar }
      { "link", types.text }
      { "creator", types.varchar null: true }
      { "description", types.text null: true }
      { "status", types.integer default: 0 }
      { "video_id", types.varchar null: true }
      { "notes", types.text null: true }

      {"created_at", types.time}
      {"updated_at", types.time}
    }
    create_table "tags", {
      { "id", types.serial primary_key: true }
      { "name", types.varchar unique: true }
    }
    create_table "submission_tags", {
      { "id", types.serial primary_key: true }
      { "tag_id", types.foreign_key }
      { "submission_id", types.foreign_key }
    }
}
