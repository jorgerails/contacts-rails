Ruby version: 3.0.0
Rails version: 6.1.3

A Rails application that perform CRUD operation through API calls for contacts resource.

# Configuration

- Clone this repository and run `bundle install`
- Create local database with `rails db:create`
- Migrate to create contacts table `rails db:migrate`
- You can run `rails db:seed` to have a collection of 50 contacts in database
- Create `.env` file with api key => `API_KEY='any-api-key'`
- Just run `rails s` to start application

# TEST SUITE
- To run test suite: `bundle exec rspec`
