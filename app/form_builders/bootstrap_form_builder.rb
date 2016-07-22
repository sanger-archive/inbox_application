class BootstrapFormBuilder < ActionView::Helpers::FormBuilder

  GROUP_CLASS = "form-group".freeze
  CONTROL_CLASS = "form-control".freeze
  LABEL_CLASS = "col-sm-2 control-label".freeze

  def self.bootstrapify(*originals)
    originals.each do |original|
      define_method(original) do |field_name,options={}|
        options[:class] ||= ""
        options[:class] << " form-control"
        @template.content_tag(:div,class:GROUP_CLASS) do
          label(field_name,class:LABEL_CLASS)  +

          @template.content_tag(:div,super(field_name,options),class:'col-sm-10')
        end
      end
    end
  end

  bootstrapify(:number_field,:text_field,:password_field)

  def select(field_name,choices,options={},html_options={})
    html_options[:class] ||= ""
    options[:prompt] ||= "Select..."
    html_options[:class] << " form-control"
    @template.content_tag(:div,class:GROUP_CLASS) do
      label(field_name,class:LABEL_CLASS)  +

      @template.content_tag(:div,super(field_name,choices,options,html_options),class:'col-sm-10')
    end
  end

  def file_field(field_name,options={},html_options={})
    html_options[:class] ||= ""
    html_options[:class] << " form-control"
    @template.content_tag(:div,class:GROUP_CLASS) do
      label(field_name,class:LABEL_CLASS)  +

      @template.content_tag(:div,super(field_name,options),class:'col-sm-10')
    end
  end

  def submit(*args)
    options = args.detect {|a| a.respond_to?(:fetch) }

    if options.nil?
      options = {}
      args << options
    end

    options && options[:class] ||= 'btn btn-default'
    @template.content_tag(:div,class:GROUP_CLASS) do
      @template.content_tag(:div,class:"col-sm-offset-2 col-sm-10") do
        super(*args)
      end
    end
  end
end
