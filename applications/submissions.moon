lapis = require "lapis"

import Submissions, Tags, Users from require "models"
import respond_to from require "lapis.application"

class SubmissionsApplication extends lapis.Application
  @path: "/gaming"
  @name: "submissions_"

  [index: "/:game/submissions(/:tag)(/page[%d])"]: =>
    per_page = 24 -- number of results to show per page

    @game = Submissions.games\for_db(@params.game)
    if not @game
      return status: 404

    -- detects and corrects a page number used without a tag specified
    -- NOTE this means numeric tags cannot be used
    if not @params.page and tonumber @params.tag
      @params.page = @params.tag
      @params.tag = nil
    @page = tonumber(@params.page) or 1

    local Paginator
    if @params.tag\lower! == "all" or @params.tag == nil -- NOTE this means a tag named 'all' cannot be used
      @tag = "all"
      Paginator = Submissions\paginated "WHERE game = ? ORDER BY id ASC", @game, :per_page
    elseif @params.tag\lower! == "pending" -- NOTE this means a tag named 'pending' cannot be used
      @tag = "pending"
      Paginator = Submissions\paginated "WHERE game = ? AND status IN (?, ?, ?, ?, ?) ORDER BY id ASC", @game, Submissions.statuses.priority, Submissions.statuses.imported, Submissions.statuses.pending, Submissions.statuses.delayed, Submissions.statuses.old, :per_page
    elseif Submissions.statuses[@params.tag\lower!] -- NOTE this means tags with names equal to any status cannot be used
      @tag = @params.tag\lower!
      Paginator = Submissions\paginated "WHERE game = ? AND status = ? ORDER BY id ASC", @game, Submissions.statuses\for_db(@params.tag\lower!), :per_page
    else
      if tag = Tags\find name: @params.tag
        @tag = @params.tag
        Paginator = Submissions\paginated "WHERE game = ? AND id IN (SELECT submission_id FROM submission_tags WHERE tag_id = ?) ORDER BY id ASC", @game, tag.id, :per_page

    if Paginator
      @num_pages = Paginator\num_pages!
      @submissions = Paginator\get_page(@page)
      if #@submissions < 1 and @num_pages > 0
        return redirect_to: @url_for "submissions_index", game: Submissions.games\to_name(@game), tag: @params.tag, page: @num_pages

    return render: "submissions_index"

  [tags: "/:game/submission-tags(/:page[%d])"]: =>
    per_page = 18*4 -- 18 rows of 4 columns

    @game = Submissions.games\for_db(@params.game)
    if not @game
      return status: 404

    @page = tonumber(@params.page) or 1
    @num_pages = math.ceil db.query("SELECT COUNT(DISTINCT tag_id) FROM submission_tags")[1].count / per_page
    @tags = db.query "SELECT tags.*, COUNT(tag_id) AS count FROM tags INNER JOIN submission_tags ON tags.id = submission_tags.tag_id GROUP BY tags.id ORDER BY count DESC, name ASC LIMIT #{per_page} OFFSET #{db.escape_literal per_page * (@page - 1)}"

    if #@tags < 1 and @num_pages > 0
      return redirect_to: @url_for "submissions_tags", game: Submissions.games\to_name(@game), page: @num_pages

    return render: "submissions_tags"

  [view: "/:game/submission/:id[%d]"]: respond_to {
    before: =>
      @game = Submissions.games\for_db(@params.game)
      if not @game
        return status: 404

    GET: =>
      if @submission = Submissions\find id: @params.id
        if @submission.user_id
          if user = Users\find id: @submission.user_id
            @creator = user.name
        return render: "submissions_view"

      else
        @session.message = "No such submission."
        -- TODO add session messages to layout
        return redirect_to: @url_for "submissions_index", Submissions.games\to_name(@params.game)

    POST: =>
      -- TODO verify user has permission to make modifications, save modifications, @message = 'saved'
  }
