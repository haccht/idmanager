class GroupsController < ApplicationController
  before_action :require_session!
  before_action :set_group, only: %i[ show edit update destroy ]

  rescue_from Pundit::NotDefinedError, with: :not_authorized
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  # GET /groups or /groups.json
  def index
    authorize Group
    @groups = Group.all#.order(gid_number: 'asc')
  end

  # GET /groups/1 or /groups/1.json
  def show
    authorize Group
    respond_to do |format|
      format.html { redirect_to edit_group_path(@group) }
      format.json { render :show, status: :ok, location: @group }
    end
  end

  # GET /groups/new
  def new
    authorize Group
    @group = Group.new
    @group.assign_attributes(gid_number: Serial.next_gid)
  end

  # GET /groups/1/edit
  def edit
    authorize Group
  end

  # POST /groups or /groups.json
  def create
    authorize Group
    @group = Group.new
    @group.assign_attributes(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to group_url(@group), notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    authorize Group
    @group.assign_attributes(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    authorize Group
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(attribute: 'gidNumber', value: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params[:group][:uniqueMember] ||= []
      params.require(:group).permit(:cn, :gid_number, uniqueMember: [])
    end

    def not_authorized
      redirect_to user_path(current_user)
    end
end
