{config, ...}: {
     virtualisation.oci-containers.containers."nginx" = {
       image = "docker.io/nginx:alpine";
        environmentFiles = [

        ];
   };
}
