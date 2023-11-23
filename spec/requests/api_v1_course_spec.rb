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

  let(:course_attributes) { 
    course = FactoryBot.build(:course, chapters: rand(1..5).times.map{|i| (FactoryBot.build(:chapter, units: FactoryBot.build_list(:unit,rand(1..5)))) })
    course.attributes.merge(
      "chapters_attributes" => course.chapters.map{ |chapter| chapter.attributes.merge(
        "units_attributes" => chapter.units.map{ |unit| unit.attributes }
      )}
    )
  } # let(:course_attributes)

  let(:update_course_attributes) { 
    course = Course.all.sample
    course.attributes.merge(
      "chapters_attributes" => course.chapters.map{ |chapter| chapter.attributes.merge(
        "units_attributes" => chapter.units.map{ |unit| unit.attributes }
      )}
    )
  } # let(:update_course_attributes)

  # ==========
  # 課程列表
  # ==========
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

  # ==========
  # 課程詳細資訊
  # ==========
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

  # ==========
  # 建立課程
  # ==========
  describe "建立課程" do
    it "建立課程路徑沒有問題" do
      post api_v1_courses_path(course: { name: "name"}) # 測路徑, params 不重要
      expect(response).to be_successful
    end

    it "課程、章節、單元同時被建立" do
      post api_v1_courses_path(course: course_attributes)
      res = JSON.parse(response.body)
      expect(res.dig("course", "chapters").size).to be > 0
      expect(res.dig("course", "chapters").sample.dig("units").size).to be > 0
    end

    it "課程必填欄位沒填回傳錯誤" do
      course_attributes["name"] = ""      # 清空課程名稱
      course_attributes["lecturer"] = ""  # 清空講師
      post api_v1_courses_path(course: course_attributes)
      res = JSON.parse(response.body)
      expect(res.dig("status")).to eq "ng"
      expect(res.dig("message")).to eq ["Name can't be blank", "Lecturer can't be blank"]
    end

    it "章節必填欄位沒填回傳錯誤" do
      course_attributes["chapters_attributes"].sample["name"] = "" # 清空章節課程名稱
      post api_v1_courses_path(course: course_attributes)
      res = JSON.parse(response.body)
      expect(res.dig("status")).to eq "ng"
      expect(res.dig("message")).to eq ["Chapters name can't be blank"]
    end

    it "單元必填欄位沒填回傳錯誤" do
      course_attributes["chapters_attributes"].sample["units_attributes"].sample["name"] = "" # 清空單元名稱
      course_attributes["chapters_attributes"].sample["units_attributes"].sample["content"] = "" # 清空單元內容
      post api_v1_courses_path(course: course_attributes)
      res = JSON.parse(response.body)
      expect(res.dig("status")).to eq "ng"
      expect(res.dig("message").sort).to eq ["Chapters units name can't be blank", "Chapters units content can't be blank"].sort
    end

    it "沒有章節參數回傳錯誤" do
      course_attributes.delete("chapters_attributes") # 清空章節
      post api_v1_courses_path(course: course_attributes)
      res = JSON.parse(response.body)
      expect(res.dig("status")).to eq "ng"
      expect(res.dig("message")).to eq ["Chapters can't be blank"]
    end

    it "沒有單元參數回傳錯誤" do
      course_attributes["chapters_attributes"].sample.delete("units_attributes")  # 清空單元
      post api_v1_courses_path(course: course_attributes)
      res = JSON.parse(response.body)
      expect(res.dig("status")).to eq "ng"
      expect(res.dig("message")).to eq ["Chapters units can't be blank"]
    end

    pending "需要儲存「章節」和「單元」的順序"

  end

  # ==========
  # 編輯課程
  # ==========
  describe "編輯課程" do
    it "編輯課程路徑沒有問題" do
      put api_v1_course_path(id: Course.all.sample, course: { name: "name"}) # 測路徑, params 不重要
      expect(response).to be_successful
    end

    it "課程必填欄位沒填回傳錯誤" do
      update_course_attributes["name"] = ""      # 清空課程名稱
      update_course_attributes["lecturer"] = ""  # 清空講師
      put api_v1_course_path(id: update_course_attributes.dig("id"), course: update_course_attributes)
      res = JSON.parse(response.body)
      expect(res.dig("status")).to eq "ng"
      expect(res.dig("message")).to eq ["Name can't be blank", "Lecturer can't be blank"]
    end

    it "章節必填欄位沒填回傳錯誤" do
      update_course_attributes["chapters_attributes"].sample["name"] = "" # 清空章節課程名稱
      put api_v1_course_path(id: update_course_attributes.dig("id"), course: update_course_attributes)
      res = JSON.parse(response.body)
      expect(res.dig("status")).to eq "ng"
      expect(res.dig("message")).to eq ["Chapters name can't be blank"]
    end

    it "單元必填欄位沒填回傳錯誤" do
      update_course_attributes["chapters_attributes"].sample["units_attributes"].sample["name"] = "" # 清空單元名稱
      update_course_attributes["chapters_attributes"].sample["units_attributes"].sample["content"] = "" # 清空單元內容
      put api_v1_course_path(id: update_course_attributes.dig("id"), course: update_course_attributes)
      res = JSON.parse(response.body)
      expect(res.dig("status")).to eq "ng"
      expect(res.dig("message").sort).to eq ["Chapters units name can't be blank", "Chapters units content can't be blank"].sort
    end

    pending "「章節」和「單元」的順序都可以被調整"

  end

  # ==========
  # 刪除課程
  # ==========
  describe "刪除課程" do
    it "刪除課程路徑沒有問題" do
      delete api_v1_course_path(id: Course.all.sample)
      expect(response).to be_successful
    end

    it "刪除課程時, 章節和單元也一起刪除" do
      course = Course.all.sample
      chapter_ids = course.chapters.ids
      unit_ids = course.chapters.map{ |chapter| chapter.units.ids}.flatten
      delete api_v1_course_path(id: course.id)
      expect(Chapter.where(id: chapter_ids).size).to be 0
      expect(Unit.where(id: unit_ids).size).to be 0
    end

    it "要刪除的課程不存在時，回傳錯誤訊息" do
      delete api_v1_course_path(id: (Course.last.id + 1))
      res = JSON.parse(response.body)
      expect(res.dig("status")).to eq "ng"
      expect(res.dig("message")).to eq '物件不存在'
    end
  end

end
