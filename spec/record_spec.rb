require "spec_helper"

describe Moodwall::Record do
  describe ".repository" do
    it "should initiate default repository" do
      expect(described_class.repository).to be_kind_of(PStore)
    end
  end

  describe ".all" do
    let!(:samples) { create_list :record, 2 }

    subject { described_class.all }

    it "should return Array of all stored records" do
      is_expected.to be_kind_of Array
      is_expected.to eq samples
    end
  end

  describe ".find!" do
    let!(:record) { build :record }

    subject { described_class.find! record.id }

    it "should find record by id" do
      record.save
      is_expected.to eq record
    end

    it "should raise error when no record exists" do
      expect { subject }.to raise_error(Moodwall::RecordNotFoundError)
    end
  end

  describe ".reset" do
    let!(:record) { described_class.new }

    subject { described_class.reset }

    it "should flush all records" do
      expect(described_class.all).to eq []
    end
  end

  describe "#save" do
    let!(:record) { described_class.new }

    it "should return saved object" do
      expect(record.save).to eq record
    end

    it "should set ID for saved object" do
      record.save
      expect(record.id).to be_kind_of Integer
    end

    describe "save record twice" do
      let!(:record) { described_class.new }

      before do
        record.save
        record.save
      end

      it "should store them once" do
        expect(described_class.all.count).to eq 1
      end
    end
  end

  describe "#==" do
    let!(:record)         { create :record }
    let!(:another_record) { create :record }

    describe "compare records by id" do
      context "with same record" do
        it { expect(record == record).to eq true }
      end

      context "with different records" do
        it { expect(record == another_record).to eq false }
      end
    end
  end

  describe "#delete" do
    let!(:record) { create :record }

    it "should return deleted object" do
      expect(record.delete).to eq record
    end

    it "should remove object from database" do
      record.delete
      expect(described_class.all).not_to include record
    end
  end

  describe "#new_record?" do
    subject { record.new_record? }

    context "with new record" do
      let!(:record) { build :record }
      it { is_expected.to eq true }
    end

    context "with persisted record" do
      let!(:record) { create :record }
      it { is_expected.to eq false }
    end
  end
end
