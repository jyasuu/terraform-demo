# terraform-demo

## scripts

### install terraform
```sh
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```
### clone this project
```sh
git clone https://github.com/jyasuu/terraform-demo.git
cd terraform-demo
```
### install nvim & lazyvim
```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
git clone https://github.com/LazyVim/starter ~/.config/nvim
nvim

```
### terraform commands
```sh
terraform init
terraform plan
terraform apply -replace time_static.deployed_at -var="host=whoami.localhost"
```




## resources

- [terraform registry](https://registry.terraform.io/providers/hashicorp/kubernetes/latest)
- [k8s playground](https://killercoda.com/playgrounds/scenario/kubernetes)

