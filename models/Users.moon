import Model from require "lapis.db.model"

class Users extends Model
  @constraints: {
    digest: (value) =>
      if not value
        return "Digest must exist (was a password entered?)"

      -- digest cannot be properly checked here, as passwords must be checked before they are converted to a digest

    name: (value) =>
      if not value or value\len! < 1
        return "You must enter a username."

      if value\len! > 255
        return "Usernames must be 255 or fewer bytes in length."

      if value\find "%s"
        return "Usernames cannot contain spaces."

      if value\lower! == "admin"
        return "That username is unavailable."

      if Users\find name: value\lower!
        return "That username is unavailable."

    email: (value) =>
      if value
        if value\len! > 255
          return "Email addresses must be 255 or fewer bytes in length."

        if value\find "%s"
          return "Email addresses cannot contain spaces."

        -- NOTE while email verification does not exist, tying emails to an account should not be allowed
        -- if value\len! > 0 and Users\find email: value
        --   return "That email address is already tied to an account."
  }
