require 'axlsx'

class ExcelService
  def self.generate_report(logs)
    p = Axlsx::Package.new
    wb = p.workbook

    wb.add_worksheet(name: "Log Report") do |sheet|
      sheet.add_row ["Timestamp", "Ação", "Usuário", "Detalhes", "Perfil"], style: Axlsx::STYLE_THIN_BORDER
      logs.each do |log|
        sheet.add_row [
          log['timestamp'],
          log['action'],
          log['user'],
          log['details'],
          log['profile'] || "N/A"
        ]
      end
    end

    wb.add_worksheet(name: "Evidências") do |sheet|
      sheet.add_row ["Data do Relatório", "Número de Registros", "Período Analisado"]
      sheet.add_row [
        Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        logs.length,
        "#{logs.first['timestamp']} a #{logs.last['timestamp']}"
      ]
    end

    p.to_stream
  end
end