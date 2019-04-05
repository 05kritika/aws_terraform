# encoding: utf-8


title 'two tier setups'

# load data from terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

INTANCE_ID = params['instance_id']['value']
ELB_DNS = params['elb_address']['value']
VPC_ID = params['vpc_id']['value']
AMI_ID = params['ami_id']['value']
EC2_SECURITY_GROUP = params['ec2_security_group']['value']
ELB_SECURITY_GROUP = params['elb_security_group']['value']
# execute test
describe aws_vpc(vpc_id: VPC_ID) do
  its('cidr_block') { should cmp '10.0.0.0/16' }
end

describe aws_security_group(group_name: 'terraform_example') do
  it { should exist }
  its('group_name') { should eq EC2_SECURITY_GROUP }
  its('description') { should eq 'Used in the terraform' }
  its('vpc_id') { should eq VPC_ID }
end

describe aws_security_group(group_name: 'terraform_example_elb') do
  it { should exist }
  its('group_name') { should eq ELB_SECURITY_GROUP }
  its('description') { should eq 'Used in the terraform' }
  its('vpc_id') { should eq VPC_ID }
end

describe aws_ec2_instance(INTANCE_ID) do
  it { should exist }
  its('instance_type') { should eq 't2.micro' }
  its('image_id') { should eq AMI_ID }
  its('state') {should be_in ['pending', 'running', 'shutting-down', 'terminated', 'stopping', 'stopped']}
  it { should_not have_roles }
end


describe aws_elb(ELB_DNS) do
    it { should exist }
    its ('dns_name')  { should eq ELB_DNS }
end
