# == Schema Information
#
# Table name: courses
#
#  id         :bigint           not null, primary key
#  desc       :text
#  lecturer   :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Course < ApplicationRecord
  has_many :chapters, inverse_of: :course, dependent: :destroy
  accepts_nested_attributes_for :chapters, reject_if: :all_blank, allow_destroy: true
  validates_presence_of :name, :lecturer, :chapters
end
