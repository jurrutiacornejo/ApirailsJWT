class Api::V1::NotesController < ApplicationController
  before_action :validate_note, except: [:index]
  before_action :authenticate
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  #utilizado por cancan
  load_and_authorize_resource

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.user = @current_user
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created}
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok}
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { render json: {:messsage => t('notes.delete')} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      begin
        @note = Note.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: {:messsage => t('messages.dont_find')}
      end
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:user_id, :title, :body)
    end

  #validamos que esten los valores y que no este vacio el objeto :user
  def validate_note
    #valida que exista la key y que no este vacio el objeto :user
    if !params[:note].present?
      render json: {:messsage => t('messages.add_name')}
    end
  end
end
