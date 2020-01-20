class IssueCalculator
  attr_reader :point

  def initialize(client, issues)
    @issues = issues
    @client = client

    @point = sum_point
  end

  # 指定された日数に対するスループットを返します
  #
  def throughput(days)
    return Config.instance.default_throughput.to_i if days.zero?
    @point.quo(days).to_f.round
  end

  private

  def sum_point
    points = []
    @issues.each do |issue|
      (issue['labels'] || []).each do |label|
        if label.name =~ /^[0-9]+$/
          points << label.name.to_i
        end
      end
    end
    points.sum
  end
end
