
if [ -d "./public" ]; then
  cp -r public public-backup
fi

./node_modules/.bin/hexo clean
./node_modules/.bin/hexo g
./node_modules/.bin/hexo d

if [ -d "./public" ]; then
  cp -r Assets ./public/Assets
fi

git add .
git commit -m "chore: upload repo"
git push

# update algolia
export HEXO_ALGOLIA_INDEXING_KEY='a6accc6480b4a9053d9905fa81d61d9c'
hexo algolia

if [ -d "./public" ];
then
  rm -r public-backup
else
  mv public-back public
fi

