# 🚀 Terraform Demo Project

*A hands-on demonstration of Terraform infrastructure provisioning with Kubernetes integration*

![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.5.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

---

## 🌟 Features

- **Kubernetes Integration** - Manage cluster resources through Terraform
- **Dynamic Configuration** - Use variables for flexible deployments
- **Dev-Friendly Setup** - Optional Neovim + LazyVim configuration
- **Reproducible Infrastructure** - Full lifecycle management

---

## 🧭 Table of Contents

- [✨ Quick Start](#-quick-start)
- [⚙️ Prerequisites](#️-prerequisites)
- [📦 Installation](#-installation)
- [🚀 Deployment](#-deployment)
- [🔧 Development Setup](#-development-setup)
- [📚 Resources](#-resources)
- [🧹 Cleanup](#-cleanup)

---

## ✨ Quick Start

```bash
# Clone & Deploy
git clone https://github.com/jyasuu/terraform-demo.git
cd terraform-demo
terraform init
terraform apply -var="host=whoami.localhost"
```

---

## ⚙️ Prerequisites

- 🐧 Linux environment (Ubuntu/Debian recommended)
- 🛠️ `sudo` privileges
- 📦 Package managers: `apt`, `curl`, `wget`

---

## 📦 Installation

### 1. Install Terraform
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### 2. Clone Repository
```bash
git clone https://github.com/jyasuu/terraform-demo.git
cd terraform-demo
```

---

## 🚀 Deployment

### Initialize Infrastructure
```bash
terraform init
```

### Preview Changes
```bash
terraform plan
```

### Apply Configuration
```bash
terraform apply -replace time_static.deployed_at -var="host=whoami.localhost"
```

> 📝 **Note:** Use `-replace` to force resource recreation and `-var` for custom parameters

---

## 🔧 Development Setup

### Neovim + LazyVim Configuration
```bash
# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Configure LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

> 💡 **Pro Tip:** Add Neovim to your permanent PATH in `~/.bashrc` or `~/.zshrc`

---

## 📚 Resources

| Resource | Description |
|----------|-------------|
| [📖 Terraform Registry](https://registry.terraform.io) | Official provider documentation |
| [📖 Terraform Kubernetes Registry](https://registry.terraform.io/providers/hashicorp/kubernetes/latest) | Official provider documentation |
| [🎮 Kubernetes Playground](https://killercoda.com/playgrounds/scenario/kubernetes) | Interactive learning environment |
| [⚡ LazyVim Docs](https://www.lazyvim.org/) | Modern Neovim configuration guide |
| [🔗 Terraform CLI Reference](https://developer.hashicorp.com/terraform/cli) | Command-line documentation |

---

## 🧹 Cleanup

To destroy all provisioned resources:
```bash
terraform destroy
```

---

## 🎯 Tips & Tricks

```bash
# Format configuration files
terraform fmt

# Validate configuration syntax
terraform validate

# Check required versions
terraform version
```

> ⚠️ **Important:** Always store sensitive values in environment variables rather than command-line flags!

---

**Built with ❤️ by [jyasuu](https://github.com/jyasuu)*

