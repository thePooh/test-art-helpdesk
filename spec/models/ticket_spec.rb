require 'rails_helper'

describe Ticket do
  context "creation" do
    it "should have unique uid" do
      ticket_1 = build_stubbed(:ticket)
      ticket_2 = build_stubbed(:ticket)

      expect(ticket_1.uid).to_not eq(ticket_2.uid)
    end

    it "should embed files if created from params" do
      #TODO: implement
    end
  end
end
