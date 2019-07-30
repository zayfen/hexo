cp themes/next/_config.yml theme_config/next/_config.yml
hexo g && hexo d

git add .
git commit -m "chore: upload config"
git push
