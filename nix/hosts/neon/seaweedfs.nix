{ ... }:
{
  services.seaweedfs = {
    master = {
      enable = true;
      port = 9333;
    };

    volume = {
      enable = true;
      port = 8080;
      mserver = [ "localhost:9333" ];
    };

    filer = {
      enable = true;
      port = 8888;
      master = [ "localhost:9333" ];
    };

    s3 = {
      enable = true;
      port = 8333;
      filer = "localhost:8888";
      # config file for buckets and credentials: /etc/seaweedfs/s3.json
    };
  };

  # S3 API port — accessible within Tailscale network only
  networking.firewall.allowedTCPPorts = [ 8333 ];
}
