require 'cinch'

bot = Cinch::Bot.new do
  configure do |c|
    c.nick='wikibot'
    c.server = "irc.appno.de"
    c.channels = ["#wikibot","#wiki"]
  end

  ops = Array.new
  chanops = ["larsg","cSmith","Igel"]


  w = File.open("persist.txt")
  w.each_line {|line|
    ops.push line
  }

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end
  on :message, /^!whois (.+)$/ do |m, target|
  user = User(target)
  m.reply "%s is named %s and connects from %s" % [user.nick, user.name, user.host]
  end

  on :message, /^!ip (.+)$/ do |m, target|
  user = User(target)
  m.reply "%s" % [user.host]
  end

  on :message, /^!wiki op add (.+)$/ do |m, target|
  user = User(target)
    if chanops.include?(m.user.nick)
      ops.push('{"username" : "%s", "fcip" : "%s"}' % [user.name, user.host])
      m.reply "%s added to op array" % [user.host]
    else
      m.reply("You don't have permission to do that.")
    end
  end

  on :message, "!wiki list ops" do |m|
  m.reply "Listing:"
    for obj in ops do
      m.reply "%s" % [obj]
    end
  end
  on :message, "!wiki flush" do |m|
  File.open("persist.txt", "w+") do |f|
  ops.each { |element| f.puts(element) }
  end
  m.reply "Flushed!"
  end
end 
bot.start
