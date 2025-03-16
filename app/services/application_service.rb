class ApplicationService
  def self.call(...)
    new(...).call
  end

  private
    def response(success: false, payload: {}, error: nil)
      Struct.new('Response', :success?, :payload, :error) unless Struct.const_defined?(:Response)
      Struct::Response.new(success, payload, error)
    end

  def parse_result(result)
    {
      status: result.status_code,
      body: JSON.parse(result.body || '{}', object_class: OpenStruct)
    }
  end
end
