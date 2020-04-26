# change to the directory where the Dockerfile exists
cd $1
docker build \
   --network host \
   --label ade_image_commit_sha="$GITHUB_SHA" \
   --label ade_image_commit_tag="$GITHUB_REF" \
   -t "$1" .

