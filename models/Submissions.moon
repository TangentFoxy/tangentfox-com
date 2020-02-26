import Model, enum from require "lapis.db.model"

class Submissions extends Model
  @timestamp: true

  @games: enum {
    undefined: 0
    ksp: 1
    starmade: 2
    "space-engineers": 3
  }

  @statuses: enum {
    new: 0
    pending: 1
    reviewed: 2
    rejected: 3
    delayed: 4
    priority: 5
    old: 6
    imported: 7
  }

  @constraints: {
    name: (value) =>
      if not value or value\len! < 1
        return "Submissions must have a name."

      if value\len! > 255
        return "Submission names must be 255 or fewer characters in length."

    link: (value) =>
      if not value or value\len! < 1
        return "Submissions must have a link."
  }
