module TeamsHelper
  def if_active_tab(inbox,value)
    @active_inbox == inbox ? value : nil
  end
end
