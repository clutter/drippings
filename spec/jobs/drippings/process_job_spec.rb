RSpec.describe Drippings::ProcessJob do
  let(:job) { described_class.new }
  let(:args) { ['some_arg'] }
  let(:kwargs) { { some: 'kwarg' } }

  describe '#perform' do
    subject(:perform) { job.perform(scheduling, *args, **kwargs) }

    before { allow(job).to receive(:process) }

    context 'with an unprocessed scheduling' do
      let(:scheduling) { create(:scheduling) }

      it 'processes the scheduling' do
        expect { perform }.to change(scheduling, :processed_at?).from(false).to(true)
      end

      it 'calls process on the resource' do
        perform
        expect(job).to have_received(:process).with(scheduling.resource, *args, **kwargs)
      end
    end

    context 'with a processed scheduling' do
      let(:scheduling) { create(:scheduling, :processed) }

      it 'does not process the scheduling' do
        expect { perform }.not_to change(scheduling, :processed_at)
      end

      it 'does not call process on the resource' do
        perform
        expect(job).not_to have_received(:process).with(scheduling.resource)
      end
    end
  end
end
