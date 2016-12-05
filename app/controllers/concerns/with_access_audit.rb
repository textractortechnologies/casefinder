module WithAccessAudit
  extend ActiveSupport::Concern

  def audit_activity(options={})
    filtered_parameters = params.except(:utf8, :authenticity_token, :controller, :action, :user)

    parameters_string   = " with params: #{filtered_parameters.inspect}" if filtered_parameters.keys.any?
    unless options[:username].present?
      options.merge!({ username: current_user ? current_user.username : 'unknown' }) 
    end

    unless options[:action].present?
      options.merge!({ action: AccessAudit.controller_action_access })
    end

    if options[:description].blank? && options[:skip_description].blank?
      options.merge!({ description: "#{controller_name}:#{action_name}#{parameters_string}"})
    end

    AccessAudit.create!(
      username:     options[:username], 
      action:       options[:action],
      description:  options[:description]
    )
  end
end