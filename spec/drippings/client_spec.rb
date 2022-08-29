RSpec.describe Drippings::Client do
  let(:client) { described_class.new }
  let(:name) { 'Lead::Followup' }

  before do
    client.register(name, LeadFollowupJob, -> { Lead.all })
  end

  describe '#kickoff' do
    subject(:kickoff) { client.kickoff }

    it 'enqueues Dripping::ScheduleJob with all registered drips' do
      expect { kickoff }.to have_enqueued_job(Drippings::ScheduleJob).with(name)
    end
  end

  describe '#schedule' do
    subject(:schedule) { client.schedule(name) }

    let!(:lead) { create(:lead) }

    context 'without an existing scheduling' do
      it 'creates a scheduling' do
        expect { schedule }.to change(Drippings::Scheduling.where(name: name, resource: lead), :count)
      end

      it 'enqueues a LeadFollowupJob' do
        expect { schedule }.to have_enqueued_job(LeadFollowupJob)
      end
    end

    context 'with an existing scheduling' do
      before { create(:scheduling, name: name, resource: lead) }

      it 'does not create a scheduling' do
        expect { schedule }.not_to change(Drippings::Scheduling.where(name: name, resource: lead), :count)
      end

      it 'does not enqueue a LeadFollowupJob' do
        expect { schedule }.not_to have_enqueued_job(LeadFollowupJob)
      end
    end
  end
end
