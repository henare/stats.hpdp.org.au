require 'mechanize'
require 'pry'

BASE_URL = 'http://stats.hpdp.org.au/'

desc "Build NPC pages"
task :npc do
  agent = Mechanize.new
  page = agent.get BASE_URL + 'NickPower.cfm?year=2016'
  puts <<~PAGE
    ---
    layout: npc
    ---
    #{page.search('table')[1]}
    #{page.search('table')[2]}
  PAGE
end
