img_name=$1
img_flavour=$2
# fully qualified name for image
img_fqn=""
[[ -z "$img_flavour" ]] && img_fqn=$img_name || img_fqn=$img_name-$img_flavour
img_tag=$img_fqn
commit_sha=$GITHUB_SHA
# extract tag from GITHUB_REF if any
tag=$(echo $GITHUB_REF | grep -o -E 'tags[^ ]+' | sed 's/tags\///')

echo "Building image "$img_tag

# change to the directory where the Dockerfile exists 
cd $img_name
docker build \
   --network host \
   --label ade_image_commit_sha="$commit_sha" \
   --label ade_image_commit_tag="$tag" \
   -t "$img_tag":latest .

