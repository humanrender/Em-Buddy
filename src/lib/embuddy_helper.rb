module EmBuddyHelper
  def node px = 10, em = 1,  &block
    render "partials/node", {:px=>px, :em=>em}, &block
  end
end