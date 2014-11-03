Rails.application.routes.draw do

  mount MaterialRequisitionx::Engine => "/material_requisitionx"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  mount ExtConstructionProjectx::Engine => '/project'
  mount Searchx::Engine => '/searchx'
  mount PettyWarehousex::Engine => '/pwhs'
  mount Kustomerx::Engine => '/customer'
  mount Supplierx::Engine => '/supplier'
  mount BaseMaterialx::Engine => '/base_material'
  mount RequisitionCheckoutx::Engine => '/checkout'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
