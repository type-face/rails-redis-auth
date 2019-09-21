# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:subject) { described_class.new(username: 'test', password: '123123') }

  describe '#initialize' do
    it 'sets username' do
      expect(subject.username).to eq 'test'
    end
    it 'sets password' do
      expect(subject.password).to eq '123123'
    end
  end

  it 'saves username to username set' do
    subject.save
    expect(described_class.usernames).to include subject.username
  end

  it 'saves password using password:{username} key' do
    subject.save
    expect(Redis::Value.new("password:#{subject.username}").value)
      .to eq subject.password
  end

  describe '.find' do
    it 'returns User object if found' do
      subject.save
      expect(described_class.find(subject.username).class).to eq subject.class
    end
    it 'returns User object with correct username' do
      subject.save
      expect(described_class.find(subject.username).username).to eq subject.username
    end
    it 'returns User with correct password' do
      subject.save
      expect(described_class.find(subject.username).password).to eq subject.password
    end
  end
end
