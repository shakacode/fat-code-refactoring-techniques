 # Return value object from Service Objects and the Models back to the controller.
 # Rather than throwing an exception from the Service Objects, this class will encapsulate any
 # error status to send back to the client.
class ControllerResponse
  attr_reader :flash_message
  attr_reader :flash_type
  attr_reader :http_status_code
  attr_reader :data
  attr_reader :redirect_path
  attr_reader :session_data

  # http_status can be either symbol or number
  # Pass in flash_message as a html_safe string if you do not want it escaped.
  def initialize(flash_type: :notice,
    flash_now: false,
    flash_message: "",
    http_status: :ok,
    data: {},
    redirect_path: nil,
    session_data: {})
    @flash_type       = flash_type
    @flash_now        = flash_now
    @flash_message    = flash_message
    @http_status_code = Rack::Utils::status_code(http_status)
    @data             = data
    @redirect_path    = redirect_path
    @session_data     = session_data
  end

  def self.symbol_to_status_code(symbol)
    Rack::Utils::SYMBOL_TO_STATUS_CODE[symbol]
  end

  def ok
    http_status_code >= 200 && http_status_code < 300
  end

  # Currently supports applying the:
  # 1. session_data
  # 2. flash, flash_type, and flash_now
  # 3. redirect_path
  # Does not apply the http_status_code, nor the data
  def apply(controller)
    @session_data.each { |k, v| controller.session[k] = v }
    if @flash_message.present?
      if @flash_now
        # NOTE: There is no need to escape, as Rails will do that unless the flash_message is html_safe
        controller.flash.now[@flash_type] = @flash_message
      else
        # NOTE: There is no need to escape, as Rails will do that unless the flash_message is html_safe
        controller.flash[@flash_type] = @flash_message
      end
    end
    controller.redirect_to @redirect_path if @redirect_path.present?
  end

  def set_flash(flash)
    # NOTE: There is no need to escape, as Rails will do that unless the flash_message is html_safe
    flash[flash_type] = flash_message if flash_message.present?
  end

  # Returns the html escaped version of the flash.
  # This method should be used when setting value in json.
  # In the case of setting the flash on the controller, there is no need to escape, as Rails will do
  # that unless the flash_message is html_safe
  def flash_message_escaped
    if @flash_message.html_safe?
      @flash_message
    else
      CGI::escapeHTML(@flash_message)
    end
  end
end
