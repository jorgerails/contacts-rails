require 'rails_helper'

RSpec.describe ContactsController, type: :request do
  let :contact do
    create :contact,
           first_name: 'Jorge',
           last_name: 'Peris',
           phone_number: '+34666554433',
           email: 'jOrgePERIS@gmail.com'
  end

  describe 'GET /contacts' do
    context 'when some record exists' do
      before do
        create_list(:contact , 15)
      end

      it 'returns 200 with collection paginated per 10' do
        with_api_credentials do
          get :index
        end

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['contacts'].size).to eq(10)
        expect(JSON.parse(response.body)['contacts'].first.keys.sort).to eq(
          %w(id first_name last_name email phone_number).sort
        )

        expect(JSON.parse(response.body)['pagination']['current']).to eq(1)
        expect(JSON.parse(response.body)['pagination']['previous']).to eq(nil)
        expect(JSON.parse(response.body)['pagination']['next']).to eq(2)
        expect(JSON.parse(response.body)['pagination']['pages']).to eq(2)
        expect(JSON.parse(response.body)['pagination']['count']).to eq(15)
      end

      context 'and with page params' do
        it 'returns 200 with collection paginated per 10' do
          with_api_credentials do
            get :index, params: { page: 2 }
          end

          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)['contacts'].size).to eq(5)
          expect(JSON.parse(response.body)['contacts'].first.keys.sort).to eq(
            %w(id first_name last_name email phone_number).sort
          )

          expect(JSON.parse(response.body)['pagination']['current']).to eq(2)
          expect(JSON.parse(response.body)['pagination']['previous']).to eq(1)
          expect(JSON.parse(response.body)['pagination']['next']).to eq(nil)
          expect(JSON.parse(response.body)['pagination']['pages']).to eq(2)
          expect(JSON.parse(response.body)['pagination']['count']).to eq(15)
        end
      end
    end

    context 'when there are no records' do
      it 'returns 200 with empty collection' do
        with_api_credentials do
          get :index
        end

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['contacts'].size).to eq(0)

        expect(JSON.parse(response.body)['pagination']['current']).to eq(1)
        expect(JSON.parse(response.body)['pagination']['previous']).to eq(nil)
        expect(JSON.parse(response.body)['pagination']['next']).to eq(nil)
        expect(JSON.parse(response.body)['pagination']['pages']).to eq(0)
        expect(JSON.parse(response.body)['pagination']['count']).to eq(0)
      end
    end
  end

  describe 'GET /contacts/:id' do
    context 'for existing contact' do
      it 'returns 200 with contact' do
        with_api_credentials do
          get :show, params: { id: contact.id }
        end

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['first_name']).to eq('Jorge')
        expect(JSON.parse(response.body)['last_name']).to eq('Peris')
        expect(JSON.parse(response.body)['phone_number']).to eq('+34666554433')
        expect(JSON.parse(response.body)['email']).to eq('jOrgePERIS@gmail.com')
      end
    end

    context 'for not existing contact' do
      it 'returns 404' do
        with_api_credentials do
          get :show, params: { id: 'invalid id' }
        end

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to eq({"id" => ["Not found contact with id invalid id"]})
      end
    end
  end

  describe 'POST /contacts' do
    context 'when the record can be created' do
      it 'returns 201 with new contact' do
        with_api_credentials do
          post :create,
            params: {
              contact: {
                first_name: 'Jorge',
                last_name: 'Peris',
                phone_number: '+34666554433',
                email: 'jOrge_PERIS@gmail.com'
              }
            }
        end

        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)['first_name']).to eq('Jorge')
        expect(JSON.parse(response.body)['last_name']).to eq('Peris')
        expect(JSON.parse(response.body)['phone_number']).to eq('+34666554433')
        expect(JSON.parse(response.body)['email']).to eq('jOrge_PERIS@gmail.com')
      end
    end

    context 'when the record cannot be created' do
      it 'returns 422 with errors' do
        with_api_credentials do
          post :create,
            params: {
              contact: {
                first_name: 'Jorge',
                last_name: 'Peris',
                email: 'jOrge_PERIS@gmail.com'
              }
            }
        end

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['phone_number']).to include("can't be blank")
      end
    end
  end

  describe 'PATCH /contacts/:id' do
    context 'for existing record' do
      context 'when contact can be updated' do
        it 'returns 200 with updated contact' do
          with_api_credentials do
            patch :update,
              params: {
                id: contact.id,
                contact: { first_name: 'Pepe' }
              }
          end

          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)['first_name']).to eq('Pepe')
          expect(JSON.parse(response.body)['last_name']).to eq('Peris')
          expect(JSON.parse(response.body)['phone_number']).to eq('+34666554433')
          expect(JSON.parse(response.body)['email']).to eq('jOrgePERIS@gmail.com')
        end
      end

      context 'when contact cannot be updated' do
        it 'returns 422 with updated contact' do
          with_api_credentials do
            patch :update,
              params: {
                id: contact.id,
                contact: { first_name: nil }
              }
          end

          expect(response.status).to eq(422)
          expect(JSON.parse(response.body)['first_name']).to include("can't be blank")
        end
      end
    end

    context 'for not existing contact' do
      it 'returns 404' do
        with_api_credentials do
          patch :show, params: { id: 'invalid id', contact: { first_name: nil } }
        end

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to eq({"id" => ["Not found contact with id invalid id"]})
      end
    end
  end

  describe 'DELETE /contact/:id' do
    context 'for existing contact' do
      it 'returns 204 and destroyed record' do
        with_api_credentials do
          delete :destroy, params: { id: contact.id }
        end

        expect(response.status).to eq(204)
      end
    end

    context 'for not existing contact' do
      it 'returns 404' do
        with_api_credentials do
          delete :destroy, params: { id: 'invalid id' }
        end

        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)).to eq({"id" => ["Not found contact with id invalid id"]})
      end
    end
  end
end
