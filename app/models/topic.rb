class Topic < ActiveRecord::Base
  #todo given the chatroom instead of users idea, may want to change this to store lists of chatrooms
  attr_reader :givers
  attr_reader :takers

  def giver_has_match?
    initialize_if_not_existing

    !@takers.empty?
  end

  def taker_has_match?
    initialize_if_not_existing

    !@givers.empty?
  end

  def initialize_if_not_existing
    @givers ||= []
    @takers ||= []
  end

  def match_for_giver
    @givers.pop
    @takers.pop
  end

  def add_giver(chatroom)
    @givers.push chatroom
  end

  def add_taker(chatroom)
    @takers.push chatroom
  end

  def match_for_taker
    @takers.pop
    @givers.pop
  end
end