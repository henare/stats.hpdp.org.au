require 'mechanize'
require 'pry'
require 'fileutils'

BASE_URL = 'http://stats.hpdp.org.au/'

# This scraping is useful but the page generation should probably be a Jekyll Generator
desc "Build site by scraping from old server"
task :build do
  agent = Mechanize.new
  year = '2015'
  source_url = "#{BASE_URL}NickPower.cfm?year=#{year}"
  target_directory = File.join(File.dirname(__FILE__), year)
  npc_directory = File.join(target_directory, 'npc')

  puts "Building #{year} in #{target_directory}..."
  FileUtils.mkdir_p(npc_directory)

  puts "Saving index..."
  File.open(File.join(target_directory, 'index.html'), 'w') do |file|
    file.write <<~PAGE
      ---
      layout: ladder
      year: #{year}
      ---
    PAGE
  end

  puts "Saving NPC..."
  page = agent.get(source_url)
  File.open(File.join(npc_directory, 'index.html'), 'w') do |file|
    file.write <<~PAGE
      ---
      layout: npc
      year: #{year}
      ---
      #{page.search('table')[1]}
      #{page.search('table')[2]}
    PAGE
  end
end
