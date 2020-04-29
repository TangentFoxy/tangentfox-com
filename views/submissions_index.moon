import Widget from require "lapis.html"

class SubmissionsIndexView extends Widget
  content: =>
    -- TODO pagination links on top/bottom of table (preferably sent out to a widget!)

    element "table", ->
      tr ->
        th "Name"
        th "Version"
        th "Creator/Submitter"
        th "Status"
        th "Notes/Video"
      for submission in *@submissions
        tr ->
          td submission.name
          td submission.version
          td submission.creator or @creator or ""
          td submission.status
          if submission.video_id
            td -> a href: "TODO"
          else
            td submission.notes or ""
      -- @tag is which tab we're on or a tag (may not exist???),
      --  @page, @num_pages, @game is from the games enum (may not exist?!?)

      -- old: Craft, Creator, Status, Notes (also video link)
      -- new: Name, Version, Creator/Submitter, Status, Notes
