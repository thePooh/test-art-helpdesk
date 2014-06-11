require 'rails_helper'

describe Ticket do
  context "creation" do
    it "should have unique uid" do
      ticket_1 = build_stubbed(:ticket)
      ticket_2 = build_stubbed(:ticket)

      ticket_1.uid.should_not == ticket_2.uid
    end
  end
end
