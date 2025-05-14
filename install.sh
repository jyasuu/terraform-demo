#!/bin/bash

# Script to install environment for terraform-demo project

echo "🚀 Starting environment setup for terraform-demo..."

# --- Prerequisites Check (Informational) ---
echo "ℹ️ Please ensure you have a Linux environment (Ubuntu/Debian recommended) with sudo privileges."
echo "ℹ️ Required package managers: apt, curl, wget."
echo "--------------------------------------------------"
sleep 2

# --- 1. Install Terraform ---
echo "⚙️ Installing Terraform..."
if command -v terraform &> /dev/null
then
    echo "✅ Terraform is already installed."
    terraform version
else
    wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y terraform
    if [ $? -eq 0 ]; then
        echo "✅ Terraform installed successfully."
        terraform version
    else
        echo "❌ Error installing Terraform. Please check the output above."
        exit 1
    fi
fi
echo "--------------------------------------------------"
sleep 1

# --- 2. Install OpenTofu ---
echo "⚙️ Installing OpenTofu..."
if command -v tofu &> /dev/null
then
    echo "✅ OpenTofu is already installed."
    tofu version
else
    # Download the installer script
    curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
    # Alternatively: wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh

    # Give it execution permissions
    chmod +x install-opentofu.sh

    echo "ℹ️ Please inspect the downloaded OpenTofu installer script (install-opentofu.sh) if you wish."
    read -p "Proceed with OpenTofu installation? (y/N): " confirm_tofu
    if [[ "$confirm_tofu" =~ ^[Yy]$ ]]; then
        # Run the installer
        sudo ./install-opentofu.sh --install-method deb
        # Remove the installer
        rm -f install-opentofu.sh
        if [ $? -eq 0 ]; then
            echo "✅ OpenTofu installed successfully."
            tofu version
        else
            echo "❌ Error installing OpenTofu. Please check the output above."
            # exit 1 # Decided not to exit if Tofu fails, as Terraform might be primary
        fi
    else
        echo "⏩ Skipping OpenTofu installation."
        rm -f install-opentofu.sh
    fi
fi
echo "--------------------------------------------------"
sleep 1

# --- 3. Install Neovim (Optional) ---
read -p "🔧 Do you want to install Neovim and configure LazyVim? (y/N): " install_neovim
if [[ "$install_neovim" =~ ^[Yy]$ ]]; then
    echo "⚙️ Installing Neovim..."
    if command -v nvim &> /dev/null && [[ $(nvim --version | head -n 1) == *"NVIM v0.9."* || $(nvim --version | head -n 1) == *"NVIM v0.1"* ]]; then # crude check for recent enough version
        echo "✅ Neovim seems to be already installed and might be a recent version."
        nvim --version | head -n 1
    else
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        rm nvim-linux-x86_64.tar.gz
        echo "✅ Neovim downloaded and extracted to /opt/nvim-linux-x86_64"
        echo "📢 To use this Neovim version, add it to your PATH:"
        echo '   export PATH="$PATH:/opt/nvim-linux-x86_64/bin"'
        echo "   Consider adding this line to your ~/.bashrc or ~/.zshrc"
        # Attempt to add to .bashrc if it exists and not already there
        if [ -f ~/.bashrc ] && ! grep -q 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' ~/.bashrc; then
            echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
            echo "✅ Added Neovim to PATH in ~/.bashrc. Please source it or open a new terminal."
        fi
    fi

    echo "⚙️ Configuring LazyVim..."
    if [ -d ~/.config/nvim ]; then
        read -p "⚠️ ~/.config/nvim already exists. Do you want to remove it and clone LazyVim starter? (y/N): " replace_nvim_config
        if [[ "$replace_nvim_config" =~ ^[Yy]$ ]]; then
            rm -rf ~/.config/nvim
            git clone https://github.com/LazyVim/starter ~/.config/nvim
            echo "✅ LazyVim starter cloned to ~/.config/nvim."
        else
            echo "⏩ Skipping LazyVim configuration."
        fi
    else
        git clone https://github.com/LazyVim/starter ~/.config/nvim
        echo "✅ LazyVim starter cloned to ~/.config/nvim."
    fi
else
    echo "⏩ Skipping Neovim and LazyVim setup."
fi
echo "--------------------------------------------------"
sleep 1

# --- 4. Clone Repository ---
echo "📦 Cloning the terraform-demo repository..."
if [ -d "terraform-demo" ]; then
    echo "✅ 'terraform-demo' directory already exists. Skipping clone."
else
    git clone https://github.com/jyasuu/terraform-demo.git
    if [ $? -eq 0 ]; then
        echo "✅ Repository cloned successfully into 'terraform-demo'."
        # cd terraform-demo # Optionally cd into the directory
    else
        echo "❌ Error cloning repository. Please check the output above."
        exit 1
    fi
fi
echo "--------------------------------------------------"

echo "🎉 Environment setup script finished!"
echo "Next steps:"
echo "1. If Neovim was installed/updated, ensure /opt/nvim-linux-x86_64/bin is in your PATH (you might need to source your .bashrc/.zshrc or open a new terminal)."
echo "2. Navigate to the repository: cd terraform-demo"
echo "3. Initialize Terraform/OpenTofu: terraform init or tofu init"
echo "4. Refer to the README.md for deployment instructions."

