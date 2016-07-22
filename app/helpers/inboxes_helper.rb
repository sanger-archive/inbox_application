module InboxesHelper
  def bootstrap_inbox_class(status)
    {
      :active => 'success',
      :inactive => 'danger',
      :deprecated => 'danger'
    }.fetch(status,'warning')
  end

  #<span class='label label-STATUS' data-toggle="popover" data-trigger="focus" title="STATUS" data-content="STATUS:HELP_TEXT">STATUS</span>
  def status_label(status)
    content_tag(:span,status,
      class:"label label-#{bootstrap_inbox_class(status)} label-inbox",
        title: t(:title,scope:[:inboxes,:status,status]),
      data: {
        toggle: 'popover',
        trigger: 'hover',
        content: t(:help,scope:[:inboxes,:status,status])
      })
  end
end
