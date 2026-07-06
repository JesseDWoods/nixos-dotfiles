{
    config, pkgs, ... }:

let
	dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

	configs = {
		mango = "mango";
		vim = "vim";
		emacs = "emacs"; 
		rofi = "rofi";
		waybar = "waybar";
		foot = "foot";
	};
	in

	{	
		home.username = "jwoods";
		home.homeDirectory = "/home/jwoods";
		programs.git.enable = true;
		home.stateVersion = "26.05";
		programs.bash = {
			enable = true;
			shellAliases = {
				nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
			};
			
		};
		programs.ssh = {
    			enable = true;
			enableDefaultConfig = false;
			settings."*" = {
				ForwardAgent = false;
				AddKeysToAgent = "no";
				Compression = false;
				ServerAliveInterval = 0;
				ServerAliveCountMax = 3;
				HashKnownHosts = false;
				UserKnownHostsFile = "~/.ssh/known_hosts";
				ControlMaster = "no";
				ControlPath = "~/.ssh/master-%r@%n:%p";
				ControlPersist = "no";
			};
    			settings = {
      				"github.com" = {
        				hostname = "github.com";
        				identityFile = "~/.ssh/id_ed25519";
      				};
    			};
  		};
		programs.swaylock = {
    			enable = true;
    			settings = {
      				color = "282828";
                    inside-color = "B3DEEF";
                    ring-color = "FFC24B";
      				indicator-idle-visible = false;
      				show-failed-attempts = true;
   			 };
 		 };

  		services.swayidle = {
            		enable = true;
            		timeouts = [
                		{
                    			timeout = 300;
                    			command = "${pkgs.swaylock}/bin/swaylock -f";
                		}
            		];
			events = {
  				before-sleep = "${pkgs.swaylock}/bin/swaylock -fF";
  				#"lock" = "lock";
			};
        	};	
  		programs.emacs = {
    			enable = true;
    			package = pkgs.emacs-pgtk;
  		};
		xdg.configFile = builtins.mapAttrs
			(name: subpath: {
				source = create_symlink "${dotfiles}/${subpath}";
				recursive = true;
			})
			configs;


		home.packages = with pkgs; [
			swaybg
			rofi
			waybar
			pavucontrol
			networkmanagerapplet
			libreoffice
			rust-analyzer
			vim
			fzf
			ripgrep
			nodejs
			fd
			git
			gcc
			clang-tools
			foliate
		];
	}
