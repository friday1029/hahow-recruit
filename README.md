# README  
  
* 如何執行這個 API server  
  - Servers  
    - 己部署網址  
      `https://hahow.davidcheng.tw/api/v1`  
    - 本機執行  
      ```
      $ git clone https://github.com/friday1029/hahow-recruit.git
      $ cd hahow-recruit
      $ foreman s
      # http://localhost:3000/api/v1
      ```
  - 課程列表  
    `GET /courses`  
    **No Parameters**  
    - 查詢成功回傳範例
    ```
    {
      "courses": [{
          "id": 1,
          "name": "course_name_1",
          "lecturer": "course_lecturer_1",
          "desc": "course_desc_1",
          "created_at": "2023-11-24T09:46:11.462+08:00",
          "updated_at": "2023-11-24T09:48:38.496+08:00",
          "chapters": [{
              "id": 1,
              "name": "chapter_name_1",
              "course_id": 1,
              "seq": 1,
              "created_at": "2023-11-24T09:46:11.467+08:00",
              "updated_at": "2023-11-24T09:46:11.467+08:00",
              "units": [{
                  "id": 1,
                  "name": "unit_name_1",
                  "desc": "unit_desc_1",
                  "content": "unit_content_1",
                  "chapter_id": 1,
                  "seq": 1,
                  "created_at": "2023-11-24T09:46:11.470+08:00",
                  "updated_at": "2023-11-24T09:46:11.470+08:00"
              }]
          }]
      }]
    }
    ```
  - 課程詳細資訊  
    `GET /courses/{course Id}`  
    **No Parameters**  
    - 查詢成功回傳範例
    ```
      {
        "course": {
            "id": 1,
            "name": "course_name_1",
            "lecturer": "course_lecturer_1",
            "desc": "course_desc_1",
            "created_at": "2023-11-24T09:46:11.462+08:00",
            "updated_at": "2023-11-24T09:48:38.496+08:00",
            "chapters": [{
                "id": 1,
                "name": "chapter_name_1",
                "course_id": 1,
                "seq": 1,
                "created_at": "2023-11-24T09:46:11.467+08:00",
                "updated_at": "2023-11-24T09:46:11.467+08:00",
                "units": [{
                    "id": 1,
                    "name": "unit_name_1",
                    "desc": "unit_desc_1",
                    "content": "unit_content_1",
                    "chapter_id": 1,
                    "seq": 1,
                    "created_at": "2023-11-24T09:46:11.470+08:00",
                    "updated_at": "2023-11-24T09:46:11.470+08:00"
                }]
            }]
        },
        "status": "ok"
      }
    ```
    - 查詢失敗回傳範例    
    ```
      {
        "message":"物件不存在",
        "status":"ng"
      }
    ```
  - 建立課程  
    `post /courses`  
    **Parameters 型態**  
      params[course]: name(string), desc(text), lecturer(string),   
      params[course][chapters_attributes]: [name(string), seq(integer), _destroy(boolean)]  
      params[course][chapters_attributes][units_attributes]: [name(string), desc(text), content(text), seq(integer), _destroy(boolean)]  
    **Parameters 範列**
    ```
      "course": {
          "name": "course_name_1",
          "lecturer": "course_lecturer_1",
          "desc": "course_desc_1",
          "chapters_attributes": [{
              "name": "chapter_name_1",
              "seq": 1,
              "units_attributes": [{
                  "name": "unit_name_1",
                  "desc": "unit_desc_1",
                  "content": "unit_content_1",
                  "chapter_id": 1,
                  "seq": 1
              }]
          }]
      }
    ```
    - 建立成功回傳範例
    ```
      {
        "course": {
            "id": 1,
            "name": "course_name_1",
            "lecturer": "course_lecturer_1",
            "desc": "course_desc_1",
            "created_at": "2023-11-24T09:46:11.462+08:00",
            "updated_at": "2023-11-24T09:48:38.496+08:00",
            "chapters": [{
                "id": 1,
                "name": "chapter_name_1",
                "course_id": 1,
                "seq": 1,
                "created_at": "2023-11-24T09:46:11.467+08:00",
                "updated_at": "2023-11-24T09:46:11.467+08:00",
                "units": [{
                    "id": 1,
                    "name": "unit_name_1",
                    "desc": "unit_desc_1",
                    "content": "unit_content_1",
                    "chapter_id": 1,
                    "seq": 1,
                    "created_at": "2023-11-24T09:46:11.470+08:00",
                    "updated_at": "2023-11-24T09:46:11.470+08:00"
                }]
            }]
        },
        "status": "ok"
      }
    ```
    - 建立失敗回傳範例    
    ```
      {
        "message":"errors full_messages",
        "status":"ng"
      }
    ```
  - 編輯課程  
    `put /courses/{course Id}`  
    **Parameters 型態**  
    params[course]: name(string), desc(text), lecturer(string),   
    params[course][chapters_attributes]: [id(integer), name(string), seq(integer), _destroy(boolean)]  
    params[course][chapters_attributes][units_attributes]: [id(integer), name(string), desc(text), content(text), seq(integer), _destroy(boolean)]  
    **Parameters 範列**
    ```
      {
        "course": {
            "name": "edit_course_name_1",
            "lecturer": "edit_course_lecturer_1",
            "desc": "edit_course_desc_1",
            "chapters_attributes": [{
                "id": 1,
                "name": "edit_chapter_name_1",
                "seq": 10,
                "units_attributes": [{
                    "id": 1,
                    "name": "edit_unit_name_1",
                    "desc": "ediedit_t_unit_desc_1",
                    "content": "edit_unit_content_1",
                    "seq": 10,
                }]
            }]
        }
      }
    ```
    - 編輯成功回傳範例
    ```
      {
        "course": {
            "id": 1,
            "name": "edit_course_name_1",
            "lecturer": "edit_course_lecturer_1",
            "desc": "edit_course_desc_1",
            "created_at": "2023-11-26T20:53:54.888+08:00",
            "updated_at": "2023-11-26T22:55:27.246+08:00",
            "chapters": [{
                "id": 1,
                "name": "edit_chapter_name_1",
                "course_id": 1,
                "seq": 10,
                "created_at": "2023-11-26T20:53:54.893+08:00",
                "updated_at": "2023-11-26T22:55:27.249+08:00",
                "units": [{
                    "id": 1,
                    "name": "edit_unit_name_1",
                    "desc": "ediedit_t_unit_desc_1",
                    "content": "edit_unit_content_1",
                    "chapter_id": 1,
                    "seq": 10,
                    "created_at": "2023-11-26T20:53:54.898+08:00",
                    "updated_at": "2023-11-26T22:55:27.252+08:00"
                }]
            }]
        },
        "status": "ok"
      }
    ```
    - 編輯失敗回傳範例    
    ```
      {
        "message":"errors full_messages",
        "status":"ng"
      }
    ```
  - 刪除課程  
    `DELETE /courses/{course Id}`  
    **No Parameters**  
    - 刪除成功回傳範例
    ```
      {
        "message":"Course was successfully destroyed",
        "status":"ok"
      }
    ```
    - 刪除失敗回傳範例
    ```
      {
        "message":"errors full_messages",
        "status":"ng"
      }
    ```
