echo $1
echo $GITHUB_SHA
echo $GITHUB_REF
pwd
ls


docker build \
   --network host \
   --label ade_image_commit_sha="$GITHUB_SHA" \
   --label ade_image_commit_tag="$GITHUB_REF" \
   -t "$1" \
   --file $1

