#cloud-config
hostname: axion-1
users:
  - name: axn
    groups: sudo
    shell: /bin/bash
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjqDHB6Y6ihRVKQqfLpQUvYbMgu2DDDmlzvqU+lIU54 khushmeet@hey.com

package_update: true
package_upgrade: true

packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - gnupg-agent
  - software-properties-common
  - fail2ban

runcmd:
  - |
    echo 'PS1="\[$(tput smul)$(tput bold)$(tput setaf 3)$(tput setab 0)\]\u@\h\[$(tput rmul)\]\[$(tput bold)$(tput setaf 3)$(tput setab 0)\]:\[$(tput rev)\]\w [\$(date +%H:%M:%S)] ->\[$(tput sgr0)\] "' >> /home/axn/.bash_profile
    echo 'ulimit -c unlimited' >> /home/axn/.bash_profile
    echo 'umask 022' >> /home/axn/.bash_profile
    echo 'set -o vi' >> /home/axn/.bash_profile
    echo 'alias ls="/bin/ls -GFC"' >> /home/axn/.bash_profile
    echo 'alias ll="/bin/ls -6x"' >> /home/axn/.bash_profile
    echo 'alias c="clear"' >> /home/axn/.bash_profile
    echo 'alias d="date"' >> /home/axn/.bash_profile
    echo 'id' >> /home/axn/.bash_profile
    echo 'ps x' >> /home/axn/.bash_profile
    chown axn:axn /home/axn/.bash_profile
  - [ sed, -i, -e, '/^#Port/s/^.*$/Port 43/', /etc/ssh/sshd_config ]
  - [ sed, -i, -e, '/^#PermitRootLogin/s/^.*$/PermitRootLogin no/', /etc/ssh/sshd_config ]
  - [ sed, -i, -e, '/^#PasswordAuthentication/s/^.*$/PasswordAuthentication no/', /etc/ssh/sshd_config ]
  - [ sed, -i, -e, '/^#PubkeyAuthentication/s/^.*$/PubkeyAuthentication yes/', /etc/ssh/sshd_config ]
  - [ sh, -c, "echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config" ]
  - [ install, -m, '0755', -d, /etc/apt/keyrings ]
  - [ sh, -c, "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg" ]
  - [ chmod, a+r, /etc/apt/keyrings/docker.gpg ]
  - [ sh, -c, 'echo "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null' ]
  - [ sh, -c, "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null" ]
  - [ sh, -c, "curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list" ]
  - [ apt, update, -y ]
  - [ apt, install -y, tailscale, docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, docker-compose-plugin ]
  - [ tailscale, up, -authkey, ${tailscale_key} ]
  - [ ufw, allow, in, on, tailscale0 ]
  - [ ufw, enable ]
  - [ ufw, default, deny, incoming ]
  - [ ufw, default, allow, outgoing ]
  - [ ufw, reload ]
  - [ systemctl, reload, sshd ]




power_state:
  timeout: 300
  message: Rebooting in 5 minutes.
  mode: reboot