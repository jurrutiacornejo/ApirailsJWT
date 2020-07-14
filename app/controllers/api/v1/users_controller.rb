class Api::V1::UsersController < ApplicationController 
  #include UserHelper
  before_action :validate_user, except: [:index]
  before_action :set_user, only: [:update]
  #hererado de application_cotroller
  before_action :authenticate, except: [:create, :login]
  def index
    @users = User.all
  end

  def login
    @user = User.from_login(user_params)
    #valid_password viene por defecto en devise
    if @user.valid_password?(params[:user][:password])
      @token = Token.new(user_id: @user.id)
      if @token.save
        json_encode = {token: @token.token}
        #seteamos token condificado
        @token.token = JWT.encode(json_encode, @key)
        render "api/v1/users/show"
      else
        render json: {response: t('credentials.invalid')}, status: :bad_request
      end
    else
      render json: {response: t('credentials.user_invalid')}, status: :bad_request
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #render json: {user: @user, status: :created}, status: :created
      @token = Token.new(user_id: @user.id)
      if @token.save
        json_encode = {token: @token.token}
        #seteamos token condificado
        @token.token = JWT.encode(json_encode, @key)
        render "api/v1/users/show"
      else
        render json: {response: t('credentials.error'), status: :bad_request}, status: :bad_request
      end
    else
      render json: @user.errors, status: :unprocessable_entity
    end
    #=====FORMA ANTIGUA=====
    # #validate_create_user se encuentra en el helper incluido
    # validation = validate_create_user(params[:user])
    # if validation[:validate]
    #   #:model se crea en el helper
    #   user = User.new(validation[:model])
    #   if user.save
    #     render json: {user: user, status: :created}, status: :created
    #   else
    #     #t{'credentials.error'} aparece como mensaje de la internacionalizacion
    #     render json: {response: t{'credentials.error'}, status: :bad_request}, status: :bad_request
    #   end
    # else
    #   render json: {response: t{"credentials.not_params"}, status: :bad_request}, status: :bad_request
    # end
  end
  def update
    if @user.id == @current_user.id
      if @user.update(user_params)
        render "api/v1/users/update"
      else
        render json: {response: t('crud.update_error'), status: :bad_request}, status: :bad_request
      end
    else
      render json: {response: t('credentials.error'), status: :bad_request}, status: :bad_request
    end
  end

  private
  #strong params permitidos para enviar desde un front
  def user_params
    params.require(:user).permit(:email, :password)
  end
  #validamos que esten los valores y que no este vacio el objeto :user
  def validate_user
    #valida que exista la key y que no este vacio el objeto :user
    if !params[:user].present?
      render json: {:messsage => t('messages.add_name')}
    end
  end
  #try catch para validar si existe el usuario
  def set_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {:messsage => t('messages.dont_find')}
    end
  end

end
