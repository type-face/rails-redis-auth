# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:subject) { described_class.new(username: 'test', password: 'password123!@#') }

  describe '#initialize' do
    it 'sets username' do
      expect(subject.username).to eq 'test'
    end
    it 'sets password' do
      expect(subject.password).to eq 'password123!@#'
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :username }
    it 'validates presence of password' do
      subject = User.new(username: 'test', password: '')
      subject.valid?
      expect(subject.errors[:password]).to include "can't be blank"
    end
    it 'validates presence of password' do
      subject = User.new(username: 'test', password: '123')
      subject.valid?
      expect(subject.errors[:password]).to include 'is too short (minimum is 10 characters)'
    end
  end

  it 'saves username to username set' do
    subject.save
    expect(described_class.usernames).to include subject.username
  end

  it 'saves password using password:{username} key' do
    subject.save
    expect(Redis::Value.new("password:#{subject.username}").value)
      .to be_present
  end

  it 'prevents duplicate usernames (case insensitive) from being saved' do
    subject.save
    user2 = User.new(username: subject.username.upcase, password: 'password123!@#')
    raise 'invalid test' unless user2.valid? && user2.save

    expect(User.usernames.size).to eq 1
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
  end

  describe '#authenticate' do
    it 'returns User if authenticated' do
      subject.save
      expect(subject.authenticate(subject.password).class).to eq subject.class
    end

    it 'returns false if not authenticated' do
      subject.save
      expect(subject.authenticate('wrong')).to be false
    end
  end
end
