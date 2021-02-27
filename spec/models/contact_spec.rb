require 'rails_helper'

RSpec.describe Contact, type: :model do
  let :contact do
    build :contact
  end

  describe 'validations' do
    describe '#first_name' do
      it 'is not valid without first_name' do
        contact.first_name = nil

        expect(contact).to_not be_valid
        expect(contact.errors.messages_for(:first_name)).to include("can't be blank")
      end

      it 'is not valid with first_name longer than 255 characters' do
        contact.first_name = Array.new(500, 'a').join('')

        expect(contact).to_not be_valid
        expect(contact.errors.messages_for(:first_name)).to include(
          "is too long (maximum is 255 characters)"
        )
      end
    end

    describe '#last_name' do
      it 'is not valid without last_name' do
        contact.last_name = nil

        expect(contact).to_not be_valid
        expect(contact.errors.messages_for(:last_name)).to include("can't be blank")
      end

      it 'is not valid with last_name longer than 255 characters' do
        contact.last_name = Array.new(500, 'a').join('')

        expect(contact).to_not be_valid
        expect(contact.errors.messages_for(:last_name)).to include(
          "is too long (maximum is 255 characters)"
        )
      end
    end

    describe '#email' do
      it 'is not valid without email' do
        contact.email = nil

        expect(contact).to_not be_valid
        expect(contact.errors.messages_for(:email)).to include("can't be blank")
      end

      it 'is not valid with invalid format' do
        contact.email = 'hi-wrong-email'

        expect(contact).to_not be_valid
        expect(contact.errors.messages_for(:email)).to include("is invalid")
      end

      it 'is not valid if another record with same email exists (case insensitive)' do
        contact.email = "hi@hello.com"
        contact.save!

        new_contact = build :contact, email: "hi@hello.com"

        expect(new_contact).to_not be_valid
        expect(new_contact.errors.messages_for(:email)).to include("has already been taken")

        new_contact = build :contact, email: "HI@hellO.com"

        expect(new_contact).to_not be_valid
        expect(new_contact.errors.messages_for(:email)).to include("has already been taken")
      end
    end

    describe '#phone_number' do
      it 'is not valid without phone_number' do
        contact.phone_number = nil

        expect(contact).to_not be_valid
        expect(contact.errors.messages_for(:phone_number)).to include("can't be blank")
      end

      it 'is not valid with phone_number longer than 255 characters' do
        contact.phone_number = Array.new(500, 'a').join('')

        expect(contact).to_not be_valid
        expect(contact.errors.messages_for(:phone_number)).to include(
          "is too long (maximum is 255 characters)"
        )
      end

      it 'is not valid with phone_number shorter than 9 characters' do
        contact.phone_number = Array.new(5, 'a').join('')

        expect(contact).to_not be_valid
        expect(contact.errors.messages_for(:phone_number)).to include(
          "is too short (minimum is 9 characters)"
        )
      end
    end
  end
end
