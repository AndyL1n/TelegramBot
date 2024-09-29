require 'telegram/bot'

# telegram bot token
botToken = ''
# jenkins 使用者帳號密碼
jenkinsCredit = " -u user:pwd"
# 有權限的 Telegram username
authUsers = ['', '']
#authChatIDs = ['-724702021']

JenkinsDomain = "http://192.168.201.xx:8080/job/"

JenkinsToken = "/build?token=test_token"

domain = ""
token = ""

#callback
All = 'All'
Pro = 'Pro'
Dev = 'Dev'

cancelAction = 'cancelAction'


AllButton  = Telegram::Bot::Types::InlineKeyboardButton.new(
	text: '全部打包',
	callback_data:All
)
ProButton = Telegram::Bot::Types::InlineKeyboardButton.new(
	text: '正式',
	callback_data:Pro
)
DevButton = Telegram::Bot::Types::InlineKeyboardButton.new(
	text: '測試',
	callback_data:Dev
)

cancelButton = Telegram::Bot::Types::InlineKeyboardButton.new(
    text: '取消',
    callback_data:cancelAction
)

# 鍵盤
TestKeyboard = [
	[DevButton, ProButton],
	[AllButton],
    [cancelButton]
]


TestMarkup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: TestKeyboard)


begin
puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] 開始監聽"

Telegram::Bot::Client.run(botToken) do |bot|
	bot.listen do |message|

		if authUsers.include?("#{message.from.username}")


			case message

  			when Telegram::Bot::Types::Message
			puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] @#{message.from.username}: #{message.text}"
			case message.text
			when /ios/i
				domain = JenkinsDomain
				token = JenkinsToken
				bot.api.send_message(chat_id: message.chat.id, text: 'iOS 自動打包', reply_markup: iOSMarkup)
			#when /android/i
			#	domain = androidJenkinsDomain
			#	token = androidJenkinsToken
			#	bot.api.send_message(chat_id: message.chat.id, text: 'Android 自動打包', reply_markup: androidMarkup)
			end
			
  			when Telegram::Bot::Types::CallbackQuery

  			currentTime = "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}]"

  			actionMessage = ""

  			apiCurl = ""

  			job = ""

			case message.data
			when Pro
				apiCurl = "'#{domain}workspace_pro#{token}'#{jenkinsCredit}"
				actionMessage = "[iOS] 正式版 準備自動打包..."
			when Dev
				apiCurl = "'#{domain}workspace_dev#{token}'#{jenkinsCredit}"
				actionMessage = "[iOS] 測試版 準備自動打包..."
			
			when All

				apiCurl = "'#{domain}workspace_pro#{token}' '#{domain}workspace_dev#{token}' #{jenkinsCredit} "

				actionMessage = "[iOS] 所有版本 準備自動打包..."
			
			when cancelAction
				puts "取消動作"
			end

			if actionMessage.empty? == false
                puts currentTime + actionMessage + "@chatID:#{message.message.chat.id}"
                bot.api.send_message(chat_id: message.message.chat.id, text: actionMessage)
                system("curl -I #{apiCurl}")
			end

			begin
				# 關閉選項按鈕
				# bot.api.edit_message_reply_markup(chat_id: message.message.chat.id, message_id: message.message.message_id, reply_markup: nil)
				bot.api.delete_message(chat_id: message.message.chat.id, message_id: message.message.message_id)
			rescue Telegram::Bot::Exceptions::ResponseError => error
				puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] 錯誤：#{error.message}"
			end

  			end
		else
			puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] @#{message.from.username} 沒有權限"
		end

	end
end

rescue Telegram::Bot::Exceptions::ResponseError => error
	# rescue 攔截錯誤
	puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] 發生錯誤，執行 retry \n[Error Message]: #{error.message}"
	# retry 重新執行 begin 中的程式
	retry
end
