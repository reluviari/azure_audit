require 'dotenv/load'
require_relative 'app/services/azure_devops_service'
require_relative 'app/services/pdf_service'
require_relative 'app/services/excel_service'
require 'date'

def main
  puts "Sistema de Relatórios de Logs do Azure DevOps"

  start_date = ENV['START_DATE'] || prompt("Digite a data de início (YYYY-MM-DD): ")
  end_date = ENV['END_DATE'] || prompt("Digite a data de fim (YYYY-MM-DD): ")
  report_type = ENV['REPORT_TYPE'] || prompt("Escolha o tipo de relatório (pdf/excel/imprimir): ").downcase

  start_date = Date.parse(start_date)
  end_date = Date.parse(end_date)

  logs = AzureDevopsService.get_logs(start_date, end_date)

  puts "Foram encontrados #{logs.length} registros."

  case report_type
  when "pdf"
    pdf_buffer = PdfService.generate_report(logs)
    if pdf_buffer
      filename = "azure_devops_log_report_#{Time.now.strftime('%Y%m%d_%H%M%S')}.pdf"
      File.open(filename, 'wb') { |file| file.write(pdf_buffer) }
      puts "Relatório PDF gerado: #{filename}"
    else
      puts "Relatório PDF não gerado devido à ausência de logs."
    end
  when "excel"
    excel_buffer = ExcelService.generate_report(logs)
    filename = "azure_devops_log_report_#{Time.now.strftime('%Y%m%d_%H%M%S')}.xlsx"
    File.open(filename, 'wb') { |file| file.write(excel_buffer.string) }
    puts "Relatório Excel gerado: #{filename}"
  when "imprimir"
    print_logs(logs)
  else
    puts "Tipo de relatório inválido."
  end
end

def prompt(message)
  print message
  gets.chomp
end

def print_logs(logs)
  puts "Logs do Azure DevOps:"
  logs.each do |log|
    puts "Timestamp: #{log['timestamp']}, Ação: #{log['action']}, Usuário: #{log['user']}, Detalhes: #{log['details']}, Perfil: #{log['profile'] || 'N/A'}"
  end
end

main if __FILE__ == $PROGRAM_NAME
