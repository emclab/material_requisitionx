// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  setTimeout(function(){
    //$(document).on('change', "[id^='requisition_material_items_attributes_'][id$='_item_name_autocomplete']", function () {
    $("[id^='requisition_material_items_attributes_'][id$='_item_name_autocomplete']").each(function (){
        alert('from autocomplete');
        $(this).autocomplete({
            minLength: 1,
            source: $(this).data('autocomplete-source'),
            select: function(event, ui) {
                alert('fired!');
                $(this).val(ui.item.value);
            }
        });
     });
    }, 5000);
});

$(function (){
  //refresh for newly inserted element.
  $(document).on('change', "[id^='requisition_material_items_attributes_'][id$='_item_name_autocomplete']", function (){
    alert('file from item');
    $(this).autocomplete(autocomp_opt);
    $('#requisition_field_changed').val('item_autocomplete');
    $.get(window.location, $('form').serialize(), null, "script");
    return false;
  });
});

$(function() {
	$( "#requisition_request_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#requisition_date_needed" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#requisition_fulfilled_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#requisition_start_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#requisition_end_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
});