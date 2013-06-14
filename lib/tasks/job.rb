class Job
@vpc_id = ""

@target_security_group = "base"
@port = 22

def authorize_ingress_from_gw_to_target (access_key,secret_key,region,sg)
  AWS.config(:access_key_id => access_key, :secret_access_key => secret_key, :ec2_endpoint => region)

  begin
    ec2 = AWS::EC2.new()
    target_sg = ec2.security_groups.find{|s| s.name == sg and s.vpc_id == @vpc_id}
    gw_sg = ec2.security_groups.find{|s| s.name == 'gw' and s.vpc_id == @vpc_id}
    target_sg.authorize_ingress(:tcp, @port, { :group_id => gw_sg.group_id })
  rescue  => e
    puts e
  end
end

def revoke_ingress_from_gw_to_target (access_key,secret_key,region,sg)
  AWS.config(:access_key_id => access_key, :secret_access_key => secret_key, :ec2_endpoint => region)

  begin
    ec2 = AWS::EC2.new()
    target_sg = ec2.security_groups.find{|s| s.name == sg and s.vpc_id == @vpc_id}
    gw_sg = ec2.security_groups.find{|s| s.name == 'gw' and s.vpc_id == @vpc_id}
    target_sg.revoke_ingress(:tcp, @port, { :group_id => gw_sg.group_id })
  rescue  => e
    puts e
  end
end

    def test
        puts "This is delayed job at " + Time.now.to_s
    end
end