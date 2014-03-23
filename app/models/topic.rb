class Topic < ActiveRecord::Base
  def topic_list
    @topic_list ||= TopicList.new self
  end
end
