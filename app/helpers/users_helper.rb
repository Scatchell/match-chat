module UsersHelper
  def none_if_empty element
    element.nil? ? 'None' : element.to_s
  end
end
