img_name=$1
img_flavour=$2
# fully qualified name for image
img_fqn=""
[[ -z "$img_flavour" ]] && img_fqn=$img_name || img_fqn=$img_name-$img_flavour
img_tag=$img_fqn
registry='sumanthnirmal/ade-volumes'

echo "Tagging "$img_tag 
echo "Pushing to "$registry:$img_tag

docker tag $img_tag:latest $registry:$img_tag
docker push $registry:$img_tag


