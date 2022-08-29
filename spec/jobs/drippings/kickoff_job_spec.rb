RSpec.describe Drippings::KickoffJob do
  let(:job) { described_class.new }

  describe '#perform' do
    subject(:perform) { job.perform }

    it 'calls #kickoff on the main Drippings::Client' do
      allow(Drippings.client).to receive(:kickoff)
      perform
      expect(Drippings.client).to have_received(:kickoff)
    end
  end
end
