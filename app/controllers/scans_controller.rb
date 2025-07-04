class ScansController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def new
    
  end
  def estacion3
  
end
  def create
    cedula = params[:scan][:cedula]
    monto = params[:scan][:monto_adicional].to_i
    qr_content = params[:scan][:content]

    scan = Scan.find_by(cedula: cedula)

    if scan
      # Si ya existe, sumar al monto_adicional
      scan.monto_adicional = (scan.monto_adicional || 0) + monto
      if scan.save
        render json: { status: 'updated', message: 'Monto sumado correctamente.' }, status: :ok
      else
        render json: { errors: scan.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # Si no existe, crear nuevo registro
      scan = Scan.new(content: qr_content, cedula: cedula, monto_adicional: monto)
      if scan.save
        render json: { status: 'created', message: 'Nuevo registro creado.' }, status: :created
      else
        render json: { errors: scan.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
def tv_display
  @scan = nil
  @mostrar_resultado = false

  if request.post? && params[:cedula].present?
    @scan = Scan.find_by(cedula: params[:cedula])

    if @scan
      if @scan.monto_final.nil?
        valor_inicial = @scan.content.to_i
        monto_adicional = @scan.monto_adicional.to_i

        total_temporal = valor_inicial + monto_adicional
        monto_aumentado = case total_temporal
                          when 100000..299999 then 20000
                          when 300000..499999 then 40000
                          when 500000..699999 then 60000
                          else 80000
                          end

        @monto_final = valor_inicial + monto_adicional + monto_aumentado

        # Guardar el monto_final solo si no estaba guardado
        @scan.update(monto_final: @monto_final)
      else
        @monto_final = @scan.monto_final
      end

      @mostrar_resultado = true
    else
      flash.now[:alert] = "Cédula no encontrada"
    end
  end
end
def estacion5
  @scan = Scan.find_by(cedula: params[:cedula])

  unless @scan
    flash[:alert] = "Cédula no encontrada"
    
    return
  end
end
def buscar_participante
  @scan = Scan.find_by(cedula: params[:cedula])

  if @scan
    render json: {
      success: true,
      monto_final: @scan.monto_final || 0,
      redimidos: @scan.redimidos,
      redimidos_count: @scan.redimidos.present? ? @scan.redimidos.split(',').size : 0
    }
  else
    render json: { success: false, error: "Participante no encontrado" }
  end
end
def redimir
  @scan = Scan.find_by(cedula: params[:cedula])

  if @scan
    nuevos_redimidos = params[:redimidos] || []
    redimidos_anteriores = @scan.redimidos.present? ? @scan.redimidos.split(',') : []
    total_redimidos = redimidos_anteriores + nuevos_redimidos

    if total_redimidos.size > 3
      render json: { success: false, error: "No puedes redimir más de 3 artículos en total" }, status: :unprocessable_entity
      return
    end

    @scan.redimidos = total_redimidos.join(',')
    @scan.monto_final = params[:monto_final]
    if @scan.save
      render json: { success: true, nuevo_monto: @scan.monto_final }
    else
      render json: { success: false, error: "Error al guardar" }, status: :unprocessable_entity
    end
  else
    render json: { success: false, error: "Participante no encontrado" }, status: :not_found
  end
end



  private

  def scan_params
    params.require(:scan).permit(:content, :cedula, :monto_adicional)
  end
end
