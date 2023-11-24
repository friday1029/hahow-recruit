# README

* 如何執行這個 API server
  - Servers
    `https://hahow.davidcheng.tw/api/v1`
  - 課程列表
    `GET /courses`
    **No Parameters**
  - 課程詳細資訊
    `GET /courses/{course Id}`
    **No Parameters**
  - 建立課程
    `post /courses`
    **Parameters**
    params[course]: name(string), desc(text), lecturer(string), 
    params[course][chapters_attributes]: [name(string), seq(integer), _destroy(boolean)]
    params[course][chapters_attributes][units_attributes]: [name(string), desc(text), content(text), seq(integer), _destroy(boolean)]
  - 編輯課程
    `put /courses/{course Id}`
    **Parameters**
    params[course]: name(string), desc(text), lecturer(string), 
    params[course][chapters_attributes]: [id(integer), name(string), seq(integer), _destroy(boolean)]
    params[course][chapters_attributes][units_attributes]: [id(integer), name(string), desc(text), content(text), seq(integer), _destroy(boolean)]    
  - 刪除課程
    `DELETE /courses/{course Id}`
    **No Parameters**
* 專案的架構，API server 的架構邏輯
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
* 你在程式碼中寫註解的原則，遇到什麼狀況會寫註解
* 當有多種實作方式時，請說明為什麼你會選擇此種方式
* 在這份專案中你遇到的困難、問題，以及解決的方法