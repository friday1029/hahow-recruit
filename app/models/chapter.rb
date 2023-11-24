# == Schema Information
#
# Table name: chapters
#
#  id         :bigint           not null, primary key
#  name       :string
#  seq        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#
# Indexes
#
#  index_chapters_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
class Chapter < ApplicationRecord
  belongs_to :course
  has_many :units, inverse_of: :chapter, dependent: :destroy
  accepts_nested_attributes_for :units, reject_if: :all_blank, allow_destroy: true
  validates_presence_of :name, :units
end
