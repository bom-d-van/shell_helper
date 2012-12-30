echo 'Installing Shell Helper'

# copy shell_helper.sh into user's home directory
cp shell_helper.sh ~/.shell_helper

# concat a source command into ~/.bash_profile
echo '' >> ~/.bash_profile
echo 'source .shell_helper' >> ~/.bash_profile

echo 'Shell Helper Installed'