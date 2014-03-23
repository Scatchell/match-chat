class TopicList
  #todo given the chatroom instead of users idea, may want to change this to store lists of chatrooms
  attr_reader :givers
  attr_reader :takers

  def initialize topic
    @topic = topic
    puts 'in after'
    @givers ||= []
    @takers ||= []
  end

  def add_or_match_giver user
    if @takers.empty?
      @givers.push user
    else
      return @takers.pop
    end
    false
  end

  def add_or_match_taker(user)
    if @givers.empty?
      @takers.push user
    else
      return @givers.pop
    end

    false
  end
end