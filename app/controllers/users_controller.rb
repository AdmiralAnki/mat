class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]
  
   helper_method :current_user
  # GET /users
  # GET /users.json
  def index
    if session[:admin_id] == nil 
      redirect_to action:"admin"

    else
    @users = User.where(status:'false')
  end
  end

  # GET /users/1
  # GET /users/1.json
  
  
  def show
    @user="Wait for Admin approval"
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit

  end

  def approve
    if session[:admin_id] == nil
      redirect_to  action: "admin"
    else
    @user = User.find(params[:u_id])
    @user.status = 'true'
      @user.save
      #puts("\n\n",@user.age,"aaaa\n\n")
   
      #puts("\n\n",@user.age,"bbbb\n\n")
    
    redirect_to action: "index"
    end
  end

  # POST /users
  # POST /users.json pa
  def create

    ql = params[:qual]
          if(ql == "10")
              qu = 1
          elsif (ql =="12")
              qu = 2
          elsif (ql == "grad")
              qu = 3
          else
              qu = 4
          end 
    @user = User.new(:name => params[:name], :email => params[:email], :password => params[:password], :age => params[:age], :caste => params[:caste], :gender => params[:gender], :city => params[:city], :religion => params[:religion], :phone => params[:phone], :qualification => params[:qual],:qrank =>qu ,:current_job => params[:job], :status => params[:status],)
    @user.password = BCrypt::Password.create(@user.password)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  

  # DELETE /users/1
  # DELETE /users/1.json
  
  def welcome_page
  end

   def login_auth
    #user = User.authenticate(params[:email], params[:password])

    @c_user = User.where("email = '#{params[:email]}' ")

    if(@c_user[0] && @c_user[0].status==true && BCrypt::Password.new(@c_user[0].password) == params[:password])
      session[:user_id] = @c_user[0].id
      redirect_to action: "user_page", notice: "Logged in!"
    else
      flash.now[:error] = 'please enter valid email/password '
      #redirect_to action: "index"
      render 'login'
      #redirect_to action: "index"
    end
  end

  def login
  end
  def logout
    #session.delete(:user_id)
    session[:user_id] = nil
    redirect_to action: "login", notice: 'Logged out!'
  end
  def admin
  end
  def admin_auth
    if(params[:email]=="admin123@gmail.com"&&params[:password]=="admin123@gmail.com")
      session[:admin_id] =params[:email]
      redirect_to action: "index"
    else
      flash.now[:error] = 'please enter valid AdminId/password '
      render 'admin'
    end
  end
  
  def admin_logout
    session[:admin_id] = nil
    redirect_to action: "admin"
  end
  #Ankit's code
  def user_page
    if session[:user_id] == nil
      redirect_to  action: "login"
    end  
  end

  def search
    if session[:user_id] == nil
      redirect_to  action: "login"
    else
        @gen = params[:gender]
        @cit = params[:city]
        @minAge = params[:min_age]
        @maxAge = params[:max_age]
        @rel = params[:religion]
        @cas = params[:caste]
        @job = params[:job]

        ql = params[:qual]    
        stat = 1
        @matches = User.where(User.arel_table[:id].does_not_match(session[:user_id]))
        @matches = @matches.where('status LIKE ?', stat)

        if @gen.present?
          @matches=@matches.where('gender LIKE ?', @gen)
        end

        if @cit.present?
          @matches=@matches.where('city LIKE ?', @cit)
        end
    
        if @minAge.present?
          @matches=@matches.where('age >= ?', @minAge)
        end

        if @maxAge.present?
          @matches=@matches.where('age <= ?', @maxAge)
        end

        if @rel.present?
          @matches = @matches.where('religion LIKE ?', @rel)
        end

        if @cas.present?
          @matches = @matches.where('caste LIKE ?', @cas)
        end
        
        if @job.present?
          @matches = @matches.where('current_job LIKE ?', @job)
        end
    
        if ql.present?
          if(ql == "10")
              qu = 1
          elsif (ql =="12")
              qu = 2
          elsif (ql == "grad")
              qu = 3
          else
              qu = 4
          end 
          @matches = @matches.where('qrank >= ?', qu)     
        end
    end
  end
  def search_profile
  end
  
  def express
    if session[:user_id] == nil
      redirect_to  action: "login"
    else
      @toid = params[:to_id]
      @fid =  session[:user_id]
      
      @test = Request.where("from_id LIKE ? AND to_id LIKE ?",@fid,@toid)

      if @test.present?
        render(html: "<script>alert('You have already sent a message to this person!(click back to navigate to search)')</script>".html_safe,layout: 'application')
        else
          Request.create("from_id"=>@fid,"to_id"=>@toid)    
      end
      
    end
  end

  def view_messages
    @fname2 = session[:user_id]
    @mess = Request.where('to_id LIKE ?',@fname2 ).select('from_id')

    for i in @mess
        if @n.present?
              @n = @n+User.where('id LIKE ?',i.from_id ).select('name')
        else
            @n = User.where('id LIKE ?',i.from_id ).select('name')
        end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :age, :caste, :gender, :address, :religion, :phone, :qualification, :current_job, :status)
    end
    def current_user
      #----------------------- modified wed 3:28pm  ------------------
      @current_user ||= session[:user_id] && User.find(session[:user_id]) 
    end
end
