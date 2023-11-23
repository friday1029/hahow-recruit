# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  desc       :text
#  lecturer   :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Course < ApplicationRecord
  validates_presence_of :name, :lecturer
end
