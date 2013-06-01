let
  # Insert your access key here
  accessKey = "AKIAJPZSW4AZW4K4TNBQ";
in {
  # Mapping of our 'helloserver' machine
  helloserver = { resources, ... }:
    { deployment.targetEnv = "ec2";
      # We'll be deploying a micro instance to Virginia
      deployment.ec2.region = "us-east-1";
      deployment.ec2.instanceType = "t1.micro";
      deployment.ec2.accessKeyId = accessKey;
      # We'll let NixOps generate a keypair automatically
      deployment.ec2.keyPair = resources.ec2KeyPairs.helloapp-kp.name;
      # This should be the security group we just created
      deployment.ec2.securityGroups = [ "zef-test" ];
    };

  # Here we create a keypair in the same region as our deployment
  resources.ec2KeyPairs.helloapp-kp = {
    region = "us-east-1";
    accessKeyId = accessKey;
  };
}
