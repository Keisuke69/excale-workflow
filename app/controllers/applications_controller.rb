require "aws-sdk"
require 'job'

class ApplicationsController < ApplicationController
  # GET /applications
  # GET /applications.json

  def get_all_instances
    @access_key = Parameter.find(:first,:conditions => {:key => "aws_access_key"})
    @secret_key = Parameter.find(:first,:conditions => {:key => "aws_secret_access_key"})
    @region = "ec2.ap-northeast-1.amazonaws.com"

    AWS.config(:access_key_id => access_key['value'],:secret_access_key => secret_key['value'],:ec2_endpoint => region)

    h = Hash.new
    begin
        ec2 = AWS::EC2.new()
        instances = ec2.instances()
        instances.each { | instance |
          name = instance.tags['Name']
          h[name] = "#{name}(#{instance.id})"
        }
        p h
    rescue  => e
        puts e
    end   
  end

  
  def index
    @applications = Application.find(:all,:conditions => ["status = ? or status = ? ",0,2] ,:order => "apply_date desc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @applications }
    end
  end

    def index_all
    @applications = Application.find(:all,:order => "apply_date desc")

    respond_to do |format|
      format.html {render "index"}
      format.json { render json: @applications }
    end
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
    #表示は誰でもできる
    @application = Application.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @application }
    end
  end

  # GET /applications/new
  # GET /applications/new.json
  def new

    #申請は誰でもできる
    @application = Application.new
    user = User.find_by_user(@login_user)
    puts user

    @application['user_id'] = user.id
    @application['user'] = user

    @instances = get_all_instances

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @application }
    end
  end

  # GET /applications/1/edit
  def edit
    @application = Application.find(params[:id])
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = Application.new(params[:application])
    p @params
    user = User.find_by_user(params['requester'])
    puts user

    @application['user_id'] = user.id
    @application['status'] = 0
    @application['apply_date'] = Time.now


    @application['to'] = params[:application]['to'].join(",")

    respond_to do |format|
      if @application.save
        format.html { redirect_to :action => "index", notice: 'Application was successfully created.' }
        format.json { render json: @application, status: :created, location: @application }
      else
        format.html { render action: "new" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /applications/1
  # PUT /applications/1.json
  def update

    unless @login_user_role == "1"
      flash[:error] =  "You don't have paermission."
      redirect_to :action => "index"
      return
      p "hoge"
    end

    #approveおよびdenyは承認者権限のみなのでチェックが必要
    @application = Application.find(params[:id])
    result = false
    if params['commit'] == "approve"
      result = @application.update_attribute("status",1)





      #ary = ParseDate::parsedate(@application['start']) #=> [2001, 5, 24, 22, 56, 30, "JST", 4]
      #t = Time::local(*ary[0..-3]) #=> Thu May 24 22:56:30 JST 2001

#2013-06-13 20:56:11 UTC

      starttime = Time.strptime(@application['start'].to_s, '%Y-%m-%d %H:%M:%S')
      endtime = Time.strptime(@application['start'].to_s, '%Y-%m-%d %H:%M:%S')

      job = Job.new

      #sgの算出処理必要
      #job.send_at starttime, :authorize_ingress_from_gw_to_target, @access_key, @secret_access_key, @region,sg
      #job.send_at endtime, :revoke_ingress_from_gw_to_target, @access_key, @secret_access_key, @region,sg


    elsif params['commit'] == "deny"
      result = @application.update_attribute("status",2)
    end
    respond_to do |format|
      if result
        format.html { redirect_to :action => "index", notice: 'Application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application = Application.find(params[:id])
    @application.destroy

    respond_to do |format|
      format.html { redirect_to applications_url }
      format.json { head :no_content }
    end
  end
end
