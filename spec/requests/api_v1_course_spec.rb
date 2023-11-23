require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :request do
  before :all do
    # 建立測試用課程資料
    # 因為 model 有檢查建立課程同時要有章節跟單元,如果直接用 create 會出錯,所以先 build 好再 save.
    rand(1..5).times.each do |i|
      # chapters 如果直接使用 build_list,會造成產生出來的 chapters 只有一組會正常有 units
      # 所以用手工用 map 造 chapters
      # courses 不使用 build_list 也同理
      course = FactoryBot.build(:course, chapters: rand(1..5).times.map{|i| (FactoryBot.build(:chapter, units: FactoryBot.build_list(:unit,rand(1..5)))) })
      course.save
    end if Course.count == 0
  end
  describe "課程列表" do
    it "課程列表路徑沒有問題" do
      get api_v1_courses_path
      expect(response).to be_successful
    end

    it "課程列表包含所有課程" do
      get api_v1_courses_path
      res = JSON.parse(response.body)
      expect(res.dig('courses').count).to eq(Course.count)
    end

    it "課程資訊包含章節" do
      get api_v1_courses_path
      res = JSON.parse(response.body)
      expect(res.dig('courses').sample.dig("chapters").present?).to be true
    end

    it "章節資訊包含單元" do
      get api_v1_courses_path
      res = JSON.parse(response.body)
      expect(res.dig('courses').sample.dig("chapters").sample.dig("units").present?).to be true
    end
  end

  describe "課程詳細資訊" do
    it "課程詳細資訊路徑沒有問題" do
      get api_v1_course_path(Course.all.sample)
      expect(response).to be_successful
    end

    it "課程詳細資訊包含章節資訊" do
      course = Course.all.sample
      get api_v1_course_path(course)
      res = JSON.parse(response.body)
      res_column_names = (res.dig("course", "chapters").sample.keys - ["units"]).sort
      chapter_column_names = Chapter.column_names.sort
      expect(res_column_names).to eq chapter_column_names
    end

    it "章節資訊包含單元資訊" do
      course = Course.all.sample
      get api_v1_course_path(course)
      res = JSON.parse(response.body)
      res_column_names = res.dig("course", "chapters").sample.dig("units").sample.keys.sort
      unit_column_names = Unit.column_names.sort
      expect(res_column_names).to eq unit_column_names
    end
  end

end