* 專案的架構，API server 的架構邏輯
  **Model**
  - Course: 課程  
    每個課程能有多個章節(has_many chapters)  
  - Chapter: 章節  
    每個章節屬於一個課程(belongs_to course)  
    每個章節能有多個單元(has_many units)  
  - Unit: 單元  
      每個單元屬於一個章節(belongs_to chapter)

  **Route**  
  ```
  namespace :api do 
    namespace :v1 do 
      resources :courses, except: [:new, :edit]
    end
  end
    ```
  `api`表示是用於api的路徑  
  `v1`表示該api的版本,若後續有進版,將改為v2,以此類推.  
  使用不同路徑是為了避免進版新增/修改時,  
  影響到已經在使用api的其他程式.  
  
* 使用到的第三方 Gem 及功能簡介  
  - gem 'foreman'  
    便於批次執行多個指令  
    開發過程中常需同時執行 web server 及 webpack server  
  - gem 'annotate'  
    自動在各類型檔案中加上架構的註解  
    開發過程中主要用在 model 上,  
    便於知道該 model 有哪些欄位及類型.  
  - gem 'rspec-rails'  
    測試程式的測試程式.  
  - gem 'factory_bot_rails'  
    便於快速產生 model 的實體,  
    供開發測試使用.  
  - gem 'faker'  
    產生各式假資料供開發測試使用  
  - gem 'rest-client'  
    用來執行 HTTP and REST 的 client 端.  
    便於在程式中執行不同 method 的對外操作,如 get, put, post, delete....  
* 程式碼中寫註解的原則及狀況
  - 該語法在專案中不常被使用時
  - 該功能有慣用寫法但不使用時
  - 該段程式碼是用來先驗證想法,後續可行再重構
  - 發現bug但無法修復時,留下重現方法或繞過方法
  - 程式碼可重構的方向
  - 複雜邏輯或功能的說明
* 當有多種實作方式時，如何選撢使用何種方式實作
  - 如果該功能被使用頻率高，則盡可能選撢高效率的，避免效能頻頸
  - 如果該功能只是驗證想法，則使用越快能做出來的方法越好，後續再考慮重構與否
  - 如果該功能後續有很多的擴充需求，先找看有沒有套件符合需求，若無則盡可能用完整常見的方式去實作，利於後續擴充功能
  - 如果該功能後續不會有太多的擴充需求，有類似套件也會考慮自行實作，避免專案中有太多不使用的程式碼，增加出問題的可能
  - 若類似功能在其他類似專案己經有使用過，會優先考慮使用。
* 在這份專案中你遇到的困難、問題，以及解決的方法
