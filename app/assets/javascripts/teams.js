// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
  $('#edit-inbox-list').sortable({
    connectWith:'.sortable-target',
    tolerance: "pointer",
    deactivate: function(event, ui){
      for(var i=0; i < this.children.length; i+=1) {
        var listItem = this.children[i];
        var badges = listItem.getElementsByClassName('badge');
        var fields = listItem.getElementsByClassName('order-field');
        for(var bi=0; bi < badges.length; bi+=1) { badges[bi].textContent = i+1 };
        for(var fi=0; fi < fields.length; fi+=1) { fields[fi].value = i+1 };
      }
    }
  });
  $('#other-inbox-list').sortable({
    connectWith:'.sortable-target',
    tolerance: "pointer",
    deactivate: function(event, ui){
      for(var i=0; i < this.children.length; i+=1) {
        var listItem = this.children[i];
        var badges = listItem.getElementsByClassName('badge');
        var fields = listItem.getElementsByClassName('order-field');
        for(var bi=0; bi < badges.length; bi+=1) { badges[bi].textContent = '#' };
        for(var fi=0; fi < fields.length; fi+=1) { fields[fi].value = null };
      }
    }
  });
  $('#edit-inbox-list,#other-inbox-list').disableSelection();

  $('input.checkbox-item').on('change',function(){
    if (this.checked) {
      $(this).closest('.list-item').addClass('list-group-item-success');
    } else {
      $(this).closest('.list-item').removeClass('list-group-item-success');
    }
  })
})
