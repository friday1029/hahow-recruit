# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
#  name       :string
#  seq        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer          not null
#
# Indexes
#
#  index_chapters_on_course_id  (course_id)
#
# Foreign Keys
#
#  course_id  (course_id => courses.id)
#
class Chapter < ApplicationRecord
  belongs_to :course
end
