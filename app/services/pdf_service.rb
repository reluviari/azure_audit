require 'prawn'
require 'prawn/table'  # Adicione esta linha para incluir o módulo de tabelas

class PdfService
  def self.generate_report(logs)
    # Verifica se há logs para processar
    if logs.empty?
      puts "Nenhum log encontrado. O PDF não será gerado."
      return nil
    end

    pdf = Prawn::Document.new

    pdf.text "Relatório de Logs do Azure DevOps", size: 18, style: :bold
    pdf.move_down 20

    data = [["Timestamp", "Ação", "Usuário", "Detalhes", "Perfil"]]
    logs.each do |log|
      data << [
        log['timestamp'],
        log['action'],
        log['user'],
        log['details'],
        log['profile'] || "N/A"
      ]
    end

    pdf.table(data, header: true, width: pdf.bounds.width) do
      row(0).style(background_color: 'CCCCCC', font_style: :bold)
      columns(0..4).align = :center
      self.row_colors = ["FFFFFF", "EEEEEE"]
      self.header = true
    end

    pdf.render
  end
end
