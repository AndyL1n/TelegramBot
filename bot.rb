require 'telegram_bot'

=begin
ruby bot.rb
=end

begin
    
    # telegram bot token which @botfather generated
    botToken = ''

    # Authority telegram username。 eq. @AndyL1n -> AndyL1n
    authUsers = ['']

    bot = TelegramBot.new(token: botToken)
    
    puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] 開始監聽"
    
    bot.get_updates(fail_silenty: true) do |message|

        puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] @#{message.from.username}: #{message.text}"
        command = message.get_command_for(bot)

        if authUsers.include?("#{message.from.username}")
            message.reply do |reply|
            case command
            when /greeting/i
                reply.text = "@#{message.from.username}\nHello"
            when /cmd/i
                # 執行 terminal 指令..
                system("<Any thing you wanna do...>")
                reply.text = "@#{message.from.username}\nCustom command"
            else
                reply.text = "@#{message.from.username}\n未知的指令: #{command.inspect}"
            end

            puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] sending #{reply.text.inspect} to @#{message.from.username}"
            reply.send_with(bot)
            end
        else
            bot.send_message(chat_id: message.chat.id, text: "@#{message.from.username} 沒有權限")
            puts "@#{message.from.username} 沒有權限"
        end
        
    end
    
rescue
    puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] 發生錯誤，執行 retry"
    retry
    
end

