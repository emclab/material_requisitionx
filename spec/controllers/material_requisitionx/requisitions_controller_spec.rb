require 'spec_helper'

module MaterialRequisitionx
  describe RequisitionsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      
    end
    
    before(:each) do
      wf = "def submit
          wf_common_action('initial_state', 'reviewing', 'submit')
        end   
        def approve
          wf_common_action('reviewing', 'approved', 'approve')
        end 
        def reject
          wf_common_action('reviewing', 'rejected', 'reject')
        end
        def rewind
          wf_common_action('rejected', 'initial_state', 'rewind')
        end
        def checkout
          wf_common_action('approved', 'checkedout', 'checkout')
        end"
      FactoryGirl.create(:engine_config, :engine_name => 'material_requisitionx', :engine_version => nil, :argument_name => 'requisition_wf_action_def', :argument_value => wf)
      final_state = 'rejected, fulfilled'
      FactoryGirl.create(:engine_config, :engine_name => 'material_requisitionx', :engine_version => nil, :argument_name => 'requisition_wf_final_state_string', :argument_value => final_state)
      
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => 'piece, set, kg')

      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @i = FactoryGirl.create(:base_materialx_part)
      @i1 = FactoryGirl.create(:base_materialx_part, :name => 'new name')
      @p = FactoryGirl.create(:ext_construction_projectx_project)
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns all items" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MaterialRequisitionx::Requisition.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item, :name => @i.name, spec: @i.spec)
        qi1 = FactoryGirl.build(:material_requisitionx_material_item, name: @i1.name, spec: @i1.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi])
        q1 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :wf_state => 'rejected')
        q2 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi1])
        q3 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi1], :wf_state => 'approved')
        get 'index', {:use_route => :material_requisitionx}
        assigns(:requisitions).should =~ [q, q1, q2, q3]
      end

      it "returns approved items" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MaterialRequisitionx::Requisition.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        qi1 = FactoryGirl.build(:material_requisitionx_material_item, name: @i1.name, spec: @i1.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi])
        q1 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :wf_state => 'approved')
        q2 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi])
        
        get 'index', {:use_route => :material_requisitionx, :wf_state => 'approved'}
        assigns(:requisitions).should =~ [q1]
      end

      it "returns rejected items" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                                         :sql_code => "MaterialRequisitionx::Requisition.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        qi1 = FactoryGirl.build(:material_requisitionx_material_item, name: @i1.name, spec: @i1.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi])
        q1 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :wf_state => 'rejected')
        q2 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi1])

        get 'index', {:use_route => :material_requisitionx, :wf_state => 'rejected'}
        assigns(:requisitions).should =~ [q1]
      end

      it "returns checkedout items" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MaterialRequisitionx::Requisition.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        qi1 = FactoryGirl.build(:material_requisitionx_material_item, name: @i1.name, spec: @i1.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi])
        q1 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :wf_state => 'approved')
        q2 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi1])
        
        get 'index', {:use_route => :material_requisitionx, :wf_state => 'approved'}
        assigns(:requisitions).should =~ [q1]
      end

      
      it "should only return the requisitions for the project" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "MaterialRequisitionx::Requisition.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        qi1 = FactoryGirl.build(:material_requisitionx_material_item, name: @i1.name, spec: @i1.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :project_id => @p.id)
        q1 = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi1], :project_id => q.project_id + 1)
        get 'index', {:use_route => :material_requisitionx, :project_id => @p.id}
        assigns(:requisitions).should =~ [q]
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :material_requisitionx, :project_id => @p.id}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.attributes_for(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        q = FactoryGirl.attributes_for(:material_requisitionx_requisition, :project_id => @p.id, :material_items_attributes => [qi])
        get 'create', {:use_route => :material_requisitionx, :requisition => q, :project_id => @p.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.attributes_for(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        q = FactoryGirl.attributes_for(:material_requisitionx_requisition, :material_items_attributes => [qi], :purpose => nil, :project_id => @p.id)
        get 'create', {:use_route => :material_requisitionx, :requisition => q, :project_id => @p.id}
        response.should render_template('new')
      end
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.create(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :project_id => @p.id, :last_updated_by_id => @u.id)
        get 'edit', {:use_route => :material_requisitionx, :id => q.id}
        response.should be_success
      end
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :project_id => @p.id, :last_updated_by_id => @u.id)
        get 'update', {:use_route => :material_requisitionx, :id => q.id, :Requisition => {:purpose => 'my up'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :last_updated_by_id => @u.id)
        get 'update', {:use_route => :material_requisitionx, :id => q.id, :requisition => {:requested_by_id => 0}}
        response.should render_template('edit')
      end
      
    end
 
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.requested_by_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :project_id => @p.id, :requested_by_id => @u.id, :last_updated_by_id => @u.id)
        get 'show', {:use_route => :material_requisitionx, :id => q.id }
        response.should be_success
      end
    end
    
    describe "GET 'destroy"
      it "should destroy" do
        user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qi = FactoryGirl.build(:material_requisitionx_material_item, name: @i.name, spec: @i.spec)
        q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :project_id => @p.id, :last_updated_by_id => @u.id)
        get 'destroy', {:use_route => :material_requisitionx, :id => q.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
      end
  end
end
