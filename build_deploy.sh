
if [ -d "./public" ]; then
  cp -r public public-backup
fi

npm run clean
npm run generate
npm run deploy

if [ -d "./public" ]; then
  cp -r Assets ./public/Assets
fi

if [ -d "./public" ];
then
  rm -r public-backup
else
  mv public-backup public
  exit 0
fi


git add .
git commit -m "chore: upload repo"
git push

# update algolia
export HEXO_ALGOLIA_INDEXING_KEY='a6accc6480b4a9053d9905fa81d61d9c'
hexo algolia


