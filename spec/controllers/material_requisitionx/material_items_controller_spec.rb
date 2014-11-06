require 'spec_helper'

module MaterialRequisitionx
  describe MaterialItemsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      
    end
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @i = FactoryGirl.create(:base_materialx_part)
      @i1 = FactoryGirl.create(:base_materialx_part, :name => 'a new name')
      @p = FactoryGirl.create(:ext_construction_projectx_project)
    end
    
    render_views
    describe "GET 'index'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'material_requisitionx_material_items', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MaterialRequisitionx::MaterialItem.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item)
        qi1 = FactoryGirl.build(:material_requisitionx_material_item, :name => 'a new name')
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi, qi1])
        get 'index', {:use_route => :material_requisitionx, :requisition_id => q.id}
        assigns(:material_items).should =~ [qi, qi1]
      end
    end
  
  end
end
