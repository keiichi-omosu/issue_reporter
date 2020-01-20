require 'yaml'

class Config
  attr_reader :repository_name, :milestone_name, :token, :started_on, :default_throughput, :work_start_time, :work_end_time

  class << self

    def setup(path = 'config.yml')
      @path = path
      @instance = new(@path)
    end

    def instance
      @instance ||= setup
    end
  end

  def initialize(path)
    config = YAML.load_file(path)

    @repository_name = config['repository_name']
    @milestone_name = config['milestone_name']
    @token = config['token']
    @started_on = config['started_on']
    @default_throughput = config['default_throughput']
    @work_start_time = config['work_start_time']
    @work_end_time = config['work_end_time']
  end
end
