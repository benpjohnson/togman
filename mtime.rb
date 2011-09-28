require "rubygems"
require "patron"
require "pp"
require "json"
require 'savon'
require 'highline/import'
require 'trollop'
require 'yaml'

require 'toggl.rb'
require 'mantis.rb'

configfile = ENV['HOME'] + '/.togmanrc'
if !File.file? configfile 
    puts 'Cannot open ' + configfile
    exit
end

config = YAML::load_file configfile
pp config

Savon.configure do |setting|
  setting.log = false            # disable logging
  # config.log_level = :info      # changing the log level
end

opts = Trollop::options do
      opt :dryrun, "Preview time to be logged without saving to Mantis", :short => 'd'
end

if !opts.dryrun
    pass = ask('Password:') {|q| q.echo = '*'}
end

t = Toggl.new config['toggl_api_key'], config['nonbill']
m = Mantis.new config['user'], config['pass'], config['mantis_url']

if !opts.dryrun
    t.today.each do |ims, data|
        if !m.issue_exists ims
            raise "Issue not found #{ims}"
        end
    end
end

total = 0
free = []
t.today.each do |ims, data|
    data.each do |item|
        if !opts.dryrun
            m.add_note ims, item[:desc], item[:duration]
        end
        p ims.to_s + " " + item[:desc] + " " + item[:duration].to_s + " " + item[:orig].to_s
        total += item[:duration]
    end
end
p "TOTAL: " + total.to_s
