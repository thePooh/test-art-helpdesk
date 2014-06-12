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

    it "should assign properly and create history" do
      user = create(:user)
      ticket = create(:ticket, assignee: user)
      prev_histories_count = ticket.histories.count

      expect {
        expect(ticket.state).to eq(:submitted)

        ticket.assign!

        expect(ticket.prev_state).to eq(:submitted)
        expect(ticket.state).to eq(:assigned)
      }.to change {ticket.histories.count}.by 1
    end

    it "should track change of assignees" do
      user = create(:user)
      user_2 = create(:user)
      ticket = create(:ticket, assignee: user)

      expect { ticket.update(assignee: user_2) }.to change { ticket.histories.count }.by 1
    end
  end
end
