InvoiceRestServer::Application.routes.draw do
  apipie

  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      resources :invoices, only: [:index]
      get 'salesregions', to: 'invoices#salesregions'
      get 'invoice', to: 'invoices#update'
      get 'tc', to: 'invoices#tc'
      post 'invoice', to: 'invoices#update'

      get 'channels', to: 'scheduling#channels'
      get 'channels/:channel_code/dayparts', to: 'scheduling#dayparts'
      get 'channels/:channel_code/cities', to: 'scheduling#cities'
      get 'channels/:channel_code/planned_locals', to: 'scheduling#planned_locals'
      get 'channels/:channel_code/local_captions', to: 'scheduling#local_captions'
      get 'channels/:channel_code/filler_captions', to: 'scheduling#filler_captions'
      get 'channels/:channel_code/signature_captions', to: 'scheduling#signature_captions'
      get 'channels/:channel_code/available_masters', to: 'scheduling#available_masters'
      post 'channels/:channel_code/import_schedule', to: 'scheduling#import_schedule', :as => 'import_schedule'
      post 'ats/import_plan', to: 'ats#import_plan', :as => 'import_plan'
      get 'asrun', to: 'asrun#asrun_dsp'
      get 'pending_asrun', to: 'pending_asrun#pending_asrun_dsp'

      namespace :ingest_workflow do
        get :channels
        get :cities
        get :clients
        get :campaigns
        get :captions
        get :salespersons
      end
    end
  end
end
