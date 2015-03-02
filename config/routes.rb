MaterialRequisitionx::Engine.routes.draw do
  
  resources :material_items, only: [:index]
  
  resources :requisitions do
    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('requisition_wf_route', 'material_requisitionx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        patch :submit
        patch :manager_approve
        patch :manager_reject
        patch :fulfill
      end
      
      collection do
        get :list_open_process
        get :list_items
      end
       
    end
  end
  
  root :to => 'requisitions#index'
end
