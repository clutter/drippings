RSpec.describe Drippings::ScheduleJob do
  let(:job) { described_class.new }

  describe '#perform' do
    subject(:perform) { job.perform(name) }

    let(:name) { 'Lead::Followup' }

    it 'calls #schedule on the main Drippings::Client' do
      allow(Drippings.client).to receive(:schedule)
      perform
      expect(Drippings.client).to have_received(:schedule).with(name)
    end
  end
end
