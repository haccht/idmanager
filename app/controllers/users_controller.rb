class UsersController < ApplicationController
  before_action :require_session!
  before_action :set_user, only: %i[ show edit update destroy edit_password update_password ]

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  # GET /users or /users.json
  def index
    return redirect_to new_user_path unless current_user

    authorize User
    @users = User.all(order: 'asc')
  end

  # GET /users/1 or /users/1.json
  def show
    authorize @user
    respond_to do |format|
      format.html { redirect_to edit_user_path(@user) }
      format.json { render :show, status: :ok, location: @user }
    end
  end

  # GET /users/new
  def new
    authorize User
    @user = User.new
    @user.assign_attributes(cn: current_session.account)
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # POST /users or /users.json
  def create
    authorize User
    @user = User.new
    @user.assign_attributes(user_params.except('user_password_confirmation'))

    respond_to do |format|
      if @user.valid_password?(user_params['user_password_confirmation']) && @user.save
        format.html { redirect_to user_url(@user), notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    authorize @user
    @user.assign_attributes(user_params.except('user_password', 'user_password_confirmation'))

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /user/1/password
  def edit_password
    authorize @user
  end

  # PATCH/PUT /user/1/password
  def update_password
    authorize @user
    @user.assign_attributes(user_params.except('user_password_confirmation'))

    respond_to do |format|
      if @user.valid_password?(user_params['user_password_confirmation']) && @user.save
        format.html { redirect_to edit_user_url(@user), notice: "Password was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit_password, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    authorize @user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(attribute: 'uidNumber', value: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:cn, :sn, :uid, :mail, :uid_number, :gid_number, :login_shell, :home_directory, :user_password, :user_password_confirmation, :ssh_public_key)
    end

    def not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to user_path(current_user)
    end
end
