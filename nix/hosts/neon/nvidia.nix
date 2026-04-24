{ config, pkgs, ... }:
{
  # NVIDIA proprietary driver (Wayland + CUDA support)
  hardware.nvidia = {
    modesetting.enable = true; # required for Wayland
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # proprietary driver, more stable than open module
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable; # 595.58.03
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # GPU acceleration (OpenGL / Vulkan / VA-API)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Required environment variables for Wayland + NVIDIA (Hyprland)
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  # CUDA support
  # nixpkgs.config.cudaSupport = true;

  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit # CUDA toolkit
    nvtopPackages.nvidia # GPU monitor
  ];
}
