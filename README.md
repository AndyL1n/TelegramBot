# TelegramBot
Use Ruby to set command actions triggered by the bot that @botfather created

## Telegram-Jenkins 自動包版指令機器人 - bot_V2.rb

### 啟動方法
```
cd /TelegramBot

ruby bot_V2.rb
```

若返回以下錯誤  
```
/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- telegram_bot (LoadError)
    from /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
    from jenkinsBot.rb:1:in `<main>'
```
先執行   
```
bundle
```
來安裝所需的 gem 和 frameworks  


### 參數說明
利用 Jenkins 遠端觸發建置的方法來觸發自動包版  

* botToken: 使用 `@botfather` 新增的 bot 所取得的 `token`   
* authUsers: 可使用 command 的使用者 username  


### 可參考資料
* [How to Build Your First Telegram Bot: A Guide for Absolute Beginners](https://www.process.st/telegram-bot/)  
