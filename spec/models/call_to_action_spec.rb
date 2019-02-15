require 'rails_helper'

RSpec.describe CallToAction, type: :model do
  it 'is invalid without a title' do
    subject = CallToAction.new(title: nil)
    subject.valid?
    expect(subject.errors[:title]).to include("can't be blank")
  end

  it 'is invalid without a body' do
    subject = CallToAction.new(body: nil)
    subject.valid?
    expect(subject.errors[:body]).to include("can't be blank")
  end

  it 'is invalid without a url' do
    subject = CallToAction.new(url: nil)
    subject.valid?
    expect(subject.errors[:url]).to include("can't be blank")
  end

  it 'is invalid without a button_text' do
    subject = CallToAction.new(button_text: nil)
    subject.valid?
    expect(subject.errors[:button_text]).to include("can't be blank")
  end
end
