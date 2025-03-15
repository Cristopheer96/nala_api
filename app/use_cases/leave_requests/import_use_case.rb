module LeaveRequests
  class ImportUseCase < ApplicationUseCase
    def initialize(file)
      super()
      @file = file
    end

    def call
      response(success: true, payload: process)
    rescue => error
      response(error: error.message)
    end

    private

    def process
      spreadsheet = Roo::Excelx.new(@file.path)
      header = spreadsheet.row(1).map(&:downcase)
      imported_count = 0
      errors = []
      # As business logic, if any record in the row cannot be created/persist,
      # a rollback is made it so batch or bulks methdos will not be used.
      ActiveRecord::Base.transaction do
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          begin
            LeaveRequests::ImportRowService.call(row, i)
            imported_count += 1
          rescue StandardError => e
            raise StandardError, "Error en la fila #{i}: #{e.message}"
          end
        end

        raise StandardError, errors.join(" | ") if errors.any?
      end

      { imported: imported_count }
    end
  end
end
