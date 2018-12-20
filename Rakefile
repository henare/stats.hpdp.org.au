require 'mechanize'
require 'pry'
require 'fileutils'

BASE_URL = 'http://stats.hpdp.org.au/'

desc "Build NPC pages"
task :npc do
  agent = Mechanize.new
  year = '2015'
  source_url = "#{BASE_URL}NickPower.cfm?year=#{year}"
  target_file = File.join(File.dirname(__FILE__), year, 'npc', 'index.html')

  page = agent.get(source_url)

  puts "Saving #{target_file}..."
  FileUtils.mkdir_p(File.dirname(target_file))
  File.open(target_file, 'w') do |file|
    file.write <<~PAGE
      ---
      layout: npc
      ---
      #{page.search('table')[1]}
      #{page.search('table')[2]}
    PAGE
  end
end
