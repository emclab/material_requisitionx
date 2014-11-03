require 'spec_helper'

describe "LinkTests" do
  describe "GET /material_requisitionx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      wf = "def submit
          wf_common_action('initial_state', 'reviewing', 'submit')
        end   
        def manager_approve
          wf_common_action('reviewing', 'approved', 'manager_approve')
        end
        def manager_reject
          wf_common_action('reviewing', 'rejected', 'manager_reject')
        end
        def fulfill
          wf_common_action('approved', 'fulfilled', 'fulfill')
        end"

      FactoryGirl.create(:engine_config, :engine_name => 'material_requisitionx', :engine_version => nil, :argument_name => 'requisition_wf_action_def', :argument_value => wf)
      final_state = 'rejected, released'
      FactoryGirl.create(:engine_config, :engine_name => 'material_requisitionx', :engine_version => nil, :argument_name => 'requisition_wf_final_state_string', :argument_value => final_state)
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => nil)
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'piece_unit', :argument_value => 'piece, set, kg')
      FactoryGirl.create(:engine_config, :engine_name => 'material_requisitionx', :engine_version => nil, :argument_name => 'requisition_fulfill_inline', 
                         :argument_value => "<%= f.input :fulfill_date, :as => :hidden, :input_html => {:value => Date.today} %>
                                             <%= f.input :fulfilled_by_id, :as => :hidden, :input_html => {:value => session[:user_id]} %>
                                             <%= f.input :fulfilled, :as => :hidden, :input_html => {:value => true} %>
                                           ")
      FactoryGirl.create(:engine_config, :engine_name => 'material_requisitionx', :engine_version => nil, :argument_name => 'validate_requisition_fulfill', 
                         :argument_value => "errors.add(:fulfill_date, I18n.t('Not be blank')) if fulfill_date.blank?
                                             errors.add(:fulfilled_by_id, I18n.t('Not be blank')) if fulfilled_by_id.blank?
                                           ")
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      ua1 = FactoryGirl.create(:user_access, :action => 'index', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "MaterialRequisitionx::Requisition.order('created_at DESC')")
      ua1 = FactoryGirl.create(:user_access, :action => 'create', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      ua1 = FactoryGirl.create(:user_access, :action => 'update', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "record.requested_by_id == session[:user_id]")

      FactoryGirl.create(:user_access, :action => 'submit', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                               :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'manager_approve', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'manager_reject', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'fulfill', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'event_action', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")

      FactoryGirl.create(:user_access, :action => 'list_open_process', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      
      FactoryGirl.create(:user_access, :action => 'list_items', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'list_submitted_items', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'list_approved_items', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'list_rejected_items', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
      FactoryGirl.create(:user_access, :action => 'list_checkedout_items', :resource => 'material_requisitionx_requisitions', :role_definition_id => @role.id, :rank => 1,
                         :sql_code => "")
                         
      @i = FactoryGirl.create(:base_materialx_part)
      @i1 = FactoryGirl.create(:base_materialx_part, :name => 'a new name')
      @p = FactoryGirl.create(:ext_construction_projectx_project)

      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => 'password'
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      qi = FactoryGirl.build(:material_requisitionx_material_item, :item_id => @i.id)
      q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi])
      visit requisitions_path
      #save_and_open_page
      page.should have_content('Requisition Items')
      click_link 'Edit'
      page.should have_content('Update Requisition Item')
      fill_in 'requisition_purpose', :with => '4001'
      click_button 'Save'
      #save_and_open_page

      # submit for manager review
      visit requisitions_path
      #save_and_open_page
      click_link 'Submit Requisition'
      #save_and_open_page
      visit requisitions_path
      page.should have_content('4001')

      #bad data
      visit requisitions_path
      click_link 'Edit'
      fill_in 'requisition_purpose', :with => nil
      click_button 'Save'
      #save_and_open_page

      visit requisitions_path(:project_id => @p.id)
      #save_and_open_page
      click_link 'New Requisition'
      page.should have_content('New Requisition Item')
      fill_in 'requisition_purpose', :with => '40004'
      fill_in 'requisition_request_date', :with => Date.today
      fill_in 'requisition_date_needed', :with => Date.today + 10.days
      click_button 'Save'
      #
      visit requisitions_path
      page.should have_content('40004')
      #save_and_open_page
      #bad data
      visit requisitions_path(:project_id => @p.id)
      #save_and_open_page
      click_link 'New Requisition'
      fill_in 'requisition_purpose', :with => 'bad new requisition'
      fill_in 'requisition_request_date', :with => nil
      fill_in 'requisition_date_needed', :with => Date.today + 10.days
      click_button 'Save'
      #save_and_open_page
      visit requisitions_path
      page.should_not have_content('bad new requisition')
    end

    it "should requisition an approved item" do
      qi = FactoryGirl.build(:material_requisitionx_material_item, :item_id => @i.id)
      q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :wf_state => 'approved')
      visit requisitions_path(:project_id => @p.id)  #allow to redirect after save new below
      page.should have_content('Approved')
      page.should have_content('Requisition Items')
      click_link 'Fulfill'
      #fill_in 'requisition_fulfill_date', :with => Date.today - 8.days
      #save_and_open_page
      click_button 'Save'
      visit requisitions_path()
      #save_and_open_page
      page.should have_content('Fulfilled')

    end
    
    it "requisition from submit request to final requisition" do
      qi = FactoryGirl.build(:material_requisitionx_material_item, :item_id => @i.id)
      q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :wf_state => 'initial_state')
      visit requisitions_path
      page.should have_content('Submit Requisition')
      click_link 'Submit Requisition'
      fill_in 'requisition_wf_comment', :with => 'Submitting Requisition'
      click_button 'Save'
      visit requisitions_path
      #save_and_open_page

      page.should have_content('Reviewing')
      click_link 'Manager Approve'
      fill_in 'requisition_wf_comment', :with => 'Approving requisition'
      click_button 'Save'
      visit requisitions_path
      #save_and_open_page

      page.should have_content('Approved')
      click_link 'Fulfill'
      fill_in 'requisition_wf_comment', :with => 'Checking requisition'
      click_button 'Save'
      visit requisitions_path
      #save_and_open_page
      page.should have_content('Fulfilled')
    end

    it "list submitted request then reviewing requests, then rejected requests" do
      qi = FactoryGirl.build(:material_requisitionx_material_item, :item_id => @i.id)
      q = FactoryGirl.create(:material_requisitionx_requisition, :material_items => [qi], :wf_state => 'initial_state')
      visit list_items_requisitions_path(:wf_state => 'initial_state')
      page.should have_content('Submit Requisition')
      click_link 'Submit Requisition'
      fill_in 'requisition_wf_comment', :with => 'Submitting requisition'
      click_button 'Save'

      visit list_items_requisitions_path(:wf_state => 'reviewing')
      #save_and_open_page
      page.should have_content('Reviewing')

      click_link 'Manager Reject'
      fill_in 'requisition_wf_comment', :with => 'Rejecting requisition'
      click_button 'Save'
      visit list_items_requisitions_path(:wf_state => 'rejected')
      page.should have_content('Rejected')
    end
  end
end
