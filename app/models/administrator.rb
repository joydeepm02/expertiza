# Administrator Class
# Subtype of User class
# Author: unknown
class Administrator < User
  QUESTIONNAIRE = [["My instructors' questionnaires", 'list_instructors'],
                   ['My questionnaires', 'list_mine'],
                   ['All public questionnaires', 'list_all']].freeze

  SIGNUPSHEET = [["My instructors' signups", 'list_instructors'],
                 ['My signups', 'list_mine'],
                 ['All public signups', 'list_all']].freeze

  ASSIGNMENT = [["My instructors' assignments", 'list_instructors'],
                ['My assignments', 'list_mine'],
                ['All public assignments', 'list_all']].freeze

  def list_instructors(object_type, user_id)
    object_type.joins("inner join users on " + object_type.to_s.pluralize + ".instructor_id = users.id AND users.parent_id = " + user_id.to_s)
  end

  def list_all(object_type, user_id)
    if !user_id.is_a? Integer
      flash[:error] = "Illegal parameter."
    else
      object_type.where(["instructor_id = ? OR private = 0", user_id])
    end
  end

  # This method gets a questionnaire or an assignment, making sure that current user is allowed to see it.
  def get(object_type, id, user_id)
    if !(id.is_a? Integer and user_id.is_a? Integer)
      flash[:error] = "Illegal parameter."
    else
      object_type.where(["id = ? AND (instructor_id = ? OR private = 0)", id, user_id]) # You are allowed to get it if it is public, or if your id is the one that created it.
    end
  end
end
