require 'octokit'
require './schedule'
require './issue_calculator'
require './config'

def find_milestone(client, milestone_name)
  client.list_milestones(config.repository_name).find { |m| m.title == config.milestone_name }
end

def milestone_issues(client, milestone_number, state)
  client.list_issues(config.repository_name, milestone: milestone_number, state: state)
end

def put_line(title, value)
  printf("%-20s: %s\n",title, value)
end

def config
  Config.instance
end

client = Octokit::Client.new access_token: config.token

milestone = find_milestone(client, config.milestone_name)

s = Schedule.new(milestone.due_on.to_date)

issues_calc        = IssueCalculator.new(client, milestone_issues(client, milestone.number, 'open'))
closed_issues_calc = IssueCalculator.new(client, milestone_issues(client, milestone.number, 'closed'))

puts('################################################')
put_line('マイルストーン', config.milestone_name)
put_line('作業開始日', s.started_on)
put_line('実装終了日', s.due_on)
put_line('総作業日数', "#{s.total_days}日")
put_line('消化日数', "#{s.worked_days}日")
put_line('残日数', "#{s.remaining_days}日")
put_line('残ポイント', issues_calc.point)
put_line('終了ポイント', closed_issues_calc.point)
put_line('現在スループット', "#{closed_issues_calc.throughput(s.worked_days)} / 日")
put_line('初期想定スループット', "#{config.default_throughput} / 日")
put_line('リームーポイント', "#{issues_calc.point - (s.remaining_days * closed_issues_calc.throughput(s.worked_days))}")
puts('################################################')
