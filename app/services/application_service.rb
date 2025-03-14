class ApplicationService
  def self.call(...)
    new(...).call
  end

  private

  def parse_result(result)
    {
      status: result.status_code,
      body: JSON.parse(result.body || '{}', object_class: OpenStruct)
    }
  end
end
