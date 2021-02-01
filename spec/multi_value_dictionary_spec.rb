# frozen_string_literal: true

RSpec.describe MultiValueDictionary do
  before(:each) do
    subject { MultiValueDictionary.new }
  end

  describe "#add" do
    context "when a valid key, value pair is provided" do
      let(:result_dict) { { "foo" => ["bar"] } }
      it "adds the pair to dictionary" do
        subject.add("foo", "bar")
        expect(subject.instance_variable_get(:@dict)).to eq result_dict
      end
    end

    context "when a key already has a list of values" do
      let(:result_dict) { { "foo" => %w[bar lol yo] } }
      it "adds the new value to list" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        subject.add("foo", "yo")

        expect(subject.instance_variable_get(:@dict)).to eq result_dict
      end
    end

    context "when a value already exists in the list of values for the key" do
      it "errors out when a duplicate value is attempted to  be added" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        expect { subject.add("foo", "lol") }.to raise_error MultiValueDictionary::DuplicateValueError
      end
    end
  end

  describe "#remove" do
    context "when the key value pair does exist on the dictionary" do
      let(:result_dict) { { "foo" => ["bar"] } }
      it "removes that value from values list" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        subject.remove("foo", "lol")
        expect(subject.instance_variable_get(:@dict)).to eq result_dict
        subject.remove("foo", "bar")
        subject.add("yola", "yikes")
        expect(subject.instance_variable_get(:@dict)["foo"]).to eq nil
        expect(subject.instance_variable_get(:@dict)["yola"]).to eq ["yikes"]
      end
    end

    context "when the Key doesn't exist" do
      it "raises an error" do
        subject.add("yola", "yikes")
        expect { subject.remove("foo", "bar") }.to raise_error MultiValueDictionary::KeyUnavailableError
      end
    end

    context "when the value doesn't exist" do
      it "raises an error" do
        subject.add("yola", "yikes")
        subject.add("foo", "lol")
        expect { subject.remove("foo", "bar") }.to raise_error MultiValueDictionary::ValueUnavailableError
      end
    end
  end

  describe "#members" do
    context "when the key does exist in the dictionary" do
      let(:result) { %w[bar lol] }
      it "lists the values corresponding to the key" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        subject.add("yola", "yikes")
        expect(subject.members("foo")).to eq result
      end
    end

    context "when the key doesn't exist in  dictionary" do
      it "raise an error" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        expect { subject.members("lol") }.to raise_error MultiValueDictionary::KeyUnavailableError
      end
    end
  end

  describe "#keys" do
    it "lists all the keys in the dictionary" do
      subject.add("foo", "bar")
      subject.add("foo", "lol")
      subject.add("yola", "yikes")
      expect(subject.keys).to eq %w[foo yola]
    end
  end

  describe "remove_all" do
    context "when the key exists" do
      let(:result_dict) { { "yola" => ["yikes"] } }
      it "removes all the values of a key and the key from dictionary" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        subject.add("yola", "yikes")
        subject.add("foo", "zam")
        subject.remove_all("foo")
        expect(subject.instance_variable_get(:@dict)).to eq result_dict
      end
    end

    context "when key doesn't exist" do
      it "raises an error" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        expect { subject.remove_all("yola") }.to raise_error MultiValueDictionary::KeyUnavailableError
      end
    end
  end

  describe "#clear" do
    let(:result) { {} }
    it "clears out  all the dictionary" do
      subject.add("foo", "bar")
      subject.add("foo", "lol")
      subject.add("yola", "yikes")
      subject.add("foo", "zam")
      subject.clear
      expect(subject.instance_variable_get(:@dict)).to eq result
    end
  end

  describe "#key_exists?" do
    context "when the key exists" do
      it "returns true" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        subject.add("yola", "yikes")
        expect(subject.key_exists?("foo")).to eq true
      end
    end

    context "when the key doesn't exist" do
      it "returns false" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        subject.add("yola", "yikes")
        expect(subject.key_exists?("jam")).to eq false
      end
    end
  end

  describe "#value_exists?" do
    context "when the key doesn't exist" do
      it "returns false" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        expect(subject.value_exists?("jam", "bar")).to eq false
      end
    end

    context "when the value doesn't exist in the given key" do
      it "returns false" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        subject.add("jam", "jake")
        expect(subject.value_exists?("jam", "bar")).to eq false
      end
    end

    context "when the value exists in the given key" do
      it "returns true" do
        subject.add("foo", "bar")
        subject.add("foo", "lol")
        subject.add("jam", "jake")
        expect(subject.value_exists?("foo", "bar")).to eq true
      end
    end
  end

  describe "#all_members" do
    it "returns list of values from all the key value pairs" do
      subject.add("foo", "bar")
      subject.add("foo", "lol")
      subject.add("jam", "jake")
      subject.add("pet", "dump")
      expect(subject.all_members).to eq %w[bar lol jake dump]
    end
  end

  describe "#items" do
    let(:result) { [{ "foo" => "bar" }, { "foo" => "lol" }, { "jam" => "jake" }, { "pet" => "dump" }] }
    it "return list of all individual value pairs" do
      subject.add("foo", "bar")
      subject.add("foo", "lol")
      subject.add("jam", "jake")
      subject.add("pet", "dump")
      expect(subject.items).to eq result
    end

    context "when the dictionary is empty" do
      it "returns empty list" do
        expect(subject.items).to eq []
      end
    end
  end
end
