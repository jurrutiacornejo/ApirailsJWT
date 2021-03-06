class Api::V1::ProfilesController < ApplicationController
  before_action :validate_profile, except: [:index]
  before_action :authenticate
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  #utilizado por cancan
  load_and_authorize_resource

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    @profile.user = @current_user
    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created}
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok}
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    begin
      @profile = Profile.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {:messsage => t('messages.dont_find')}
    end
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.require(:profile).permit(:name, :last_name, :age)
  end

  #validamos que esten los valores y que no este vacio el objeto :user
  def validate_profile
    #valida que exista la key y que no este vacio el objeto :user
    if !params[:profile].present?
      render json: {:messsage => t('messages.add_name')}
    end
  end

end
