rm -rf docs/html
rm -rf docs/doctrees
make html
git add .
git commit -a -m $1
git push