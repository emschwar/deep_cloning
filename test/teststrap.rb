require 'rubygems'
require 'riot'

require 'active_record'


config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.configurations = {'test' => config[ENV['DB'] || 'sqlite3']}
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'fixtures'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

