# == Schema Information
#
# Table name: units
#
#  id         :integer          not null, primary key
#  content    :text
#  desc       :text
#  name       :string
#  seq        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chapter_id :integer          not null
#
# Indexes
#
#  index_units_on_chapter_id  (chapter_id)
#
# Foreign Keys
#
#  chapter_id  (chapter_id => chapters.id)
#
class Unit < ApplicationRecord
  belongs_to :chapter
  validates_presence_of :name, :content
end
