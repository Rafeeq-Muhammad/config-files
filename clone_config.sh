git clone git@github.com:Rafeeq-Muhammad/config-files.git ~/config-temp
mv ~/config-temp/* ~/config-temp/.* ~/.config 2>/dev/null
rm -rf ~/config-temp
cd ~/.config
git init
git remote -v
git remote remove origin
git remote add origin git@github.com:Rafeeq-Muhammad/config-files.git

