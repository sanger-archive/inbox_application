module ApplicationHelper
  def flash_to_bootstrap(flash_category)
    {
      'alert' => 'danger',
      'notice' => 'success'
    }.fetch(flash_category,'info')
  end
end
