img_name=$1
img_flavour=$2
registry=$3
# fully qualified name for image
img_fqn=""
[[ -z "$img_flavour" ]] && img_fqn=$img_name || img_fqn=$img_name-$img_flavour

echo "Tagging "$img_fqn:latest
echo "Pushing to "$registry:latest

docker tag $img_fqn:latest $registry:latest
docker push $registry:latest


