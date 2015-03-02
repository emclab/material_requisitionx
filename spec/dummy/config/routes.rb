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
  
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
