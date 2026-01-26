# /hosts/alns/services/containers/echo.nix
{
   virtualisation.oci-containers.containers.echo-http-service = {
      image = "hashicorp/http-echo";
      cmd = [ "-text" "Hello World!!" ];
      ports = [ "5678:5678" ];
   };
}
