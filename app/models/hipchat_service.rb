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
#

class HipChatService < Service
  attr_accessible :project_url

  validates :project_url, presence: true, if: :activated?
  validates :token, presence: true, if: :activated?

  after_save :compose_service_hook, if: :activated?

  def compose_service_hook
    hook = service_hook || build_service_hook
    hook.url = project_url
    hook.save
  end

  def execute(data)
    puts "*** TADA: Execute got called with #{data}"
  end

  def execute_async(data)

  end
end
