module ApplicationHelper

  def flash_css_class(key)
    if key.intern == :error
      "alert-danger"
    elsif key.intern == :notice
      "alert-success"
    else
      "alert-#{key}"
    end
  end

end
