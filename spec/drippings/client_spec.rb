RSpec.describe Drippings::Client do
  let(:client) { described_class.new }
  let(:name) { 'Lead::Followup' }
  let(:phone) { '555-555-5555' }
  let(:transactional) { true }
  let(:wait_until) { nil }

  before do
    client.register(
      name,
      LeadFollowupJob, -> { Lead.all },
      wait_until: wait_until,
      time_zone: ->(lead) { lead.time_zone },
      options: {
        phone: phone,
        transactional: transactional
      }
    )
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
        expect { schedule }
          .to have_enqueued_job(LeadFollowupJob)
          .with(anything, phone: phone, transactional: transactional)
      end
    end

    context 'with a wait' do
      let(:wait_until) { { hour: 16 } } # 4PM

      around do |example|
        travel_to(today, &example)
      end

      context 'when the send time is in the future' do
        let(:today) { Time.parse('2022-08-30 09:00:00 PDT') }

        it 'enqueues a LeadFollowupJob today' do
          expect { schedule }.to have_enqueued_job(LeadFollowupJob).at(Time.parse('2022-08-30 16:00:00 PDT'))
        end
      end

      context 'when the send time is in the past' do
        let(:today) { Time.parse('2022-08-30 17:00:00 PDT') }

        it 'enqueues a LeadFollowupJob tomorrow' do
          expect { schedule }.to have_enqueued_job(LeadFollowupJob).at(Time.parse('2022-08-31 16:00:00 PDT'))
        end
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
