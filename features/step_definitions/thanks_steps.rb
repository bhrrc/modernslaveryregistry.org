Then(/^(Vicky) should see a thank you message$/) do |actor|
  expect(actor.visible_text).to include('Thank you!')
end

module CanSeeText
  def visible_text
    page.text
  end
end

class Visitor
  include CanSeeText
end
