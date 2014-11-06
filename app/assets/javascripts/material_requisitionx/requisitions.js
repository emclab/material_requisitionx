// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function (){
  //refresh for newly inserted element.
  $(document).on('change', "[id^='requisition_material_items_attributes_'][id$='_item_name_autocomplete']", function (){
    //alert('ajax fired');
    $('#requisition_field_changed').val('item_autocomplete');
    $.get(window.location, $('form').serialize(), null, "script");
    return false;
  });
});

//setInterval makes inserted autocomplete get initialized.
$(function() {
  setInterval(function(){
    $("[id^='requisition_material_items_attributes_'][id$='_item_name_autocomplete']").each(function (){
        //alert('autocomplete initialized1');
        $(this).autocomplete({
            minLength: 1,
            source: $(this).data('autocomplete-source'),
            select: function(event, ui) {
                //alert('autocomplete fired1!');
                $(this).val(ui.item.value);
            }
        });
     });
    },1000);
});


$(function() {
	$( "#requisition_request_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#requisition_date_needed" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#requisition_fulfilled_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#requisition_start_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#requisition_end_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
});