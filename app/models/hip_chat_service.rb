# == Schema Information
#
# Table name: services
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  title       :string(255)
#  token       :string(255)
#  project_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  active      :boolean          default(FALSE), not null
#  project_url :string(255)
#  subdomain   :string(255)
#  room        :string(255)
#

class HipChatService < Service
  attr_accessible :room

  validates :token, presence: true, if: :activated?

  def title
    'HipChat'
  end

  def description
    'Group chat and IM built for teams'
  end

  def to_param
    'hip_chat'
  end

  def fields
    [
      { type: 'text', name: 'token',     placeholder: '' },
      { type: 'text', name: 'room',      placeholder: '' }
    ]
  end

  def execute(push_data)
    message = build_message(push_data)
    gate[room].send('GitLab', message, notify: true)
  end

  private

  def gate
    @gate ||= HipChat::Client.new(token)
  end

  def build_message(push)
    ref = push[:ref].gsub("refs/heads/", "")
    before = push[:before]
    after = push[:after]

    message = ""
    message << "[#{project.name_with_namespace}] "
    message << "#{push[:user_name]} "

    if before =~ /000000/
      message << "pushed new branch #{ref} \n"
    elsif after =~ /000000/
      message << "removed branch #{ref} \n"
    else
      message << "pushed #{push[:total_commits_count]} commits to #{ref}. "
      message << "#{project.web_url}/compare/#{before}...#{after}"
    end

    message
  end
end