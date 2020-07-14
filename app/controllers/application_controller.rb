class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session#:exception
    before_action :set_locale#, :authenticate
    private
    def set_locale
        #si se le indica el idioma lo setea desde params[:locale
        #si no, setea el valor por defecto configurado en application.rb
        I18n.locale = params[:locale] || I18n.default_locale
        #para almacenar el token
        @key = Rails.application.secrets.secret_key_base.to_json
    end
    def authenticate
        #si el token se envia en el cuerpo del json params['token'].to_json
        #si el token se envia en el header del json request.headers['token'].to_json
        if !request.headers["token"].nil?
            token_frontend = request.headers["token"]
            #decodificamos el token con la gema JWT
            decode = JWT.decode(token_frontend, @key)[0]
            #verificamos si el token es correcto
            json_decode = HashWithIndifferentAccess.new decode
            #buscamos en BD si el token existe
            token = Token.find_by(token:json_decode[:token])
            if token.nil? or not token.is_valid?
                render json: {error: "El token ingresado es invalido"}, status: :unauthorized
            else
                @current_user = token.user
            end
        else
            render json: {error: "No se obtuvo el token"}, status: :unauthorized
        end
    end
    rescue_from JWT::VerificationError do |exception|
        render json: {:message => t('jwt.decode_error')}, status: :unprocessable_entity
    end
end
