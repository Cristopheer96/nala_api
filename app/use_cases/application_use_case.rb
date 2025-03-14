class ApplicationUseCase
  def self.call(...)
    new(...).call
  end

  private

  def response(success: false, payload: {}, error: nil)
    Struct.new('Response', :success?, :payload, :error) unless Struct.const_defined?(:Response)
    Struct::Response.new(success, payload, error)
  end
end
